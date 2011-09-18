module Docbook
  # Base class for rendering a book. Generally you'd have your own 
  # class that inherits from this
  # such as Docbook::PDF
  class Base
    include Helpers
    
    @xsl_extension = ""
    @xsl_stylesheet = ""

    attr_accessor :root, :file, :validate, :draft
    attr_reader :windows

    # Init and cnfigure the class
    #  b = Book.new(:root => "/home/homer/docbook", :file=>"book", :validate => true)
    def initialize(args ={})
       self.root = args[:root]
       self.file = args[:file]
       self.validate = args[:validate].nil? ? true : args[:validate]
       self.draft = args[:draft]
       @windows = RUBY_PLATFORM.downcase.include?("win32") || RUBY_PLATFORM.downcase.include?("mingw") 
    end
    
    def output_path
      "#{self.file}.#{@xsl_extension}"
    end
    
    def xml_parser_options
      opts = "use.extensions=1"
    end

    # Sets up the default settings for the XML parser.
    # including the highlighting settings and other
    # basic parameters.
    def xml_parser_settings
      hcp_temp = @windows ? self.root : self.root.lchop
      highlighter_config_path ="file:///#{hcp_temp}/xsl/highlighting/xslthl-config.xml"
      xml_parser_config = "-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl" 
      xml_parser_config << " -Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl" 
      xml_parser_config << " -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration"
      xml_parser_config << " -Dxslthl.config=#{highlighter_config_path}"
      xml_parser_config
    end
    
    # Builds the classpath for the XML parser.
    def xml_parser_java_paths
      saxon_cp = "#{self.root}/jars/xercesImpl-2.7.1.jar;"
      saxon_cp <<"#{self.root}/xsl/extensions/saxon65.jar;"
      saxon_cp <<"#{self.root}/jars/saxon.jar;"
      saxon_cp <<"#{self.root}/jars/xslthl-2.0.1.jar"
      saxon_cp
    end

    # Generates the xml xslt processor command.
    # Override this in your own models to specify another command.
    def xml_cmd
      cmd = "java -Xss1024K -Xmx512m -cp \"#{xml_parser_java_paths}\" #{xml_parser_settings} com.icl.saxon.StyleSheet -o #{self.output_path} #{self.file}.xml #{@xsl_stylesheet} #{xml_parser_options}"
      cmd.gsub!(";",":") unless @windows
      cmd    
    end

    # Checks to see if the doc is valid.
    def valid?
      if validate
        validator = Docbook::Validator.new("#{self.file}.xml", self.root)
        if validator.valid?
          true
        else
          OUTPUT.error "Validation errors occurred."
          OUTPUT.error validator.error_messages
          false
        end
      else
        true
      end
      
    end
    
   
    
    # Render the book
    def render
      success = true
       if self.valid?

            # call before_render if defined.
            self.before_render if self.respond_to?("before_render")
            OUTPUT.say "Transforming XML..."
            
            success = self.build
            
            if success
              OUTPUT.say 'Finished XML transformation'
              self.after_render if self.respond_to?("after_render")
            else
              OUTPUT.say "The build process failed."
            end
            
        else
          success = false      
        end
      success
    end
    
    def build
      output = run_command self.xml_cmd
      !output.include?("Exception")
    end
    

  end
end
