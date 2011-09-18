require 'rubygems'
require 'fileutils'
require 'test/unit'
require 'stringio'
require 'mocha'
require 'version'
require 'lib/docbook'

# logger

OUTPUT = Docbook::Output.new(:verbose => true)