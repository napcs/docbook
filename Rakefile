$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'fileutils'
require 'version'
require 'rake/testtask' 

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

files = %w{make.rb version.rb README.txt hhc.exe jars lib xsl readme_files Rakefile generate generate.bat template}

desc "create documentation"
task :doc do
  root = File.dirname(__FILE__)    
  `cd readme_files && rake docbook.pdf SHORT_ATTENTION_SPAN_DOCBOOK_PATH="#{root}" && cd ..`
  FileUtils.cp "README.rdoc","README.txt"
end

desc "test build chain"
task :acceptance_test do
  FileUtils.rm_rf "mytestbook/" rescue nil
  `#{File.expand_path(".")}/generate book mytestbook with_sample`
  Dir.chdir "mytestbook" do
    `rake callout_images`
    `rake book.pdf DEBUG=true` 
    `rake book.html DEBUG=true`
    `rake book.epub DEBUG=true`  
  end 
  FileUtils.rm_rf "mytestbook/" rescue nil
  `#{File.expand_path(".")}/generate article mytestbook with_sample`
  Dir.chdir "mytestbook" do
    `rake callout_images`
    `rake article.pdf` 
  end   
  FileUtils.rm_rf "mytestbook/" rescue nil
  
end

desc "Create the zip file of the distribution, building docs if needed"
task :create_zip => :doc do  
  
  `zip -r output/docbook-#{DocbookVersion.version}.zip #{files.join(" ")}`
end

desc "Install build chain, using c:/docbook on win or ~/docbook - Pass DIR=/your/path to customize."
task :install => :doc do
  dest = ENV["DIR"] || (RUBY_PLATFORM =~ /(win|w)32$/ ? "c:/docbook" : ENV["HOME"] + "/docbook")
  files.each do |file|
    target_file = File.join(dest, file)
    FileUtils.mkdir_p(File.dirname(target_file))
    FileUtils.cp_r(file, target_file)
    puts " Copied #{file} to #{target_file}"
  end
  if RUBY_PLATFORM =~ /(win|w)32$/ 
    puts "Be sure to add #{dest} to your path. See"
    puts "http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/path.mspx?mfr=true"
    puts "for more information."
    puts " You'll also want to create the environment variable SHORT_ATTENTION_SPAN_DOCBOOK_PATH"
    puts " and set it to #{dest}"
  else
    `chmod +x #{dest}/generate`
    puts "Be sure to add"
    puts "   export PATH=$PATH:#{dest}"
    puts " and optionally,"
    puts "   export SHORT_ATTENTION_SPAN_DOCBOOK_PATH=\"#{dest}\""
    puts "to your .bashrc or .bash_login or .bash_profile"
  
  end
end