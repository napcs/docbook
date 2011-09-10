def copy_xslt_files(root_path, dest_path)
  
  if File.exist?("#{dest_path}/xsl/pdf.xsl")
    FileUtils.mv "#{dest_path}/xsl/pdf.xsl","#{dest_path}/xsl/pdf.xsl.old"
  end  
  
  if  File.exist?("#{dest_path}/xsl/html.css")
    FileUtils.mv "#{dest_path}/xsl/html.css","#{dest_path}/xsl/html.css.old"
  end
  
  if File.exist?("#{dest_path}/xsl/html.xsl")
    FileUtils.mv "#{dest_path}/xsl/html.xsl","#{dest_path}/xsl/html.xsl.old"
  end
  
  if File.exist?("#{dest_path}/xsl/epub.xsl")
    FileUtils.mv "#{dest_path}/xsl/epub.xsl","#{dest_path}/xsl/epub.xsl.old"
  end
  
  if File.exist?("#{dest_path}/xsl/epub.xsl")
    FileUtils.mv "#{dest_path}/xsl/epub.css","#{dest_path}/xsl/epub.css.old"
  end      
  
  if File.exist?("#{dest_path}/xsl/rtf.xsl")
    FileUtils.mv "#{dest_path}/xsl/rtf.xsl","#{dest_path}/xsl/rtf.xsl.old"
  end
  FileUtils.cp  "#{root_path}/template/xsl/pdf.xsl", "#{dest_path}/xsl/pdf.xsl"
  FileUtils.cp  "#{root_path}/template/xsl/html.xsl", "#{dest_path}/xsl/html.xsl"
  FileUtils.cp  "#{root_path}/template/xsl/epub.xsl", "#{dest_path}/xsl/epub.xsl"
  FileUtils.cp  "#{root_path}/template/xsl/epub.css", "#{dest_path}/xsl/epub.css" 
  FileUtils.cp  "#{root_path}/template/xsl/html.css", "#{dest_path}/xsl/html.css" 
  FileUtils.cp  "#{root_path}/template/xsl/rtf.xsl", "#{dest_path}/xsl/rtf.xsl"
  
  puts " - #{dest_path}/xsl/pdf.xsl"
  puts " - #{dest_path}/xsl/html.xsl"
  puts " - #{dest_path}/xsl/epub.xsl"
  puts " - #{dest_path}/xsl/epub.css"
  puts " - #{dest_path}/xsl/html.css"   
  puts " - #{dest_path}/xsl/rtf.xsl"    
   
end