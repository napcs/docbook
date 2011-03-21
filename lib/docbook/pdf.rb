# Renders a PDF from a docbook file
module Docbook
  class Pdf < Docbook::Base
  
    include Docbook::Adapters::Fo::Fop
  
    def initialize(args={})
      super
      @output = 'pdf'
      @xsl_stylesheet = "xsl/pdf.xsl"
    end
    
    def add_cover
      if File.exist?("cover/cover.pdf")
        puts "Cover found - applying cover to the front of PDF"
        cmd = "java -Xss1024K -Xmx512m -cp #{DOCBOOK_ROOT}/jars/Multivalent*.jar tool.pdf.Merge -samedoc cover/cover.pdf #{self.file}.pdf"
        `#{cmd}`
        FileUtils.rm "#{self.file}.pdf"
        FileUtils.mv("cover/cover-m.pdf", "#{self.file}.pdf")
      else
        puts "No cover found. PDF styles don't currently use the <cover> element."
        puts "Ensure cover/cover.pdf exists if you want a cover appended."
      end
    end
    
    
  end
end