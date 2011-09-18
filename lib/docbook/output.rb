module Docbook
  # The Output class is for passing output
  # to the end user. Create an instance
  # of the class, set its options, and use the
  # Output#say method or the Output#say_debug messages
  # depending on your needs.
    
  class Output
    attr_accessor :debug, :verbose
    include Helpers
    
    def initialize(options)
      self.debug = options[:debug]
      self.verbose = options[:verbose]
    end
    
    # wraps text in the specified color.
    def colorize(text, color_code)
      if windows?
        text
      else
        "\e[#{color_code}m#{text}\e[0m"
      end
    end

    def red(text); colorize(text, "31"); end
    def green(text); colorize(text, "32"); end
    def yellow(text); colorize(text, "33"); end
      
    # shows debugging messages in yellow if debugging is on.
    def say_debug(message)
      puts yellow(message) if self.debug
    end
    
    # disaplys status messages in green if verbose output is on
    def say(message)
      puts green(message) if self.verbose 
    end
    
    # displays error messages, always.
    def error(message)
      STDERR.puts red(message)
    end
    
  end
end