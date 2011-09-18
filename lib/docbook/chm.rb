module Docbook
  # Class for making Microsoft HTML help docs
  class Chm < Docbook::Base

      def initialize(args = {})
        raise "Can't use this unless you're on Windows" unless @windows
        super
        @xsl_extension = "hhp"
        @xsl_stylesheet = "#{self.root}/xsl/htmlhelp/htmlhelp.xsl"
      end

      def after_render
        OUTPUT.say "Building the Help file"
        `#{self.root}/hhc.exe #{self.file}.hhp"`
        OUTPUT.say "Cleaning up"
        FileUtils.rm "*.hh*"
        FileUtils.rm "*.html"
      end

  end
end