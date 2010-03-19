# Renders a PDF from a docbook file
module Docbook
  class Pdf < Docbook::Base
  
    include Docbook::Adapters::Fop
  
    def initialize(args={})
      super
      @output = "pdf"
    end
  end
end