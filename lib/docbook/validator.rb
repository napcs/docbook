module Docbook
  
  # The Validator class is for validating Docbook5 files
  # against the RelaxNG docbook schema.
  class Validator
    
    include Helpers
    
    attr_accessor :file, :root, :errors
    
    # Returns the path to the schema
    def schema
      File.join self.root, "xsl", "docbookxi.rng"
    end
    
    # Displays the error messages as a string
    def error_messages
      self.errors.join("\n\n")
    end
    
    # Command for the validator
    def validator_cmd_old
      "java -jar -Xmx512m -Xss1024K #{self.root}/jars/relames.jar #{schema} #{self.file}"
    end
    
    def validator_cmd
      "java -jar -Xmx512m -Xss1024K  -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration #{self.root}/jars/jing.jar #{schema} #{self.file}"
    end
    
    def initialize(file, root)
      self.root = root
      self.file = file
      self.errors = []
    end

    # Validates the document. Returns true if the document is valid
    def valid?
      self.errors = []
      output = run_command validator_cmd
      OUTPUT.say_debug output
      if output.include?("error:") || output.include?("Exception")
        self.errors << output
      end
      self.errors.empty?
    end
    
  end
end