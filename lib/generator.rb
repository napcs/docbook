require File.expand_path(File.join(File.dirname(__FILE__), "../version"))
require File.expand_path(File.join(File.dirname(__FILE__), "extensions"))
require File.expand_path(File.join(File.dirname(__FILE__), "helpers"))
require 'fileutils'

module Docbook
  
  class Generator
    include Helpers
  
    attr_accessor :project_type, :root_path, :output_path, :sample, :verbose

    # generate a new project.
    # Types are "book", "article", or "chapter"
    def initialize(project_type, root_path, output_path, options = {})
      self.project_type = project_type
      self.root_path = root_path
      self.output_path = output_path
      self.sample = options[:sample] || false
      self.verbose = options[:verbose]
    end
    
    def generate
      self.send(project_type)
    end
    
    # generate a file by reading in the template and spitting out the results, substituting the rootpath in the document
    def generate_from_file(file, substring, destination)
      match = "<#ROOT_PATH#>"
      s = get_file_as_string(file)
      s.gsub!(match, substring)
      put_file_from_string(destination, s)
      say " - #{destination}", :verbose => self.verbose
    end


    # load a file into a string
    def get_file_as_string(filename)
      File.read(filename)
    end

    # write the file from a string
    def put_file_from_string(f, s)
      File.open(f , 'w') do |file|
          file.puts(s)
      end
    end
    
    def version_stamp(path)
      File.open(path, "w") do |file|
        file << "Generated with #{DocbookVersion.to_s}"
      end
    end
    
    def common_files
      mkdir_p(self.output_path, :verbose => self.verbose)
      mkdir_p("#{self.output_path}/images", :verbose => self.verbose)
      mkdir_p("#{self.output_path}/images/src", :verbose => self.verbose)
      mkdir_p("#{self.output_path}/cover", :verbose => self.verbose)
      mkdir_p("#{self.output_path}/xsl", :verbose => self.verbose)
      cp "#{self.root_path}/template/w3centities-f.ent", "#{self.output_path}/w3centities-f.ent", :verbose => self.verbose
      copy_xslt_files
      generate_from_file "#{self.root_path}/template/Rakefile", root_path, "#{self.output_path}/Rakefile"
      version_stamp("#{self.output_path}/VERSION.txt")
    end
    
    def copy_xslt_files

      if File.exist?("#{output_path}/xsl/pdf.xsl")
        FileUtils.mv "#{output_path}/xsl/pdf.xsl","#{output_path}/xsl/pdf.xsl.old"
      end  

      if  File.exist?("#{output_path}/xsl/html.css")
        FileUtils.mv "#{output_path}/xsl/html.css","#{output_path}/xsl/html.css.old"
      end

      if File.exist?("#{output_path}/xsl/html.xsl")
        FileUtils.mv "#{self.output_path}/xsl/html.xsl","#{self.output_path}/xsl/html.xsl.old"
      end

      if File.exist?("#{self.output_path}/xsl/epub.xsl")
        FileUtils.mv "#{self.output_path}/xsl/epub.xsl","#{self.output_path}/xsl/epub.xsl.old"
      end

      if File.exist?("#{self.output_path}/xsl/epub.xsl")
        FileUtils.mv "#{self.output_path}/xsl/epub.css","#{self.output_path}/xsl/epub.css.old"
      end      

      if File.exist?("#{self.output_path}/xsl/rtf.xsl")
        FileUtils.mv "#{self.output_path}/xsl/rtf.xsl","#{self.output_path}/xsl/rtf.xsl.old"
      end

      cp  "#{self.root_path}/template/xsl/pdf.xsl", "#{self.output_path}/xsl/pdf.xsl", :verbose => self.verbose
      cp  "#{self.root_path}/template/xsl/html.xsl", "#{self.output_path}/xsl/html.xsl", :verbose => self.verbose
      cp  "#{self.root_path}/template/xsl/epub.xsl", "#{self.output_path}/xsl/epub.xsl", :verbose => self.verbose
      cp  "#{self.root_path}/template/xsl/epub.css", "#{self.output_path}/xsl/epub.css" , :verbose => self.verbose
      cp  "#{self.root_path}/template/xsl/html.css", "#{self.output_path}/xsl/html.css", :verbose => self.verbose
      cp  "#{self.root_path}/template/xsl/rtf.xsl", "#{self.output_path}/xsl/rtf.xsl", :verbose => self.verbose

    end
    
    def article
      say "Creating article...", :verbose => self.verbose
      common_files

      if sample
        cp("#{self.root_path}/template/article.xml", "#{self.output_path}/article.xml", :verbose => self.verbose)
      else
        cp("#{self.root_path}/template/article.xml", "#{self.output_path}/article.xml", :verbose => self.verbose)
      end
      say "Done", :verbose => self.verbose
    end

    # Chapter creation. Creates subfolder of images
    # if there's no directory in the filename.
    # e.g.   generate chapter coolstuff  
    #   will create images/coolstuff and coolstuff.xml
    def chapter
      say "Creating chapter...", :verbose => self.verbose

      directory = output_path.dirname

       if directory == "."
         mkdir_p(File.join("images", output_path), :verbose => self.verbose)
       else   
         mkdir_p(directory + "/images", :verbose => self.verbose)
       end


       if self.sample
         cp("#{self.root_path}/template/chapter01_sample.xml", "#{self.output_path}.xml", :verbose => self.verbose)
         cp("#{self.root_path}/template/images/sample.png", "#{directory}/images", :verbose => self.verbose) rescue nil
       else
         cp("#{self.root_path}/template/chapter01.xml", "#{self.output_path}.xml", :verbose => self.verbose)
       end

       unless File.exist?("#{directory}/w3centities-f.ent")
         cp "#{self.root_path}/template/w3centities-f.ent", "#{directory}/w3centities-f.ent", :verbose => self.verbose
       end
       
       say "Done", :verbose => self.verbose

    end

    def book
        say "Creating docbook project...", :verbose => self.verbose

        common_files

        if sample
           cp("#{self.root_path}/template/images/sample.png", "#{self.output_path}/images", :verbose => self.verbose)

           if File.exist?("#{self.output_path}/book.xml")
             say "book.xml exists - skipping", :verbose => self.verbose
           else
             cp("#{self.root_path}/template/book_sample.xml", "#{self.output_path}/book.xml", :verbose => self.verbose)
             cp("#{self.root_path}/template/chapter01_sample.xml", "#{self.output_path}/chapter01.xml", :verbose => self.verbose)
           end
        else
          if File.exist?("#{self.output_path}/book.xml")
            say "book.xml exists - skipping", :verbose => self.verbose
          else
            cp("#{self.root_path}/template/book.xml", "#{self.output_path}/book.xml", :verbose => self.verbose)
            cp("#{self.root_path}/template/chapter01.xml", "#{self.output_path}/chapter01.xml", :verbose => self.verbose)
          end
        end

      say "Done", :verbose => self.verbose
    end
     
  end
  
end