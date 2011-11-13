require 'rubygems'
require 'timeout'
gem 'httpclient'
require 'httpclient'
gem 'nokogiri'
require 'nokogiri'

module Ficonab
  class Base
    attr_accessor :host,:account,:password,:uri,:clnt,:extheader

     @@host= 'localhost:8083'
  def self.send_textemail(account,password,destination,subject,contents)
       f=Ficonab::Base.new
       f.send_textemail(account,password,destination,subject,contents)
  end
  def perform(account,password,url)
     @uri=URI.parse(url)
    res=''
     begin
       # Don't take longer than 60 seconds  -- incase there is a problem with the server continue
       Timeout::timeout(60) do
         @clnt=HTTPClient.new 
         @clnt.set_auth(nil, account, password)   
         @extheader = { 'Content-Type' => 'application/xml' }
         res=self.clnt.get_content(self.uri,self.extheader)
       end
     rescue Timeout::Error
       # Too slow!!
      res="failure to connect"
     end
      
         res
    
  end
  def send_textemail(account,password,destination,subject,contents)
   

url="http://#{@@host}/ficonabsendemail?destination=#{URI.encode(destination)}&text=#{URI.encode(contents)}&subject=#{URI.encode(subject)}"   
    puts "url is: #{url}"
     perform(account,password,url)
     #  res
end

   end    # Class
end    #Module