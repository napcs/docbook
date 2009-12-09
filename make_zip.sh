cp readme_files/docbook.pdf ./
cp README.rdoc README.txt
zip -r output/docbook-1_1_0.zip make.rb README.txt hhc.exe jars xsl docbook.pdf generate generate.bat template
rm README.txt
