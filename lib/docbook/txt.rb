module Docbook
  # Renders a TXT file from a docbook file
  class Txt < Docbook::Base
    include Docbook::Adapters::Fop
    
    def initialize(args={})
      super
      @output = "txt"
    end  
  end
  
end