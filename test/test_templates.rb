require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/test_secret.rb'  #FILL IN ACCOUNT/PASSWD AS GLOBALS IN THIS

class TestFiconabses < Test::Unit::TestCase

  def setup
    @account=ACCOUNT   #in test_secret.rb put ACCOUNT='youraccount' or insert your parameters direclty here  eg @ACCOUNT='myaccount'
    @passwd=PASSWD   #in test_secret.rb put PASSWD='yourpasswd'
    puts "CREDENTIALS ARE: account: #{@account} passwd: #{@passwd}"
    @destination=DESTINATION
  end
  
  def test_send_template_direct
    res =FiconabSES::Base.send_template_direct(@account,@passwd,@destination,'testtemplate')
    puts "RES is: #{res}"
    assert res.include? '200'
  end
  
   def test_send_template
        f=FiconabSES::Base.new
        f.set_credentials(@account,@passwd)
       res =f.send_template(@destination,'testtemplate')  #no text portion
       puts "RES is: #{res}"
       assert res.include? '200'
      
     end
end