class DocbookVersion
  @@version = "1.6.2.1"
  @@xsl_version = "1.78.1"
  def self.version
    @@version
  end
  def self.to_s
    "Short Attention Span Docbook v#{@@version}"
  end
  
  def self.xslt_to_s
    "Docbook XSLT-NS Stylesheets v#{@@xsl_version}"
  end
end
