require 'rubygems'
require 'timeout'
gem 'httpclient'
require 'httpclient'
gem 'nokogiri'
require 'nokogiri'

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
  def perform(url)
     @uri=URI.parse(url)
     raise 'credentials not set' if @account==nil
    res=''
     begin
       # Don't take longer than 60 seconds  -- incase there is a problem with our server continue
       Timeout::timeout(60) do
         @clnt=HTTPClient.new 
         @clnt.set_auth(nil, @account, @password)   
         @extheader = { 'Content-Type' => 'application/xml' }
         res=self.clnt.get_content(self.uri,self.extheader)
       end
     rescue Timeout::Error
       # Too slow!!
      res="failure to connect"
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
  def template_url(destination,templatename)
    url="#{self.action_url('ficonabsimpleemail',destination)}&template=#{URI.encode(templatename)}" 
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
  def send_template(destination,templatename)
     url=self.template_url(destination,templatename)
     puts "url is: #{url}"
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