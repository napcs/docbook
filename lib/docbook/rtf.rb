module Docbook
  # Renders an RTF file from a docbook file
  # Creates RTF files
  class Rtf < Docbook::Base
    include Docbook::Adapters::Fo::Fop
    
    def initialize(args={})
      super
      @output = "rtf"
      @xsl_stylesheet = "xsl/rtf.xsl"
    end
  end
end