unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
end
require 'docbook/adapters/fo/fop'
require 'docbook/adapters/epub/dbtoepub'

require 'docbook/base'
require 'docbook/chm'
require 'docbook/epub'
require 'docbook/html'
require 'docbook/pdf'
require 'docbook/txt'
require 'docbook/rtf'
