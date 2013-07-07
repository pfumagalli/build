<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings">
  
  <xsl:param name="macro"/>
  <xsl:param name="target"/>
  <xsl:param name="sources"/>
  
  <xsl:template match="/">
    <project>
      <target name="{$target}">
        <xsl:element name="{$macro}">
          <filesets>
            <xsl:for-each select="str:tokenize($sources,',')">
              <fileset includes="**/*.java" defaultexcludes="yes">
                <xsl:attribute name="dir">
                  <xsl:text>${sourcedir}/</xsl:text>
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
