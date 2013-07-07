<?xml version="1.0" encoding="UTF-8"?>

<!--+ ===================================================================== +
    | This template will read an "ivy.xml" file and ensure some artifacts   |
    | are present: it will check and/or create two artifacts for the        |
    | "default" configuration ("bin" and "src" with short names) and two    |
    | for all other public configurations ("bin" and "src" with expanded,   |
    | fully referenced names). Finally, it will also ensure that we have an |
    | artifacts for our JavaDOCs, associated with the "*" configuration.    |
    + ===================================================================== +-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- Better to be safe than sorry -->
  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"/>  

  <!-- Copy all templates we find, regardless -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Match a "publications" node, copy it and insert artifacts -->
  <xsl:template match="/ivy-module/publications">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:call-template name="artifacts"/>
    </xsl:copy>
  </xsl:template>

  <!-- Match a "dependencies" node not preceded by a "publications" node -->
  <xsl:template match="/ivy-module/dependencies[not(preceding::publications)]">

    <!-- In this case we have to prepend "dependencies" with "publications" -->
    <publications>
      <xsl:call-template name="artifacts"/>
    </publications>

    <!-- Copy the reset -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!--+ ========================================================================
      | This is where things get interesting: insert the missing artifacts.
      + -->
  <xsl:template name="artifacts">

    <!-- Iterate through all configurations which are not public -->
    <xsl:for-each select="/ivy-module/configurations/conf[not(@visibility='private')]/@name">

      <!-- Choose your names wisely -->
      <xsl:variable name="name">
        <xsl:choose>
          <xsl:when test=". = 'default'">
            <!-- If the config is "default", the name is short -->
            <xsl:value-of select="/ivy-module/info/@module"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- All other configs get the name as "module-conf". -->
            <xsl:value-of select="concat(/ivy-module/info/@module,'-',.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- One artifact for binaries (jar) -->
      <xsl:call-template name="artifact">
        <xsl:with-param name="conf" select="."/>
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="type" select="'bin'"/>
        <xsl:with-param name="ext" select="'jar'"/>
      </xsl:call-template>

      <!-- One artifact for sources (zip) -->
      <xsl:call-template name="artifact">
        <xsl:with-param name="conf" select="."/>
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="type" select="'src'"/>
        <xsl:with-param name="ext" select="'zip'"/>
      </xsl:call-template>

    </xsl:for-each>

    <!-- And finally create an artifact for all our docs (zip) -->
    <xsl:call-template name="artifact">
      <xsl:with-param name="conf" select="'*'"/>
      <xsl:with-param name="name" select="/ivy-module/info/@module"/>
      <xsl:with-param name="type" select="'doc'"/>
      <xsl:with-param name="ext" select="'zip'"/>
    </xsl:call-template>

  </xsl:template>
  
  <!--+ ========================================================================
      | This gets called to insert an artifact if it wasn't found already.
      + -->
  <xsl:template name="artifact">
    <xsl:param name="conf"/>
    <xsl:param name="name"/>
    <xsl:param name="type"/>
    <xsl:param name="ext"/>
    
    <xsl:if test="not(/ivy-module/publications/artifact[@conf=$conf][@name=$name][@type=$type][@ext=$ext])">
      <artifact conf="{$conf}" name="{$name}" type="{$type}" ext="{$ext}"/>
    </xsl:if>
    
  </xsl:template>
  
</xsl:stylesheet>
