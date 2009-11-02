puts "Short Attention Span Docbook v1.1"
puts "(c) 2009 Brian P. Hogan"
puts "---------------------------------"
puts "Path:     #{DOCBOOK_ROOT}"

puts "Reminder: Nothing builds unless you've made changes to the Docbook file you're building."

require 'fileutils'

# =========== Classes ==================

# add lchop and classify / constantize methods to string class via a monkey patch
class String
  
  # Remove the first character from the string.
  def lchop
    s = self.gsub(/^./, "")
  end
  def classify
    self.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
  def constantize()
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ self.classify
      raise NameError, "#{self.inspect} is not a valid constant name!"
    end
  
    Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end
  
end

# Base clase for rendering a book. Generally you'd have your own class that inherits from this
class Docbook
  
  @xsl_extension = ""
  @xsl_stylesheet = ""
  
  attr_accessor :root, :file, :validate
  attr_reader :windows
  
  # Init and cnfigure the class
  #  b = Book.new(:root => "/home/homer/docbook", :file=>"book", :validate => true)
  def initialize(args ={})
     self.root = args[:root]
     self.file = args[:file]
     self.validate = args[:validate]
     
     @windows = PLATFORM.downcase.include?("win32")
     
  end
  
  # Generates the xml xslt processor command.
  # Override this in your own models to specify another command.
  def xml_cmd
    hcp_temp = @windows ? self.root : self.root.lchop
    
    highlighter_config_path ="file:///#{hcp_temp}/xsl/highlighting/xslthl-config.xml"

    saxon_cp = "#{self.root}/jars/xercesImpl-2.7.1.jar;"
    saxon_cp <<"#{self.root}/xsl/extensions/saxon65.jar;"
    saxon_cp <<"#{self.root}/jars/saxon.jar;"
    saxon_cp <<"#{self.root}/jars/xslthl-2.0.1.jar"
    
    xml_parser_config = "-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl" 
    xml_parser_config << " -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl" 
    xml_parser_config << " -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration"
    xml_parser_config << " -Dxslthl.config=#{highlighter_config_path}"
    
    cmd = "java -Xss1024K -Xmx512m -cp \"#{saxon_cp}\" #{xml_parser_config} com.icl.saxon.StyleSheet -o #{self.file}.#{@xsl_extension} #{self.file}.xml #{@xsl_stylesheet}"
    cmd.gsub!(";",":") unless @windows
    cmd    
  end

  # Checks to see if the doc is valid.
  def valid?
    success = true
    validator_cmd = "java -jar -Xmx512m -Xss1024K #{self.root}/jars/relames.jar http://www.docbook.org/xml/5.0/rng/docbookxi.rng #{self.file}.xml"
    if validate
      puts "Validating your document..."
      output = `#{validator_cmd}`
      sucess = ! output.include?("NOT valid") || ! output.include?("Exception")
      
    else
      puts "Skipping validation..."
    end
    success
  end
  
  # Render the book
  def render
    success = if valid?
       
                # call before_render if defined.
                self.before_render if self.respond_to?("before_render")
                puts "Transforming XML..."
                output = `#{xml_cmd}`

                unless output.include?("Exception")
                  self.after_render if self.respond_to?("after_render")
                end
            
              end
    success
  end

end


# Class for making HTML outputs
class Html < Docbook

  
  def initialize(args ={})
    super
    @xsl_extension = "html"
    @xsl_stylesheet = "#{self.root}/xsl/xhtml/docbook.xsl"
  end
  
  def after_render
    puts "Done"
  end

end

# Interface for FO-PDF processors, for taking FO output created by the XML processor and converting it to various formats. This class
# should be extended to control the various formats.
class Fo < Docbook
    
    # initialize the object and set the extensions and output type. Defaults to PDF
    def initialize(args = {})
      super
      @xsl_extension = "fo"
      @output = 'pdf'
      @xsl_stylesheet = "xsl/pdf.xsl"
    end
    
    # build up the options for FOP
    def fop_options
      fop_cp      = "#{self.root}/fop/avalon-framework-4.2.0.jar;"
      fop_cp << "#{self.root}/jars/batik-all-1.7.jar;"
      fop_cp << "#{self.root}/jars/commons-io-1.3.1.jar;"
      fop_cp << "#{self.root}/jars/commons-logging-1.0.4.jar;"
      fop_cp << "#{self.root}/jars/fop-hyph.jar;"
      fop_cp << "#{self.root}/jars/fop.jar;"
      fop_cp << "#{self.root}/jars/serializer-2.7.0.jar;"
      fop_cp << "#{self.root}/jars/xalan-2.7.0.jar;"
      fop_cp << "#{self.root}/jars/xercesImpl-2.7.1.jar;"
      fop_cp << "#{self.root}/jars/xml-apis-1.3.04.jar;"
      fop_cp << "#{self.root}/jars/xmlgraphics-commons-1.3.1.jar;"
      fop_cp
    end
    
    # Create the command to launch FOP
    def fop_command  
      cmd = "java -Xmx512m -Xss1024K -cp #{fop_options} org.apache.fop.cli.Main -fo #{self.file}.fo -#{@output} #{self.file}.#{@output}"

      cmd.gsub!(";",":") unless @windows
      cmd
    end
    
    def before_render
      xsl_path = PLATFORM.downcase.include?("win32") ? self.root : self.root.lchop
      
      fo_xml = %Q{<?xml version='1.0'?>

      <!-- DO NOT CHANGE THIS FILE. IT IS AUTOGENERATED BY THE SHORT-ATTENTION-SPAN-DOCBOOK CHAIN -->

      <xsl:stylesheet 
         xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
         xmlns:fo="http://www.w3.org/1999/XSL/Format"
         xmlns:xslthl="http://xslthl.sf.net"
         xmlns:d="http://docbook.org/ns/docbook"
      >
        <!-- Import the original FO stylesheet -->
        <xsl:import href="file:///#{xsl_path}/xsl/fo/docbook.xsl"/>
        <xsl:import href="file:///#{xsl_path}/xsl/fo/highlight.xsl"/>
      
        <!-- FOP -->
        <!-- PDF bookmarking support -->
        <xsl:param name="fop1.extensions" select="1" />
      </xsl:stylesheet>
      }
      
      File.open("xsl/fo.xml", "w") do |f|
        f << fo_xml
      end
    end
    
    # Callback to build the final file after the XML-FO rendering occurs
    def after_render
      if File.exists?("#{self.file}.fo")
        puts "Building #{@output}"
        `#{self.fop_command}`
    
        puts "Cleaning up"
        FileUtils.rm "#{file}.fo"
      else
        puts "FO processing halted - missing #{self.file}.fo file."
      end
    end
    
end

# Renders a PDF from a docbook file
class Pdf < Fo
  def initialize(args={})
    super
    @output = "pdf"
  end
end

# Renders a TXT file from a docbook file
class Txt < Fo
  def initialize(args={})
    super
    @output = "txt"
  end  
end



# Renders an RTF file from a docbook file
class Rtf < Fo
  def initialize(args={})
    super
    @output = "rtf"
  end
end

class Epub < Docbook
  
  def initialize(args = {})
    super
    @output = "epub"
    @xsl_stylesheet = "#{self.root}/xsl/epub/docbook.xsl"
    
    
  end
  
  def xml_cmd
     cmd = "ruby #{self.root}/xsl/epub/bin/dbtoepub -s #{@xsl_stylesheet} #{self.file}.xml"
  end
  
end

# Class for making Microsoft HTML help docs
class Chm < Docbook

    def initialize(args = {})
      raise "Can't use this unless you're on Windows" unless @windows
      super
      @xsl_extension = "hhp"
      @xsl_stylesheet = "#{self.root}/xsl/htmlhelp/htmlhelp.xsl"
    end
    
    def after_render
      puts "Building the Help file"
      `#{self.root}/hhc.exe #{self.file}.hhp"`
      puts "Cleaning up"
      FileUtils.rm "*.hh*"
      FileUtils.rm "*.html"
    end
    
end

# =========== Actual script starts here ==============
# process the doc.


rule /.pdf|.html|.rtf|.epub|.xhtml|.chm/ => ".xml" do |t|
  
  file_and_target = t.name.split(".")

  validate = ENV["VALIDATE"] != "false"
  file = file_and_target[0]
  target = file_and_target[1]

  klass = target.constantize
  book = klass.new(:root => DOCBOOK_ROOT, :file => file, :validate => validate)
  if book.render
    puts "Done"
  else
    puts  "Book not rendered."
  end
end

