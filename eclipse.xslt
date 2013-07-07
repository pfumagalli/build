<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"/>

  <xsl:param name="ivyfile"/>
  <xsl:param name="sourcedir"/>
  <xsl:param name="eclipseout"/>

  <xsl:template match="/">
    <classpath>
      <classpathentry kind="output" path="{$eclipseout}"/>
      <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
      <xsl:apply-templates select="document($ivyfile)/ivy-module/configurations/conf"/>
      <xsl:apply-templates select="/modules/module"/>
    </classpath>
  </xsl:template>

  <xsl:template match="conf">
    <classpathentry kind="src" path="{$sourcedir}/{@name}" output="{$eclipseout}"/>
  </xsl:template>

  <xsl:template match="module">
    <classpathentry kind="lib">
      <xsl:if test="artifact[@type='bin']">
        <xsl:attribute name="path">
          <xsl:value-of select="artifact[@type='bin']/cache-location"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="artifact[@type='src']">
        <xsl:attribute name="sourcepath">
          <xsl:value-of select="artifact[@type='src']/cache-location"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="artifact[@type='doc']">
        <attributes>
          <attribute name="javadoc_location" value="jar:file:{artifact[@type='doc']/cache-location}!/"/>
        </attributes>
      </xsl:if>

    </classpathentry>
  </xsl:template>

</xsl:stylesheet>
