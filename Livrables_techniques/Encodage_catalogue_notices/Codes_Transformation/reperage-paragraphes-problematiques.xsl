<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

    <!-- Copy source file : Ce bout de code permet de ne pas perdre d'informations lors de la transformation en copiant tous les nœuds de document source.-->
    <xsl:template match="@* | node()" mode="#all">
        <xsl:choose>
            <xsl:when test="matches(name(.), '^(part|instant|anchored|default|full|status)$')"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="#current"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Vision des paragraphes mal-découpés relatifs aux msItem dans le document océrisé : ceux ne commençant pas par un F majuscule, un chiffre [pour ce dernier cas, ceux débutant par un chiffre ont aussi été vérifiés], ceux débutant par un guillemet ouvrant, un tiret ou trois points de suspension.. -->
    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:choose>
            <xsl:when test="not(starts-with(., 'F'))">
                <p>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:when>
            <xsl:when test="not(matches(., '^(\d)+'))">
                <p>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:when>
            <xsl:when test="matches(., '^(\d)+')">
                <p>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:when>
            <xsl:when test="starts-with(., '«')">
                <p>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:when>
            <xsl:when test="starts-with(., '—')">
                <p>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:when>
            <xsl:when test="starts-with(., '...')">
                <p>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
