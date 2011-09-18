require 'test_helper'

class DocbookBaseTest < Test::Unit::TestCase
  
  def setup
    @folder = "tmpproject"
    FileUtils.mkdir_p @folder
    @root =  File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end
  
  def teardown
    FileUtils.rm_rf @folder
  end
    
  def test_render_calls_before_render
    @b = Docbook::Base.new(:root => @root, :file => "book")
    @b.stubs(:valid?).returns(true)
    @b.stubs(:run_command).returns("")
    @b.expects(:before_render)
    @b.render
  end
      
  def test_render_calls_after_render    
    @b = Docbook::Base.new(:root => @root, :file => "book")
    @b.stubs(:valid?).returns(true)
    @b.stubs(:run_command).returns("")
    @b.expects(:after_render)
    @b.render
  end
  
  def test_does_not_validate_when_validation_is_skipped
    @b = Docbook::Base.new(:root => @root, :file => "book", :validate => false)
    Docbook::Validator.any_instance.expects(:valid?).never
    @b.stubs(:run_command).returns("")
    @b.render
  end
  
  def test_valid_returns_false_when_validation_fails
    Docbook::Validator.any_instance.stubs(:valid?).returns(false)
    Docbook::Validator.any_instance.stubs(:errors).returns(["fail!"])
    Docbook::Validator.any_instance.stubs(:run_command).returns("")
    @b = Docbook::Base.new(:root => @root, :file => "book")
    assert !@b.valid?
  end
  
  def test_does_not_run_build_when_valid_is_false
    @b = Docbook::Base.new(:root => @root, :file => "book")
    @b.expects(:valid?).returns(false)
    @b.expects(:build).never
    @b.expects(:before_render).never
    @b.expects(:after_render).never
    @b.render
  end
  
end