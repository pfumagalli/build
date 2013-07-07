<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"/>

  <xsl:param name="macro"/>
  <xsl:param name="target"/>
  <xsl:param name="sources"/>

  <!-- This is simple, we just need to prepare an Ant build file -->
  <xsl:template match="/">
    <project>
      <target name="{$target}">
        <xsl:element name="{$macro}">
          <filesets>
            
            <!-- Split the "sources" parameter, for each prepare a fileset -->
            <xsl:for-each select="str:tokenize($sources,',')">
              <fileset includes="**/*.java" defaultexcludes="yes">
                <xsl:attribute name="dir">
                  <xsl:text>${sourcedir}/</xsl:text>
                  <!-- Remember to trim white space, it could be comma spc -->
                  <xsl:value-of select="normalize-space(.)"/>
                </xsl:attribute>
              </fileset>
            </xsl:for-each>

          </filesets>
        </xsl:element>
      </target>
    </project>
  </xsl:template>

</xsl:stylesheet>
