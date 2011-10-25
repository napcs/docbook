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
<xsl:import href="epub_base.xsl" />

<!-- graphics for the alerts, tips, cautions, warnings, notes, etc. Build your own or turn this off! -->
<xsl:param name="admon.graphics" select="1" />
<xsl:param name="admon.graphics.path">images/</xsl:param>

<xsl:param name="html.stylesheet" select="'style.css'" />

<!--programlisting stuff -->
<xsl:param name="use.extensions" select="1"/>
<xsl:param name="linenumbering.extension" select="0"/>
<xsl:param name="linenumbering.everyNth" select="1"/>
<xsl:param name="linenumbering.separator"><xsl:text>&gt; </xsl:text></xsl:param>
<xsl:param name="highlight.source" select="1" />


<!-- section numbering and depth -->
<xsl:param name="section.autolabel" select="1"></xsl:param>
<xsl:param name="section.autolabel.max.depth">2</xsl:param>


<!-- xref -->
<xsl:param name="insert.xref.page.number">yes</xsl:param>

<!-- Generated Text changes -->
 <xsl:param name="collect.xref.targets">no</xsl:param>

 <!-- making "Exercises" from "procedures" -->
 <xsl:param name="local.l10n.xml" select="document('')"/> 
 <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"> 
   <l:l10n language="en"> 
   <l:gentext key="Procedure" text="Exercise"/>
   <l:gentext key="procedure" text="exercise"/>
   <l:gentext key="ListofProcedures" text="List of Exercises"/>
   <l:gentext key="listofprocedures" text="List of Exercises"/>


     <l:context name="title">
       <l:template name="procedure" text="%t"/>
       <l:template name="procedure.formal" text="Exercise %n. %t"/>
     </l:context>

     <l:context name="xref-number-and-title">
       <l:template name="procedure" text="Exercise %n, “%t”"/>
     </l:context>
     
     <l:context name="xref">
       <l:template name="page.citation" text=" on page %p"/>
     </l:context>
     
     
   </l:l10n>
 </l:i18n>
 

<!-- TOC settings -->

<xsl:param name="generate.toc">
/appendix toc,title
article/appendix  nop
/article  toc,title
book      toc,title,figure,table,example,equation
/chapter  toc,title
part      title
/preface  toc,title
reference toc,title
/sect1    toc
/sect2    toc
/sect3    toc
/sect4    toc
/sect5    toc
/section  toc
set       toc,title
</xsl:param>

<xsl:param name="alignment">left</xsl:param>


<!-- fonts -->




<!-- hyphenating and more, so that code examples don't exceed the length of the page -->
<xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="hyphenation-character">\</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    
</xsl:attribute-set>


<!-- code highlighting -->
<xsl:template match='xslthl:keyword' mode="xslthl">
  <span class="hl-keyword"><xsl:apply-templates mode="xslthl"/></span>
</xsl:template>

<xsl:template match='xslthl:comment' mode="xslthl">
  <span class="hl-comment"><xsl:apply-templates mode="xslthl"/></span>
</xsl:template>

<xsl:template match='xslthl:string' mode="xslthl">
  <span class="hl-string"><xsl:apply-templates mode="xslthl"/></span>
</xsl:template>

<xsl:template match='xslthl:tag' mode="xslthl">
  <span class="hl-tag"><xsl:apply-templates mode="xslthl"/></span>
</xsl:template>

<xsl:template match='xslthl:attribute' mode="xslthl">
  <span class="hl-attribute"><xsl:apply-templates mode="xslthl"/></span>
</xsl:template>

<xsl:template match='xslthl:value' mode="xslthl">
  <span class="hl-value"><xsl:apply-templates mode="xslthl"/></span>
</xsl:template>

<!-- keyword highlighting -->

<xsl:template match='d:filename'>
  <span class="filename">
    <xsl:call-template name="inline.monoseq"/>
  </span>
</xsl:template>


  <xsl:template match='d:application'>
    <span class="application">
      <xsl:call-template name="inline.italicseq"/>
    </span>
  </xsl:template>

  <xsl:template match='d:command'>
    <span class="command">
      <xsl:call-template name="inline.monoseq"/>
    </span>
  </xsl:template>
  
  <xsl:template match='d:userinput'>
    <span class="userinput">
      <xsl:call-template name="inline.monoseq" />
    </span>
  </xsl:template>

  <xsl:template match='d:classname'>
   <span class="classname">
      <xsl:call-template name="inline.monoseq" />
   </span>
  </xsl:template>

  <xsl:template match='d:methodname'>
    <span class="methodname">
      <xsl:call-template name="inline.monoseq" />
    </span>
  </xsl:template>
  
  <xsl:template match='d:literal'>
    <span class="literal">
      <xsl:call-template name="inline.monoseq" />
    </span>
  </xsl:template>
  

</xsl:stylesheet>
