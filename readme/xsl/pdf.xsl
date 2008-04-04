<?xml version='1.0'?>

<!-- This is a Docbook XSLT Customization Layer. Your XSLT processor will use this file instead of the default Docbook stylesheet.
     This file includes the original stylesheet, and then allows you to override the defaults with your own values. 
     Examples are in this file.
-->

<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:xslthl="http://xslthl.sf.net"
   xmlns:d="http://docbook.org/ns/docbook"
>

<!-- Import the original FO stylesheet -->
<xsl:import href="file:///Users/brianhogan/docbook/xsl/fo/docbook.xsl"/>

<!-- PDF bookmarking support -->
<xsl:param name="fop1.extensions" select="1" />

<!--programlisting stuff -->
<xsl:param name="use.extensions" select="1"/>
<xsl:param name="linenumbering.extension" select="1"/>
<xsl:param name="linenumbering.everyNth" select="1"/>
<xsl:param name="highlight.source" select="1" />

<!-- section numbering and depth -->
<xsl:param name="section.autolabel" select="1"></xsl:param>
<xsl:param name="section.autolabel.max.depth">3</xsl:param>

<!-- <xsl:param name="header.image.filename" select="logo.png" />  -->


<!-- hyphenating and more, so that code examples don't exceed the length of the page -->
<xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="hyphenation-character">\</xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
</xsl:attribute-set>


<!-- borders and shading to note, tip, warning, caution -->
<xsl:attribute-set name="admonition.properties">
  <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
  <xsl:attribute name="background-color">#ffffee</xsl:attribute>
  <xsl:attribute name="padding">0.1in</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="sidebar.properties">
  <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
  <xsl:attribute name="background-color">#ffffee</xsl:attribute>
  <xsl:attribute name="padding">0.1in</xsl:attribute>
</xsl:attribute-set>


<!-- border and shade to screen and programlisting -->
<xsl:attribute-set name="verbatim.properties">
  <xsl:attribute name="border">0.5pt #000000</xsl:attribute>
  <xsl:attribute name="background-color">#eeeeee</xsl:attribute>
  <xsl:attribute name="padding">0.1in</xsl:attribute>
</xsl:attribute-set>

<!-- Border and shading for section 1 titles
<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
  <xsl:attribute name="padding">8pt</xsl:attribute>
</xsl:attribute-set>
-->

<!-- header and footer control
<xsl:attribute-set name="header.table.properties">
  <xsl:attribute name="background-color">#CCCCFF</xsl:attribute>
  <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
  <xsl:attribute name="padding-left">5pt</xsl:attribute>
  <xsl:attribute name="padding-right">5pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="footer.table.properties">
  <xsl:attribute name="background-color">#CCCCFF</xsl:attribute>
  <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
  <xsl:attribute name="padding-left">5pt</xsl:attribute>
  <xsl:attribute name="padding-right">5pt</xsl:attribute>
</xsl:attribute-set>
<xsl:param name="header.rule">0</xsl:param>


-->


<xsl:template name="footer.content">  
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>
  <fo:block>
  
  
  <xsl:choose>
      <xsl:when test="$position = 'center'">
        <fo:page-number/>  
      </xsl:when>
      <xsl:when test="$position = 'left'">
          <xsl:text>Copyright </xsl:text>
          <!-- use xpath to grab the year - remember to prefix each node with d: -->
          <xsl:value-of select="ancestor-or-self::d:book/d:info/d:copyright/d:year"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="ancestor-or-self::d:book/d:info/d:copyright/d:holder"/>
      </xsl:when>
      
      <xsl:when test="$position = 'right'">
        <xsl:text>http://www.napcs.com/products/docbook</xsl:text> 
      </xsl:when>
<!--
<xsl:when test="$position = 'center'">
  <fo:external-graphic content-height="1.2cm">
    <xsl:attribute name="src">
      <xsl:call-template name="fo-external-image">
        <xsl:with-param name="filename" select="$header.image.filename"/>
      </xsl:call-template>
    </xsl:attribute>
  </fo:external-graphic>
</xsl:when>
-->
  
  </xsl:choose>
  
  </fo:block>
</xsl:template>





<xsl:template match='xslthl:keyword'>
  <fo:inline font-weight="bold" color="blue"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match='xslthl:comment'>
  <fo:inline font-style="italic" color="green"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match='xslthl:string'>
  <fo:inline color="red"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match='d:filename'>
  <fo:inline color="purple">
    <xsl:call-template name="inline.monoseq"/>
  </fo:inline>
</xsl:template>


<xsl:template match='d:command'>
  <fo:inline color="red">
    <xsl:call-template name="inline.monoseq"/>
  </fo:inline>
</xsl:template>


</xsl:stylesheet>
