@echo off
goto endofruby
#!/usr/bin/env ruby
root_path =  File.expand_path(File.dirname(__FILE__))
load "#{root_path}/generate"
__END__
:endofruby
"ruby" -x "%~f0" %*