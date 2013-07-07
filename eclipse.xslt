<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"/>

  <xsl:param name="ivyfile"/>
  <xsl:param name="sourcedir"/>
  <xsl:param name="eclipseout"/>

  <!-- Start creating a normal Eclipse .classpath file -->
  <xsl:template match="/">
    <classpath>
      <!-- Output and container -->
      <classpathentry kind="output" path="{$eclipseout}"/>
      <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>

      <!-- Parse in the Ivy file and convert configurations in source paths -->
      <xsl:apply-templates select="document($ivyfile)/ivy-module/configurations/conf"/>

      <!-- Using the artifact report, configure all libraries -->
      <xsl:apply-templates select="/modules/module"/>
    </classpath>
  </xsl:template>

  <!-- Configurations in Ivy become source paths in Eclipse -->
  <xsl:template match="conf">
    <classpathentry kind="src" path="{$sourcedir}/{@name}" output="{$eclipseout}"/>
  </xsl:template>

  <!-- Modules in the artifact report become libraries in Eclipse -->
  <xsl:template match="module">
    <classpathentry kind="lib">

      <!-- If we have a "bin" artifact, it's the path of our library -->
      <xsl:if test="artifact[@type='bin']">
        <xsl:attribute name="path">
          <xsl:value-of select="artifact[@type='bin']/cache-location"/>
        </xsl:attribute>
      </xsl:if>

      <!-- If we have a "src" artifact, link in the sources -->
      <xsl:if test="artifact[@type='src']">
        <xsl:attribute name="sourcepath">
          <xsl:value-of select="artifact[@type='src']/cache-location"/>
        </xsl:attribute>
      </xsl:if>

      <!-- If we have a "doc" artifact, add the JavaDOC attribute -->
      <xsl:if test="artifact[@type='doc']">
        <attributes>
          <attribute name="javadoc_location" value="jar:file:{artifact[@type='doc']/cache-location}!/"/>
        </attributes>
      </xsl:if>

    </classpathentry>
  </xsl:template>

</xsl:stylesheet>
