class DocbookVersion
  @@version = "1.5.3"
  @@xsl_version = "1.76.1"
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
