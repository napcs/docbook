require File.expand_path(File.join(File.dirname(__FILE__), "version"))
require File.expand_path(File.join(File.dirname(__FILE__), "lib/docbook"))
require File.expand_path(File.join(File.dirname(__FILE__), "lib/extensions"))
require File.expand_path(File.join(File.dirname(__FILE__), "lib/shared"))



def header
  puts DocbookVersion.to_s
  puts "(c) 2011 Brian P. Hogan"
  puts "Using #{DocbookVersion.xslt_to_s}"
  
  puts "-" * 40
  puts "Using buildchain located at: #{DOCBOOK_ROOT}"
  puts "Reminder: Nothing builds unless you've made changes to the Docbook file you're building."
  puts "-" * 40
  puts ""

end

require 'fileutils'


# =========== Actual script starts here ==============
# process the doc.

header
desc "Prepend a cover to your PDF. Cover should be called cover.pdf and stored in the cover/ folder"
task :add_cover => ["book.pdf"] do
  puts "This task is deprecated. The book is built with a cover if the cover file exists."
end

desc "clean temporary files"
task :clean do
  puts "Removing temporary files"
  xml_files = Dir.glob("./**/*.xml")
  %w{pdf html txt rtf epub xhtml chm fo}.each do |ext|
    f = xml_files.collect{|a| a.gsub(".xml", ".#{ext}")}
    f.each{|item| puts "Removing #{item}" if File.exist?(item)}
    FileUtils.rm_rf(f)
  end
  FileUtils.rm_rf("html") if File.exist?("html")

  
end

rule /\.pdf$|\.html$|\.txt$|\.rtf$|\.epub$|\.xhtml$|\.chm$/ => FileList["**/*.xml"] do |t|

  file_and_target = t.name.split(".")

  validate = ENV["VALIDATE"] != "false"
  draft = ENV["DRAFT"] == "true"
  debug = ENV["DEBUG"] == "true"
  cover = ENV["COVER"] == "true"
  
  file = file_and_target[0]
  target = file_and_target[1]
  
  ENV["SOURCE_FILENAME"] = file + ".xml"
  ENV["TEMP_FILE"] = file + ".tmp"
  ENV["TEMP_FILENAME"] = ENV["TEMP_FILE"] + ".xml"
  ENV["OUTPUT_FILENAME"] = t.name
  ENV["FORMAT"] = target
  
  FileUtils.cp ENV["SOURCE_FILENAME"], ENV["TEMP_FILENAME"]
  
  Rake::Task["preprocess"].invoke
  
  klass = "Docbook/#{target}".constantize
  book = klass.new(:root => DOCBOOK_ROOT, :file => ENV["TEMP_FILE"], :validate => validate, :draft => draft, :debug => debug, :cover => cover)
  if book.render
    puts "Completed building #{t.name}"
    Rake::Task["postprocess"].invoke
    puts "Renaming #{ ENV["TEMP_FILE"]} to #{t.name} if necessary"
    FileUtils.mv ENV["TEMP_FILE"] + ".#{target}", t.name rescue nil
  else
    puts  "#{t.name} not rendered."
  end
  puts "Cleaning up temporary file #{ENV["TEMP_FILENAME"] }"
  FileUtils.rm ENV["TEMP_FILENAME"] if File.exist?(ENV["TEMP_FILENAME"])
end

task :preprocess do
  puts "Running preprocessing tasks"
end

task :postprocess do
  puts "Running postprocessing tasks"
end

task :default => [:build]

task :build do
  if File.exists?("book.xml")
    FileUtils.touch "book.xml"
    Rake::Task["book.pdf"].invoke
  elsif File.exists?("article.xml")
    `touch article.xml`
    Rake::Task["article.pdf"].invoke
  end
end

desc "Shows instructions for building."
task :help do
  puts "Build books with 'rake filename.pdf' or 'rake filename.html'"
end

desc "Grabs callout images from #{DOCBOOK_ROOT}/xsl/images. You should really not use these for production, as they are terrible quality."
task :callout_images do
  FileUtils.cp_r(DOCBOOK_ROOT + "/xsl/images/", ".")
  puts "Images copied. They're awful though, so you're probably better off replacing each one with your own."
end

desc "Grab new versions of the XSLT stylesheets - yours will be backed up"
task :update_xslt do
  copy_xslt_files DOCBOOK_ROOT, "."
end

#file "book.pdf" => FileList['**/*.xml'] - ["book.xml"] 

# load user extensions *after* our own
if File.exists?(ENV["HOME"] + "/.docbook_rakefile")
  puts "Loading custom user extensions at #{ENV["HOME"] + "/.docbook_rakefile"}\n"
  load ENV["HOME"] + "/.docbook_rakefile" 
else
  puts "No custom user extensions found at #{ENV["HOME"] + "/.docbook_rakefile"}\n"
end

