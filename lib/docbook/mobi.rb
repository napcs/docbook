module Docbook
  # Create MOBI files
  # This class is resposible for converting
  # the book to the MOBI format for use
  # on Kindle devices. 
  #
  # Under the hood, this class uses the 
  # EPUB stylesheets to build epubs
  # and then relies on the `kindlegen` program
  #
  # This seems to work just fine for technical books
  # and non-technical books alike.
  #
  # A mobi.css and mobi.xsl sheet are
  # still required, however.
  class Mobi < Docbook::Base
   
    include Docbook::Adapters::Epub::Epubber
    
    def initialize(args={})
      super
      @xsl_extension = "mobi"
      @xsl_stylesheet = "xsl/mobi.xsl"
    end

    # Uses the environment variable KINDLEGEN_PATH 
    # to locate the `kindlegen` program.
    def convert_to_mobi
      @kindlegen_path  = ENV["KINDLEGEN_PATH"] || "kindlegen"
      run_command "#{@kindlegen_path} #{self.output_path}.epub -o #{self.output_path}"
      File.exist? self.output_path
    end

    def after_render
      build_epub  # We use epub to convert
      if File.exist? self.output_path
        FileUtils.mv self.output_path, "#{self.output_path}.epub"
        if convert_to_mobi
          OUTPUT.say "mobi file created."
        else
          OUTPUT.error "mobi file not created. Ensure kindlegen is on your path or the KINDLEGEN_PATH environment variable is set to point to the complete path to kindlegen, including the filename."
        end
        FileUtils.rm_rf "#{self.output_path}.epub"
      else
        OUTPUT.error "Can't build mobi file. Epub conversion failed."
      end
    end

  end
end
