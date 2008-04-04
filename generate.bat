@echo off
goto endofruby
#!/bin/ruby
root_path =  File.expand_path(File.dirname(__FILE__))
load "#{root_path}/generate"
__END__
:endofruby
"ruby" -x "%~f0" %*