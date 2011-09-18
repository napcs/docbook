require 'test_helper'

class GeneratorTest < Test::Unit::TestCase
  def setup
    @folder = "tmpproject"
    @root =  File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end
  
  def teardown
    FileUtils.rm_rf @folder
  end
  
  def test_creates_book_structure_without_sample
    g = Docbook::Generator.new("book", @root, @folder, :sample => false, :verbose => false)
    g.generate
    assert File.exist?(@folder)
    assert File.exist?(File.join(@folder, "book.xml")), "missing images folder"
    assert File.exist?(File.join(@folder, "images")), "missing images folder"
    assert File.exist?(File.join(@folder, "images", "src")), "missing images folder"
    assert File.exist?(File.join(@folder, "w3centities-f.ent")), "missing images folder"
  end
  
  def test_creates_article_structure_without_sample
    g = Docbook::Generator.new("article", @root, @folder, :sample => false, :verbose => false)
    g.generate
    assert File.exist?(@folder)
    assert File.exist?(File.join(@folder, "article.xml")), "missing images folder"
    assert File.exist?(File.join(@folder, "images")), "missing images folder"
    assert File.exist?(File.join(@folder, "images", "src")), "missing images folder"
    assert File.exist?(File.join(@folder, "w3centities-f.ent")), "missing images folder"
  end
  
  def test_creates_chapter
    FileUtils.mkdir @folder
    Dir.chdir(@folder) do
      g = Docbook::Generator.new("chapter", @root, "foo", :sample => false, :verbose => true)
      g.generate
    end
    
    assert File.exist?(File.join(@folder, "foo.xml"))
    assert File.exist?(File.join(@folder, "w3centities-f.ent")), "missing entities file"
    assert File.exist?(File.join(@folder, "images","foo")), "missing images folder"
    
  end
  
  
  def test_creates_rakefile_with_proper_root_path
    g = Docbook::Generator.new("book", @root, @folder, :sample => false, :verbose => false)
    g.generate
    source = File.read(File.join(@folder, "Rakefile"))
    assert source.include?(@root), "root path not added to the Rakefile correctly"
  end
  
end