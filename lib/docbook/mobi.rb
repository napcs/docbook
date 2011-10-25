module Docbook
  class Mobi < Docbook::Base
   
    include Docbook::Adapters::Epub::Epubber
    
    def initialize(args={})
      super
      @xsl_extension = "mobi"
      @xsl_stylesheet = "xsl/mobi.xsl"
    end

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
          OUTPUT.error "mobi file not created. Ensure kindlegen is on your path or the KINDLEGEN_PATH environment variable is set."
        end
        FileUtils.rm_rf "#{self.output_path}.epub"
      else
        OUTPUT.error "Can't build mobi file. Epub conversion failed."
      end
    end

  end
end