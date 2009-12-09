require 'fileutils'

files = %w{make.rb README.txt hhc.exe jars xsl docbook.pdf generate generate.bat template}


desc "create documentation"
task :doc do    
  `cd readme_files && rake docbook.pdf && cd ..`
  FileUtils.cp "readme_files/docbook.pdf", "./docbook.pdf"
  FileUtils.cp "README.rdoc","README.txt"
end

desc "test build chain"
task :test do
  `#{File.expand_path(".")}/generate book mytestbook with_sample`
  `cd mytestbook && rm book.pdf && rake callout_images && rake book.pdf && open book.pdf && cd .. && rm -rf mytestbook`
end

task :create_zip => :doc do  
  `zip -r output/docbook-1_1_0.zip #{files.join(" ")}`
end

task :install do
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
  else
    `chmod +x #{dest}/generate`
    puts "Be sure to add"
    puts "   EXPORT PATH=$PATH:#{dest}"
    puts " and optionally,"
    puts "   EXPORT SHORT_ATTENTION_SPAN_DOCBOOK_PATH=\"#{dest}\""
    puts "to your .bashrc or .bash_login or .bash_profile"
  
  end
end