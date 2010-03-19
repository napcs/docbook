module Docbook
  class Epub < Docbook::Base

    def initialize(args = {})
      super
      @output = "epub"
      @xsl_stylesheet = "#{self.root}/xsl/epub/docbook.xsl"


    end

    def xml_cmd
       cmd = "ruby #{self.root}/xsl/epub/bin/dbtoepub -s #{@xsl_stylesheet} #{self.file}.xml"
    end

  end
end