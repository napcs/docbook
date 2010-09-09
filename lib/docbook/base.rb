module Docbook
  # Base clase for rendering a book. Generally you'd have your own class that inherits from this
  class Base

    @xsl_extension = ""
    @xsl_stylesheet = ""

    attr_accessor :root, :file, :validate, :draft, :debug
    attr_reader :windows

    # Init and cnfigure the class
    #  b = Book.new(:root => "/home/homer/docbook", :file=>"book", :validate => true)
    def initialize(args ={})
       self.root = args[:root]
       self.file = args[:file]
       self.validate = args[:validate]
       self.draft = args[:draft]
       self.debug = args[:debug]
       @windows = RUBY_PLATFORM.downcase.include?("win32") || RUBY_PLATFORM.downcase.include?("mingw") 

    end
    def xml_parser_options
      opts = "use.extensions=1"
    end

    def xml_parser_settings
      hcp_temp = @windows ? self.root : self.root.lchop
      highlighter_config_path ="file:///#{hcp_temp}/xsl/highlighting/xslthl-config.xml"
      xml_parser_config = "-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl" 
      xml_parser_config << " -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl" 
      xml_parser_config << " -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration"
      xml_parser_config << " -Dxslthl.config=#{highlighter_config_path}"
      xml_parser_config
    end

    # Generates the xml xslt processor command.
    # Override this in your own models to specify another command.
    def xml_cmd

      saxon_cp = "#{self.root}/jars/xercesImpl-2.7.1.jar;"
      saxon_cp <<"#{self.root}/xsl/extensions/saxon65.jar;"
      saxon_cp <<"#{self.root}/jars/saxon.jar;"
      saxon_cp <<"#{self.root}/jars/xslthl-2.0.1.jar"

      xml_parser_config = xml_parser_settings
      opts = xml_parser_options
      cmd = "java -Xss1024K -Xmx512m -cp \"#{saxon_cp}\" #{xml_parser_config} com.icl.saxon.StyleSheet -o #{self.file}.#{@xsl_extension} #{self.file}.xml #{@xsl_stylesheet} #{opts}"
      cmd.gsub!(";",":") unless @windows
      cmd    
    end

    # Checks to see if the doc is valid.
    def valid?
      success = true
      validator_cmd = "java -jar -Xmx512m -Xss1024K #{self.root}/jars/relames.jar http://www.docbook.org/xml/5.0/rng/docbookxi.rng #{self.file}.xml"
      if validate
        puts "Validating your document..."
        print_debug(validator_cmd)
        output = `#{validator_cmd}`
        sucess = ! output.include?("NOT valid") || ! output.include?("Exception")

      else
        puts "Skipping validation..."
      end
      success
    end
    
    def print_debug(string)
      if self.debug
        puts "-------------------------"
        puts "Running command: "
        puts string
        puts "-------------------------"
      end
    end

    # Render the book
    def render
      success = true
       if valid?

            # call before_render if defined.
            self.before_render if self.respond_to?("before_render")
            puts "Transforming XML..."
            print_debug(xml_cmd)
            output = `#{xml_cmd}`

            if output.include?("Exception")
              success = false
            else
              success = true
              puts 'Finished XML transformation'
              self.after_render if self.respond_to?("after_render")
            end
        else
          success = false      
        end
      success
    end

  end
end