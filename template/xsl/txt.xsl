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
<xsl:import href="fo.xml" />

<!-- graphics for the alerts, tips, cautions, warnings, notes, etc. Build your own or turn this off! -->
<xsl:param name="admon.graphics" select="0" />

<!--programlisting stuff -->
<xsl:param name="use.extensions" select="0"/>
<xsl:param name="linenumbering.extension" select="0"/>
<xsl:param name="linenumbering.everyNth" select="0"/>
<xsl:param name="highlight.source" select="0" />

<!-- section numbering and depth -->
<xsl:param name="section.autolabel" select="1"></xsl:param>
<xsl:param name="section.autolabel.max.depth">1</xsl:param>


<!-- xref -->
<xsl:param name="insert.xref.page.number">yes</xsl:param>

<!-- Generated Text changes -->
 <xsl:param name="collect.xref.targets">no</xsl:param>

 <!-- making "Exercises" from "procedures" -->
 <xsl:param name="local.l10n.xml" select="document('')"/> 
 <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"> 
   <l:l10n language="en"> 
     
     <!-- Change "Procedure" into "Excercise" -->
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
     
     <!-- change how cross-references look -->
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
  /preface  title
  reference toc,title
  /sect1    toc
  /sect2    toc
  /sect3    toc
  /sect4    toc
  /sect5    toc
  /section  toc
  set       toc,title
  </xsl:param>

  <xsl:param name="toc.section.depth">1</xsl:param>

  <!-- fonts -->
  <xsl:param name="body.font.master">10</xsl:param>
  <xsl:param name="body.font.size">
   <xsl:value-of select="$body.font.master"></xsl:value-of><xsl:text>pt</xsl:text>
  </xsl:param>
  <xsl:param name="body.font.family">Courier</xsl:param>


</xsl:stylesheet>
