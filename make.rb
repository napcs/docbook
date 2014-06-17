require 'rubygems' unless defined? Gem
require File.expand_path(File.join(File.dirname(__FILE__), "version"))
require File.expand_path(File.join(File.dirname(__FILE__), "lib/docbook"))



OUTPUT = Docbook::Output.new(:verbose => ENV["VERBOSE"], :debug => ENV["DEBUG"])


include Helpers


def header
  puts DocbookVersion.to_s
  puts "(c) 2006-2014 Brian P. Hogan"
  puts "Using #{DocbookVersion.xslt_to_s}"
  
  puts "-" * 40
  OUTPUT.say "Using buildchain located at: #{DOCBOOK_ROOT}"
  OUTPUT.say "Reminder: Nothing builds unless you've made changes to the Docbook file you're building."
  OUTPUT.say "-" * 40
  OUTPUT.say ""

end

require 'fileutils'


# =========== Actual script starts here ==============
# process the doc.

header
desc "Prepend a cover to your PDF. Cover should be called cover.pdf and stored in the cover/ folder"
task :add_cover => ["book.pdf"] do
  OUTPUT.say "This task is deprecated. The book is built with a cover if the cover file exists."
end

desc "clean temporary files"
task :clean do
  OUTPUT.say "Removing temporary files"
  xml_files = Dir.glob("./**/*.xml")
  %w{pdf html txt rtf epub xhtml mobi chm fo}.each do |ext|
    f = xml_files.collect{|a| a.gsub(".xml", ".#{ext}")}
    f.each{|item| OUTPUT.say "Removing #{item}" if File.exist?(item)}
    FileUtils.rm_rf(f)
  end
  FileUtils.rm_rf("html") if File.exist?("html")

end

rule /\.pdf$|\.html$|\.mobi$|\.txt$|\.rtf$|\.epub$|\.xhtml$|\.chm$/ => FileList["**/*.xml"] do |t|

  file_and_target = t.name.split(".")

  validate = ENV["VALIDATE"] != "false"
  
  draft = ENV["DRAFT"] == "true"
  debug = ENV["DEBUG"] == "true"
  file = file_and_target[0]
  target = file_and_target[1]
    
  # Setting environment variables so they are
  # available in the pre and post-process tasks
  # that users can define
  ENV["SOURCE_FILENAME"] = file + ".xml"              # book.xml
  ENV["TEMP_FILE"] = file + ".tmp"                    # book.tmp - a base name for the file. 
  ENV["TEMP_FILENAME"] = ENV["TEMP_FILE"] + ".xml"    # book.tmp.xml - the file your preprocessor should use
  ENV["OUTPUT_FILENAME"] = t.name                     # book.pdf
  ENV["FORMAT"] = target                              # pdf
  
  OUTPUT.say_debug("validate: #{validate}")
  OUTPUT.say_debug("draft: #{draft}")
  OUTPUT.say_debug("debug: #{debug}")
  OUTPUT.say_debug("file: #{file}")
  OUTPUT.say_debug("target: #{target}")
  OUTPUT.say_debug("ENV['SOURCE_FILENAME']: #{ENV["SOURCE_FILENAME"]}")
  OUTPUT.say_debug("ENV['TEMP_FILE']: #{ENV["TEMP_FILE"]}")
  OUTPUT.say_debug("ENV['TEMP_FILENAME']: #{ENV["TEMP_FILENAME"]}")
  OUTPUT.say_debug("ENV['OUTPUT_FILENAME']: #{ENV["OUTPUT_FILENAME"]}")
  OUTPUT.say_debug("ENV['FORMAT']: #{ENV["FORMAT"]}")


  
  FileUtils.cp ENV["SOURCE_FILENAME"], ENV["TEMP_FILENAME"]
  
  if validate
    
    OUTPUT.say_debug "Initial validation of files before preprocessor"
    validator = Docbook::Validator.new(ENV["SOURCE_FILENAME"], DOCBOOK_ROOT)

    if validator.valid?
      OUTPUT.say "Preliminary validation complete. "
    else
      OUTPUT.error "Validation errors occurred."
      OUTPUT.error validator.error_messages
      
    end

  end
  OUTPUT.say "Running custom preprocessors, if any"
  Rake::Task["preprocess"].invoke
  
  klass = "Docbook/#{target}".constantize
  
  book = klass.new(:root => DOCBOOK_ROOT, :file => ENV["TEMP_FILE"], :validate => validate, :draft => draft)
  
  if book.render
    OUTPUT.say "Completed building #{t.name}"
    Rake::Task["postprocess"].invoke
    OUTPUT.say "Renaming #{ ENV["TEMP_FILE"]} to #{t.name} if necessary"
    FileUtils.mv ENV["TEMP_FILE"] + ".#{target}", t.name rescue nil
    OUTPUT.say "Cleaning up temporary file #{ENV["TEMP_FILENAME"] }"
    FileUtils.rm ENV["TEMP_FILENAME"] if File.exist?(ENV["TEMP_FILENAME"])
  else
    OUTPUT.error  "#{t.name} not rendered."
  end
end

task :preprocess do
  OUTPUT.say "Running preprocessing tasks"
end

task :postprocess do
  OUTPUT.say "Running postprocessing tasks"
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
  OUTPUT.say "Build books with 'rake filename.pdf' or 'rake filename.html'"
end

desc "Grabs callout images from #{DOCBOOK_ROOT}/xsl/images. You should really not use these for production, as they are terrible quality."
task :callout_images do
  FileUtils.cp_r(DOCBOOK_ROOT + "/xsl/images/", ".")
  OUTPUT.say "Images copied. They're awful though, so you're probably better off replacing each one with your own."
end

desc "Grab new versions of the XSLT stylesheets - yours will be backed up"
task :update_xslt do
  g = Docbook::Generator.new("book", DOCBOOK_ROOT, ".")
  g.copy_xslt_files
end

# load user extensions *after* our own
if File.exists?(ENV["HOME"] + "/.docbook_rakefile")
  OUTPUT.say "Loading custom user extensions at #{ENV["HOME"] + "/.docbook_rakefile"}\n"
  load ENV["HOME"] + "/.docbook_rakefile" 
else
  OUTPUT.say "No custom user extensions found at #{ENV["HOME"] + "/.docbook_rakefile"}\n"
end

