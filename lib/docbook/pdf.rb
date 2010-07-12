# Renders a PDF from a docbook file
module Docbook
  class Pdf < Docbook::Base
  
    include Docbook::Adapters::Fo::Fop
  
    def initialize(args={})
      super
      @output = 'pdf'
      @xsl_stylesheet = "xsl/pdf.xsl"
    end
  end
end