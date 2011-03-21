module Docbook
  # Renders a TXT file from a docbook file
  class Txt < Docbook::Base
    include Docbook::Adapters::Fo::Fop
    
    def initialize(args={})
      super
      @output = "txt"
      @xsl_stylesheet = "xsl/txt.xsl"
      
    end  
  end
  
end