require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/test_secret.rb'  #FILL IN ACCOUNT/PASSWD AS GLOBALS IN THIS

class TestFiconabses < Test::Unit::TestCase

  def setup
    @account=ACCOUNT   #in test_secret.rb put ACCOUNT='youraccount' or insert your parameters direclty here  eg @ACCOUNT='myaccount'
    @passwd=PASSWD   #in test_secret.rb put PASSWD='yourpasswd'
    @destination=DESTINATION   # eg your email address 'xxx@yyyy.com'
    
  end
  def test_creds
    puts "CREDENTIALS ARE: account: #{@account} passwd: #{@passwd}"
   # self assert true
  end
  def test_send_text_direct
    puts 'SEND TEXT DIRECT'
    res =FiconabSES::Base.send_textemail_direct(@account,@passwd,@destination,'This is the subject','contents of the email')
    #puts "RES is: #{res}"
    assert res.include? '200'
  end
  def test_send_html_direct
    puts "SEND HTML DIRECT"
    res =FiconabSES::Base.send_htmlemail_direct(@account,@passwd,@destination,'This is the HTML subject','<h1>HTML Contents</h1><p>hi from paragraph</p>','text contents of the email')
    #puts "RES is: #{res}"
    assert res.include? '200'
  end
  def test_send_html_nil_text
     puts "SEND HTML with NIL text"
     res =FiconabSES::Base.send_htmlemail_direct(@account,@passwd,@destination,'This is HTML Subject nil text','<h1>HTML Contents</h1><p>hi from paragraph</p>')  #no text portion
     puts "RES is: #{res}"
     assert res.include? '200'
   end
   def test_send_emails
        f=FiconabSES::Base.new
        f.set_credentials(@account,@passwd)
       res =f.send_htmlemail(@destination,'This is HTML Subject nil text','<h1>HTML Contents</h1><p>hi from paragraph</p>')  #no text portion
       #puts "RES is: #{res}"
       assert res.include? '200'
       res =f.send_textemail(@destination,'This is TEXT Subject nil text','contents')  #no text portion
       # puts "RES is: #{res}"
        assert res.include? '200'
     end
      def test_no_credentials
           f=FiconabSES::Base.new
           assert_raise RuntimeError do   #should raise runtime error
              res =f.send_htmlemail(@destination,'This is HTML Subject nil text','<h1>HTML Contents</h1><p>hi from paragraph</p>')  #no text portion
            end
       end    
end
