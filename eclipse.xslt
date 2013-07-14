<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"/>

  <xsl:param name="ivyfile"/>
  <xsl:param name="basedir"/>
  <xsl:param name="sourcedir"/>
  <xsl:param name="eclipsedir"/>
  
  <xsl:variable name="eclipseout" select="substring-after($eclipsedir,concat($basedir,'/'))"/>
  <xsl:variable name="ivy" select="document($ivyfile)"/>

  <!-- Start creating a normal Eclipse .classpath file (order is important) -->
  <xsl:template match="/">
    <classpath>
      <!-- Parse in the Ivy file and convert configurations in source paths -->
      <xsl:apply-templates select="$ivy/ivy-module/configurations/conf"/>

      <!-- Container (our JRE libraries) -->
      <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>

      <!-- Using the artifact report, configure all libraries -->
      <xsl:apply-templates select="/modules/module">
        <xsl:sort select="@organisation"/>
        <xsl:sort select="@name"/>
        <xsl:sort select="@rev"/>
      </xsl:apply-templates>

      <!-- Output directory -->
      <classpathentry kind="output" path="{$eclipseout}"/>
    </classpath>
  </xsl:template>

  <!-- Configurations in Ivy become source paths in Eclipse -->
  <xsl:template match="conf">
    <classpathentry kind="src" path="{substring-after($sourcedir,concat($basedir,'/'))}/{@name}"
                    output="{$eclipseout}"/>
  </xsl:template>

  <!-- Modules -->
  <xsl:template match="module">
    <xsl:apply-templates select="artifact[@type='bin']"/>
  </xsl:template>
  
  <!-- Artifacts -->
  <xsl:template match="artifact">
    <xsl:if test="@type='bin'">
      <xsl:if test="cache-location">
        <classpathentry kind="lib">

          <!-- If we have a "bin" artifact, it's the path of our library -->
          <xsl:attribute name="path">
            <xsl:value-of select="cache-location"/>
          </xsl:attribute>
          
          <xsl:variable name="name" select="@name"/>

          <!-- If we have a "src" artifact, link in the sources -->
          <xsl:if test="../artifact[@name=$name][@type='src']">
            <xsl:attribute name="sourcepath">
              <xsl:value-of select="../artifact[@name=$name][@type='src']/cache-location"/>
            </xsl:attribute>
          </xsl:if>

          <!-- If we have a "doc" artifact, add the JavaDOC attribute -->
          <xsl:if test="../artifact[@name=$name][@type='doc']">
            <attributes>
              <attribute name="javadoc_location" value="jar:file:{../artifact[@name=$name][@type='doc']/cache-location}!/"/>
            </attributes>
          </xsl:if>

          <!-- Make sure we generate warning for transitive dependencies -->
          <xsl:variable name="organisation" select="../@organisation"/>
          <xsl:variable name="module-name" select="../@name"/>
          <xsl:variable name="module-rev" select="../@rev"/>
          <xsl:if test="not($ivy/ivy-module/dependencies/dependency[@org=$organisation][@name=$module-name][@rev=$module-rev])">
            <accessrules>
              <accessrule kind="discouraged" pattern="**"/>
            </accessrules>
          </xsl:if>

        </classpathentry>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
