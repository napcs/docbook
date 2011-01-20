module Docbook
  class Epub < Docbook::Base
   
    include Docbook::Adapters::Epub::Epubber
    
    def initialize(args={})
      super
      @xsl_extension = "epub"
      @xsl_stylesheet = "xsl/epub.xsl"
    end


  end
end