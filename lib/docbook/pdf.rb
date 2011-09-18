# Renders a PDF from a docbook file
module Docbook
  
  # Creates PDF files by first parsing the Docbook XML
  # file to a FO file.
  # Then, an after_render method takes the fo file
  # and runs it through a postprocessor.
  # By default, we use FOP, and this is 
  # handled by the mixin Docbook::Adapters::FO::Fop
  # which contains the specific stuff for that particular
  # postprocessor.
  class Pdf < Docbook::Base
  
    include Docbook::Adapters::Fo::Fop
  
    def initialize(args={})
      super
      @output = 'pdf'
      @xsl_stylesheet = "xsl/pdf.xsl"
    end
    
    
    # Add a cover to the PDF.
    def add_cover
      if File.exist?("cover/cover.pdf")
        OUTPUT.say "Cover found - applying cover to the front of PDF"
        cmd = "java -Xss1024K -Xmx512m -cp #{DOCBOOK_ROOT}/jars/Multivalent*.jar tool.pdf.Merge -samedoc cover/cover.pdf #{self.file}.pdf"
        run_command cmd
        FileUtils.rm "#{self.file}.pdf"
        FileUtils.mv("cover/cover-m.pdf", "#{self.file}.pdf")
      else
        OUTPUT.say "No cover found. PDF styles don't currently use the <cover> element."
        OUTPUT.say "Ensure cover/cover.pdf exists if you want a cover appended."
      end
    end
    
    
  end
end