require 'test_helper'

class HelpersTest < Test::Unit::TestCase
  include Helpers
  def setup
    @folder = "tmpproject"
    FileUtils.mkdir @folder

    @stdout_orig = $stdout 
    $stdout = StringIO.new 
  end
  
  def teardown
    FileUtils.rm_rf @folder
    $stdout = @stdout_orig 
  end
  
  def test_makes_folder
    dest = File.join @folder, "dest"
    mkdir_p dest
    assert File.exist?(dest)
  end
  
  def test_makes_folder_and_puts_something_out_with_verbose
    dest = File.join @folder, "dest"
    OUTPUT.verbose = true
    mkdir_p dest
    assert $stdout.string.include?(" - #{dest}")
  end
  
  def test_makes_folder_silently
    dest = File.join @folder, "dest"
    OUTPUT.verbose = false
    mkdir_p dest
    assert !$stdout.string.include?(" - #{dest}")
  end
  
  def test_makes_folder_structure
    dest = File.join @folder, "dest", "level2"
    mkdir_p dest
    assert File.exist?(dest)
  end
  
  def test_copies_file
    source = File.join @folder, "src.txt"
    FileUtils.touch source
    dest = File.join @folder, "dest.txt"
    cp source, dest
    assert File.exist?(dest)
  end
  
  def test_render_template_to_file
   # setup template
   template = "My name is <%=@name %>."
   File.open(File.join(@folder, "template.erb"), "w") do |f|
     f << template
   end
   
   @name = "Homer Simpson"
   render_template_to_file File.join(@folder, "template.erb"), 
                           File.join(@folder, "output.txt"),
                           binding
                           
   source = File.read(File.join(@folder, "output.txt"))
   assert source.include?("My name is Homer Simpson."), "doesn't include the text"
   
   
  end
  
  
end