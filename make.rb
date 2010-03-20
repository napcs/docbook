require File.expand_path(File.join(File.dirname(__FILE__), "version"))
require File.expand_path(File.join(File.dirname(__FILE__), "lib/docbook"))
require File.expand_path(File.join(File.dirname(__FILE__), "lib/extensions"))

def header
  puts DocbookVersion.to_s
  puts "(c) 2010 Brian P. Hogan"
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
  cmd = "java -Xss1024K -Xmx512m -cp #{DOCBOOK_ROOT}/jars/Multivalent*.jar tool.pdf.Merge -samedoc cover/cover.pdf book.pdf"
  `#{cmd}`
  FileUtils.mv("cover/cover-m.pdf", "book_with_cover.pdf")
  puts "Created 'book_with_cover.pdf'"
end

desc "clean temporary files"
task :clean do
  puts "Removing temporary files"
  FileUtils.rm_rf("book.pdf")
  FileUtils.rm_rf("article.pdf")
  FileUtils.rm_rf("book.html")
  FileUtils.rm_rf("article.html")
end

rule /.pdf|.html|.txt|.rtf|.epub|.xhtml|.chm/ => ".xml" do |t|

  
  
  file_and_target = t.name.split(".")

  validate = ENV["VALIDATE"] != "false"
  draft = ENV["DRAFT"] == "true"
  
  file = file_and_target[0]
  target = file_and_target[1]
  
  ENV["SOURCE_FILENAME"] = file + ".xml"
  ENV["TEMP_FILE"] = file + ".tmp"
  ENV["TEMP_FILENAME"] = ENV["TEMP_FILE"] + ".xml"
  
  FileUtils.cp ENV["SOURCE_FILENAME"], ENV["TEMP_FILENAME"]
  
  Rake::Task["preprocess"].invoke
  
  klass = "Docbook/#{target}".constantize
  book = klass.new(:root => DOCBOOK_ROOT, :file => ENV["TEMP_FILE"], :validate => validate, :draft => draft)
  if book.render
    puts "Completed building #{t.name}"
    Rake::Task["preprocess"].invoke
    FileUtils.mv ENV["TEMP_FILE"] + ".#{target}", t.name
    
  else
    puts  "#{t.name} not rendered."
  end
  
  FileUtils.rm ENV["TEMP_FILENAME"]
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

