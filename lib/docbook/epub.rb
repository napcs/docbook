module Docbook
  class Epub < Docbook::Base
   
    include Docbook::Adapters::Epub::Dbtoepub
    
    def initialize(args={})
      super
      @output = 'epub'
      @xsl_stylesheet = "xsl/epub.xsl"
    end


  end
end