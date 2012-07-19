#!/usr/bin/ruby
usage=<<EOF_USAGE

# == Synopsis
#   send a campaignflow using FiconabSES
# == Usage
#  ficonabses_campaign_flow_test.rb -u username -p password -d destination -c campaign_flow
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Example
#   ficonabses_campaign_flow_test.rb -u xxxx -p yyyy -c campaignname -d xxxxe@estormtech.com
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
 arg_hash=FiconabSES::Options.parse_options(ARGV)
 FiconabSES::Options.show_usage_exit(usage) if arg_hash[:help]==true
require 'pp'
 options=arg_hash
  puts "[#{Time.now}] START"
    @f=FiconabSES::Base.new
    @f.set_credentials(options[:username],options[:password])
    @f.set_debug if options[:debug]  # if debug sends to localhost
    hashv={'email' => options[:destination],'tsipid' => options[:tsipid]}
    
    res =@f.send_campaign_flow(options[:destination],options[:campaign_flow],hashv)
 
# puts "response is list is #{list.to_yaml} #{finallist.to_yaml}" 
   puts "[#{Time.now}] FINISHED: result is: #{res}"