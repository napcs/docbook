
class DocbookVersion
  @@version = "1.3"
  
  def self.version
    @@version
  end
  def self.to_s
    "Short Attention Span Docbook v#{@@version}"
  end
end