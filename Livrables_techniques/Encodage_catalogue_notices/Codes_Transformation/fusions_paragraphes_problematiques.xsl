<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

    <!-- Copy source file : Ce bout de code permet de ne pas perdre d'informations lors de la transformation en copiant tous les nœuds de document source. -->
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

    <!-- Fusion des paragraphes mal découpés débutant par un tiret, l'abrévation s. pour saint, un guillemet ouvrant ou trois points de suspension. -->
    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Texte du corps (2)'][1][starts-with(., '—') or starts-with(., '—')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates
                        select="following-sibling::p[@rend = 'Texte du corps (2)'][1]" mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., '—') or starts-with(., '—')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="p[@rend = 'Texte du corps (2)'][starts-with(., '—') or starts-with(., '—')]"
        mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Texte du corps (2)'][1][starts-with(., 's.')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates
                        select="following-sibling::p[@rend = 'Texte du corps (2)'][1]" mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., 's.')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p[@rend = 'Texte du corps (2)'][starts-with(., 's.')]" mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Texte du corps (2)'][1][starts-with(., '«')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates
                        select="following-sibling::p[@rend = 'Texte du corps (2)'][1]" mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., '«')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p[@rend = 'Texte du corps (2)'][starts-with(., '«')]" mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Texte du corps (2)'][1][starts-with(., '...')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates
                        select="following-sibling::p[@rend = 'Texte du corps (2)'][1]" mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., '...')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p[@rend = 'Texte du corps (2)'][starts-with(., '...')]" mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[@rend = 'Calendrier']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Calendrier'][1][starts-with(., '—') or starts-with(., '—')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates select="following-sibling::p[@rend = 'Calendrier'][1]"
                        mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., '—') or starts-with(., '—')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p[@rend = 'Calendrier'][starts-with(., '—') or starts-with(., '—')]"
        mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[@rend = 'Décoration']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Décoration'][1][starts-with(., '—') or starts-with(., '—')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates select="following-sibling::p[@rend = 'Décoration'][1]"
                        mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., '—') or starts-with(., '—')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p[@rend = 'Décoration'][starts-with(., '—') or starts-with(., '—')]"
        mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[@rend = 'Histoire']">
        <xsl:choose>
            <xsl:when
                test="following-sibling::p[@rend = 'Histoire'][1][starts-with(., '—') or starts-with(., '—')]">
                <xsl:copy>
                    <xsl:attribute name="rend">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                    <xsl:apply-templates select="following-sibling::p[@rend = 'Histoire'][1]"
                        mode="keep"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(., '—') or starts-with(., '—')"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="p[@rend = 'Histoire'][starts-with(., '—') or starts-with(., '—')]"
        mode="keep">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
