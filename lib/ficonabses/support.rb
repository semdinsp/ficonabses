require 'optparse'


module FiconabSES
  class Options
    def self.parse_options(params)
       opts = OptionParser.new
    #   puts "argv are #{params}"
       temp_hash = {}
        opts.on("-u","--username VAL", String) {|val|  temp_hash[:username] = val
                                                puts "#  username is #{val}"   }

      #  opts.on("-h","--host VAL", String) {|val|  temp_hash[:host] = val
     #                                       puts "#  host is #{val}"   }
           opts.on("-d","--destination VAL", String) {|val|  temp_hash[:destination] = val
                                 puts "# email is #{temp_hash[:destination]}"   }
          opts.on("-p","--password VAL", String) {|val|  temp_hash[:password] = val
                                                        puts "# password  is #{temp_hash[:password]}"   }
      
         opts.on("-f","--filename VAL", String) {|val|  temp_hash[:filename] = val
                            puts "# filename is #{temp_hash[:filename]}"   }                          
  #     opts.on("-s","--start VAL", Integer) {|val|  temp_hash[:start] = val
   #                    puts "# start mapping is #{temp_hash[:start]}"   }                                                                                     
       opts.on("-D","--debug", "turn on debug") { |val| temp_hash[:debug ] = true              }  
        opts.on("-C","--campaign_flow", "turn on campaign flow") { |val| temp_hash[:campaign] = true              }  
              
      opts.on("-t","--template VAL", String) { |val| temp_hash[:template] = val  
                                  puts "# tsipid key #{temp_hash[:template]}"            } 
              

      opts.on_tail("-H","--help", "get help message") { |val| temp_hash[:help ] = true    
                                                                                 puts opts          }                                      
                                       
       opts.parse(params)
                     # puts " in HTTP #{hostname} port #{port} url: #{url}"
      
      return temp_hash

     end # parse options
       def self.show_usage_exit(usage)
         # usage=usage.gsub(/^\s*#/,'')
          puts usage
          exit   
        end
  end #class
  # help build xml commands from messages
 
  end  #module