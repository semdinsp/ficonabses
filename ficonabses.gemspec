Gem::Specification.new do |s|
  s.name        = "ficonabses"
  s.version     = "0.3.1"
  s.author      = "Scott Sproule"
  s.email       = "scott.sproule@estormtech.com"
  s.homepage    = "http://github.com/semdinsp/ficonabses"
  s.summary     = "Ficonab SES tools to send emails via estormtech.com service"
  s.description = "Simple way to send emails from your application." 
  s.executables = ['ficonabses_template_test.rb','ficonabses_csv.rb','ficonabses_blacklist.rb']    #should be "name.rb"
  s.files        = Dir["{lib,test}/**/*"] +Dir["bin/*.rb"] + Dir["[A-Z]*"] # + ["init.rb"]
  s.require_path = "lib"
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end