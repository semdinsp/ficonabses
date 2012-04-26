module FiconabSES
  class Addons
    def self.send_exception_direct(account,password,destination,exception)
         f=FiconabSES::Base.new
         f.set_credentials(account,password)
         FiconabSES::Addons.send_ruby_exception(f,exception,destination,nil)
    end
    def self.readfile(filename)
        csvfile=File.open(filename,'r') 
        rawfile= FasterCSV.parse(csvfile.read, { :headers           => true})
        rawfile
    end
    def self.send_ruby_exception(ficonab_obj,exception,tolist, other, cclist=[],prefix2='[Exception]')
        begin   
        backtrace=exception.backtrace|| 'No backtrace available'
        puts "backtrace is #{backtrace}"
        other=other.to_s||'no additional data'
        prefix   = "#{prefix2}"
        subj  = "#{prefix2} (#{exception.class}) #{exception.message.inspect}"  
           backtrace=backtrace.join("\n").to_s if backtrace.class!=String
           length=[3800,backtrace.size].min
           backtrace=backtrace.to_s[0..length-1]
           message= "EXCEPTION:\n#{exception.inspect.to_s}\nTIME:\n\n#{Time.now}\nOTHER:\n#{other.to_s}\n\nBACKTRACE:\n\n#{backtrace.to_s}"
           res =ficonab_obj.send_textemail(tolist,subj.to_s,message)
         rescue Exception => e
           puts "Exception in send exception..OOOPS! #{e.message} #{e.backtrace}"
         ensure
          # puts "in ensure"
          res=nil
          message=nil
         
         end
      end
  end  #class
end #module