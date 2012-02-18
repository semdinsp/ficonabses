#!/usr/bin/ruby
usage=<<EOF_USAGE

# == Synopsis
#   read a csv file and send through FiconabSES
# == Usage
#  ficonabses_csv.rb -u username -p password -f csvfile.name
# csv file needs to be in the format (including headers) with destination, template, asmanyparameters as needed separated by commas
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Example
#  ficonabses_csv.rb -u xxxx -p yyyy -f yyy.csv
# == Copyright
#    Copyright (c) 2011 Ficonab Pte. Ltd.
#     See license for license details
EOF_USAGE
require 'yaml'
require 'rubygems'
require 'uri'
gem 'ficonabses'
gem 'fastercsv'
require 'fastercsv'
require 'ficonabses'
require 'optparse'
#require 'java' if RUBY_PLATFORM =~ /java/
# start the processing
def send_row(ficonab,row)
   row['destination'].strip!
    row['template'].strip!
    sleep(1)
     res =ficonab.send_template_params(row['destination'],row['template'],row) if row['row']!=''
     
end

def readfile(filename)
    csvfile=File.open(filename,'r') 
    rawfile= FasterCSV.parse(csvfile.read, { :headers           => true})
    rawfile
end
 arg_hash=FiconabSES::Options.parse_options(ARGV)
 FiconabSES::Options.show_usage_exit(usage) if arg_hash[:help]==true
 
require 'pp'
 options=arg_hash
  puts "[#{Time.now}] START"
    @f=FiconabSES::Base.new
    @f.set_credentials(options[:username],options[:password])
    @f.set_debug if options[:debug]  # if debug sends to localhost
     count=0
      #send_template(options[:template],'7923044488','scott.sproule@gmail.com',count+=1)
      rows=readfile(options[:filename])
      rows.each {|row|   
        #puts "row is: #{row}"
        begin
          hash={}
          hash=hash.merge row
          res=send_row(@f,hash)
          puts "COUNT: #{count} result: #{res} row: #{hash} "
        count+=1

        rescue Exception => e
        puts "Found count: #{count} error #{e.inspect}"
        end 
        }
     
 
# puts "response is list is #{list.to_yaml} #{finallist.to_yaml}" 
   puts "[#{Time.now}] FINISHED: sending: #{count}"