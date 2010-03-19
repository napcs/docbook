require 'fileutils'

files = %w{make.rb version.rb README.txt hhc.exe jars lib xsl readme_files Rakefile generate generate.bat template}


desc "create documentation"
task :doc do    
  `cd readme_files && rake docbook.pdf && cd ..`
  FileUtils.cp "README.rdoc","README.txt"
end

desc "test build chain"
task :test do
  `#{File.expand_path(".")}/generate book mytestbook with_sample`
  `cd mytestbook && rm book.pdf && rake callout_images && rake book.pdf && open book.pdf && cd .. && rm -rf mytestbook`
end

desc "Create the zip file of the distribution, building docs if needed"
task :create_zip => :doc do  
  `zip -r output/docbook-1_1_0.zip #{files.join(" ")}`
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