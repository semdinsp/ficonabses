require 'rubygems'
require 'timeout'
gem 'httpclient'
require 'httpclient'
gem 'nokogiri'
require 'nokogiri'
class Object
  def to_query(key)
    require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
    "#{CGI.escape(key.to_s)}=#{CGI.escape(self.to_s)}"
  end
end
class Hash
  def to_param(namespace = nil)
    collect do |key, value|
      value.to_query(namespace ? "#{namespace}[#{key}]" : key)
    end.sort * '&'
  end
end
module FiconabSES
  class Base
    attr_accessor :host,:account,:password,:uri,:clnt,:extheader

     @@host= 'ses.sg.estormtech.com'
  def set_debug
     @@host= 'localhost:8083'
  end
  def host
     @@host
  end
     # @@host= 'localhost:8083'
  def set_credentials(account,passwd)
      @account=account
      @password=passwd    
  end
  def self.send_textemail_direct(account,password,destination,subject,contents)
       f=FiconabSES::Base.new
       f.set_credentials(account,password)
       f.send_textemail(destination,subject,contents)
  end
  def self.send_htmlemail_direct(account,password,destination,subject,htmlcontents,textcontents=nil)
        f=FiconabSES::Base.new
        f.set_credentials(account,password)
        f.send_htmlemail(destination,subject,htmlcontents,textcontents)
   end
   def self.send_template_direct(account,password,destination,templatename)
         f=FiconabSES::Base.new
         f.set_credentials(account,password)
         f.send_template(destination,templatename)
    end
     def self.send_template_params_direct(account,password,destination,templatename,options={})
           f=FiconabSES::Base.new
           f.set_credentials(account,password)
           f.send_template_params(destination,templatename,options)
      end  
      def self.global_blacklist_direct(account,password,destination)
             f=FiconabSES::Base.new
             f.set_credentials(account,password)
             f.global_blacklist(destination,account)
     end
   def self.send_campaign_flow_direct(account,password,destination,templatename,options={})
               f=FiconabSES::Base.new
               f.set_credentials(account,password)
               f.send_campaign_flow(destination,templatename,options)
  end     
  def build_client
    if @clnt==nil then
     @clnt=HTTPClient.new 
     @clnt.set_auth(nil, @account, @password)   
     @extheader = { 'Content-Type' => 'application/xml' }
   end
      @clnt
  end 
  def client_action(postflag,postdata)
    puts "FLAG: #{postflag} DATA: #{postdata}"
     result=self.clnt.get_content(self.uri,self.extheader) if !postflag
     result = self.clnt.post_content(self.uri, postdata,{'Content-Type' => 'application/x-www-form-urlencoded'}) if postflag
     result
  end
  def perform(url,postflag=false,postdata={})
     @uri=URI.parse(url)
    # puts "url is #{url}"
     raise 'credentials not set' if @account==nil
    res=''
     begin
       # Don't take longer than 60 seconds  -- incase there is a problem with our server continue
         @clnt=self.build_client 
       Timeout::timeout(60) do    
          # original res=self.clnt.get_content(self.uri,self.extheader)
         res=self.client_action(postflag,postdata)
       end
     rescue Timeout::Error,HTTPClient::BadResponseError
          
         # puts "res is #{res.inspect}"
          res='bad response or timeout'
          puts "BAD RESPONSE or Timeout - retrying once #{self.uri} after five seconds"
         sleep(5)   # take a break to see if it is too busy
         Timeout::timeout(25) do   
           # original res=self.clnt.get_content(self.uri,self.extheader)
              res=self.client_action(postflag,postdata)
            puts "RETRY: second chance res is #{res}"
          end
         # bad response  - try it again?
     #rescue Timeout::Error
       # Too slow!!
     # res="failure to connect"
     end
      
         res
    
  end
  def action_url(action,destination)
    url="http://#{@@host}/#{action}?destination=#{URI.encode(destination)}"
    url
  end
  def text_url(destination,subject,contents)
    url="#{self.action_url('ficonabsendemail',destination)}&subject=#{URI.encode(subject)}&text=#{URI.encode(contents)}" 
    url
  end
  def bulk_url
    url="http://#{@@host}/ficonabbulkmanager?"
    puts "BULK URL: #{url}"
    url  
  end
  def global_blacklist_url(destination,username)
    url="#{self.action_url('ficonabaction',destination)}&type=globalunsubscribe&user=#{URI.encode(username)}" 
    url
  end
  def get_template_list_url(destination,username)
    url="#{self.action_url('ficonabaction',destination)}&type=gettemplates&user=#{URI.encode(username)}" 
    url
  end
  def template_url(destination,templatename)
    url="#{self.action_url('ficonabsimpletemplate',destination)}&template=#{URI.encode(templatename)}" 
    url
  end
  def template_url_params(destination,templatename,options)
    url="#{self.action_url('ficonabcomplextemplate',destination)}&template=#{URI.encode(templatename)}&#{options.to_param}" 
    url
  end
  def campaign_flow_params(destination,templatename,options)
     url="#{self.action_url('ficonabcampaignflow',destination)}&campaignflow=#{URI.encode(templatename)}&#{options.to_param}" 
     url
   end
  def html_url(destination,subject,contents,html)
    contents='' if contents==nil
    url="#{self.text_url(destination,subject,contents)}&html=#{URI.encode(html)}"
  end
  def send_textemail(destination,subject,contents)
    url=self.text_url(destination,subject,contents)
    #puts "url is: #{url}"
    perform(url)
     #  res
  end
  def send_bulk(bulkdata)
     url=self.bulk_url
     perform(url,true,bulkdata)
      #  res
   end
  def send_template(destination,templatename)
     url=self.template_url(destination,templatename)
   #  puts "url is: #{url}"
     perform(url)
      #  res
   end
   def send_template_params(destination,templatename,options={})
      url=self.template_url_params(destination,templatename,options)
    #  puts "url is: #{url}"
      perform(url)
       #  res
    end
     def global_blacklist(destination,username)
          url=self.global_blacklist_url(destination,username)
   #       puts "url is: #{url}"
          perform(url)
           #  res
       end
   def get_template_list(destination,username)
               url=self.get_template_list_url(destination,username)
    #           puts "url is: #{url}"
               perform(url)
                #  res
    end
    def send_campaign_flow(destination,campaign_name,options={})
        url=self.campaign_flow_params(destination,campaign_name,options)
    #    puts "url is: #{url}"
        perform(url)
         #  res
     end  
 def send_campaign_flow_old(destination,campaign_name,options={})
           options["destination"]=destination
           url=self.campaign_flow_params(destination,campaign_name,options)
       #    puts "url is: #{url}"
           perform(url)
            #  res
 end
  def send_htmlemail(destination,subject,htmlcontents,textcontents=nil)
      textcontents='-' if textcontents==nil
     url=self.html_url(destination,subject,textcontents,htmlcontents)
     #puts "url is: #{url}" 
     perform(url)
      #  res
   end

   end    # Class
end    #Module