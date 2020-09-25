<?xml version="1.0" encoding="UTF-8"?>
<!-- On inclut la déclaration non prefixé de TEI en déclaration d'espace de nom par déafut pour ne ne pas avoir à la répéter dans chaque nouvelle
création de balise TEI. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <xsl:template match="TEI">
        <xsl:element name="teiCorpus">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="teiHeader">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- On ne prend pas la première <div> qui contient uniquement le titre du recueil de notices.  -->
    <xsl:template match="div[1]"/>
    
    <!-- On définit les variables réutilisables dans le code. -->
    <!-- créer conditions pour savoir combien il y a d'indications de ff. dans $locus_full -->
    <!-- si une seule, alors créer attribut @n avec contenu nettoyé -->
    <!-- si plusieurs, créer attributs @from @to avec les contenus nettoyé ("18" => "18r" ; "19 v°" => "19v") -->
    <xsl:variable name="locus_full">
        <xsl:choose>
            <xsl:when test="matches(., 'Fol.')">
                <xsl:analyze-string select="." regex="—?\s*Fol((.*?)(\n*))\.">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches(., 'fol.')">
                <xsl:analyze-string select="." regex="—?\s*fol((.*?)(\n*))\.">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches(., '\.{3}\s*(\d)+\s*(v°)?\s*\.{3}')">
                <xsl:analyze-string select="." regex="\.{{3}}\s*((\d)+\s*(v°)?)\s*\.{{3}}">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches(., 'P')">                
                <xsl:analyze-string select="." regex="—?\s*P((.*?)(\n*))\.">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches(., '—')">
                <xsl:value-of select="replace(., '—', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before(., '.')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="after_locus">
        <xsl:apply-templates select="substring-after(., $locus_full)"/>
    </xsl:variable>
    <xsl:variable name="italic">
        <xsl:value-of select="hi[@rend = 'italic']"/>
    </xsl:variable>
    
    <!-- On applique à chaque <div> du document source, donc à chaque notice, la strcuture TEI appropriée et définie en format cible. 
    Ossature d'une notice structurée. -->
    <xsl:template match="div[position() != 1]">
        <xsl:element name="TEI">
            <xsl:attribute name="n">
                <xsl:apply-templates select="head/hi[@rend = 'Numero']"/>
            </xsl:attribute>
            <xsl:element name="teiHeader">
                <xsl:element name="fileDesc">
                    <xsl:element name="titleStmt">
                        <xsl:element name="title"/>
                    </xsl:element>
                    <xsl:element name="publicationStmt">
                        <xsl:element name="p">
                            <xsl:text>cf. supra</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="sourceDesc">
                        <xsl:element name="listWit">
                            <xsl:element name="witness">
                                <xsl:element name="msDesc">
                                    <xsl:element name="msIdentifier">
                                        <xsl:element name="repository">
                                            <xsl:text>Bibliothèque nationale</xsl:text>
                                        </xsl:element>
                                        <xsl:apply-templates select="p[@rend = 'Cote']"/>
                                        <xsl:apply-templates select="p/hi[@rend = 'Cote_Car']"/>
                                    </xsl:element>
                                    <xsl:element name="msContents">
                                        <xsl:element name="summary">
                                            <xsl:apply-templates select="head"/>
                                        </xsl:element>
                                        <xsl:apply-templates
                                            select="p[@rend = 'Calendrier'] | p/hi[@rend = 'Calendrier_Car']"/>
                                        <xsl:apply-templates
                                            select="p[@rend = 'Texte du corps (2)']"/>
                                    </xsl:element>
                                    <xsl:element name="physDesc">
                                        <xsl:element name="objectDesc">
                                            <xsl:apply-templates select="p[@rend = 'Codico']"/>
                                        </xsl:element>
                                        <xsl:if test="p[@rend = 'Décoration']|  p/hi[@rend='Décoration_Car']">
                                            <xsl:element name="decoDesc">
                                                <xsl:element name="decoNote">
                                                    <xsl:apply-templates
                                                        select="p[@rend = 'Décoration'] |  p/hi[@rend='Décoration_Car']"/>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:apply-templates
                                            select="p[@rend = 'Reliure'] | p/hi[@rend = 'Reliure_Car']"
                                        />
                                    </xsl:element>
                                    <xsl:element name="history">
                                        <xsl:element name="origin">
                                            <xsl:apply-templates
                                                select="head/hi[@rend = 'Date_Manuscrit']"/>
                                            <xsl:apply-templates select="p[@rend = 'Histoire']"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:apply-templates
                                        select="p/hi[@rend = 'Références_Bibliographie_Car']"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="text">
                <xsl:element name="body">
                    <xsl:element name="p"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- On applique un template à chaque partie du document source dont on récupère l'information et dont on modifie la structure selon le format cible souhaité. -->

    <xsl:template match="head/hi[@rend = 'Numero']">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Récupération des <rubric> au sein d'un paragraphe. -->
    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:variable name="p-id" select="generate-id(.)"/>
            <xsl:element name="msItem">
                <xsl:attribute select="$p-id" name="corresp"/>
                <xsl:for-each select=".">
                    <xsl:for-each select="./hi[@rend='italic']">
                        <xsl:element name="rubric">
                        <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:element name="note">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>