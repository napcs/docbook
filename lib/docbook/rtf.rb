module Docbook
  # Renders an RTF file from a docbook file
  class Rtf < Docbook::Base
    include Docbook::Adapters::Fo::Fop
    
    def initialize(args={})
      super
      @output = "rtf"
    end
  end
end