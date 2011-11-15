require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/test_secret.rb'  #FILL IN ACCOUNT/PASSWD AS GLOBALS IN THIS

class TestFiconabses < Test::Unit::TestCase

  def setup
    @account=ACCOUNT   #in test_secret.rb put ACCOUNT='youraccount'
    @passwd=PASSWD   #in test_secret.rb put PASSWD='yourpasswd'
    puts "CREDENTIALS ARE: account: #{@account} passwd: #{@passwd}"
  end
  
  def test_send_text_direct
    res =FiconabSES::Base.send_textemail_direct(@account,@passwd,'scott.sproule@gmail.com','This is the subject','contents of the email')
    puts "RES is: #{res}"
    assert res.include? '200'
  end
  def test_send_html_direct
    res =FiconabSES::Base.send_htmlemail_direct(@account,@passwd,'scott.sproule@gmail.com','This is the HTML subject','<h1>HTML Contents</h1><p>hi from paragraph</p>','text contents of the email')
    puts "RES is: #{res}"
    assert res.include? '200'
  end
  def test_send_html_nil_text
     res =FiconabSES::Base.send_htmlemail_direct(@account,@passwd,'scott.sproule@gmail.com','This is HTML Subject nil text','<h1>HTML Contents</h1><p>hi from paragraph</p>')  #no text portion
     puts "RES is: #{res}"
     assert res.include? '200'
   end
   def test_send_emails
        f=FiconabSES::Base.new
        f.set_credentials(@account,@passwd)
       res =f.send_htmlemail('scott.sproule@gmail.com','This is HTML Subject nil text','<h1>HTML Contents</h1><p>hi from paragraph</p>')  #no text portion
       puts "RES is: #{res}"
       assert res.include? '200'
       res =f.send_textemail('scott.sproule@gmail.com','This is TEXT Subject nil text','contents')  #no text portion
        puts "RES is: #{res}"
        assert res.include? '200'
     end
      def test_no_credentials
           f=FiconabSES::Base.new
           assert_raise RuntimeError do   #should raise runtime error
              res =f.send_htmlemail('scott.sproule@gmail.com','This is HTML Subject nil text','<h1>HTML Contents</h1><p>hi from paragraph</p>')  #no text portion
            end
       end    
end
