<?xml version="1.0" encoding="UTF-8"?>
<!-- On inclut la déclaration non prefixé de TEI en déclaration d'espace de nom par défaut pour ne ne pas avoir à la répéter dans chaque nouvelle
création de balise TEI. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <!-- Suppression des espaces blancs en trop pour tous les éléments. -->
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <!-- Création de l'élément racine et de son premier descendant. -->
    <xsl:template match="TEI">
        <xsl:element name="teiCorpus" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Création du teiHeader du document, qui reprend ici les informations du document source converti. Il sera à modifier selon ce qui a été déterminé pour les troix notices modèles dans le document cible. -->
    <xsl:template match="teiHeader">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- On ne prend pas la première <div> qui contient uniquement le titre du recueil de notices dans le document source.  -->
    <xsl:template match="div[1]"/>
    
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

    <xsl:template match="p[@rend = 'Cote'] | p/hi[@rend = 'Cote_Car']">
        <xsl:element name="idno">
            <xsl:variable name="cote" select="."/>
            <xsl:analyze-string select="$cote" regex=",\s*(.*(\n*).*)">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:element>
    </xsl:template>

    <xsl:template match="head">
        <!-- solution 1 : on prend le texte qui descend directement de <head>, cela supprime tout encodage supplémentaire -->
        <xsl:value-of select="normalize-space(./text()[1])"/>
        <!-- solution 2: on garde l'encodage supplémentaire, mais on a un autre template qui supprime <hi/> -->
        <!-- <xsl:apply-templates select="." mode="head"/>-->
        <!-- Récupération du premier paragraphe s'il concerne l'ensemble du contenu du mansucrit. -->
        <xsl:value-of
            select="normalize-space(following-sibling::p[@rend = 'Texte du corps (2)'][1][not(starts-with(., 'F'))])"
        />
    </xsl:template>
    <!--Suite solution 2 -->
   <!-- <xsl:template mode="head" match="hi"/>-->

    <xsl:template match="p[@rend = 'Calendrier'] | p/hi[@rend = 'Calendrier_Car']">
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
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(., '.')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="msItem">
            <xsl:element name="locus">
                <xsl:choose>
                    <xsl:when test="matches($locus_full, 'à') or matches($locus_full, 'et')">
                        <xsl:attribute name="from">
                            <xsl:value-of
                                select="normalize-space(substring-before($locus_full, 'et'))"/>
                            <xsl:value-of
                                select="normalize-space(substring-before($locus_full, 'à'))"/>
                            <xsl:if test="not(matches(substring-before($locus_full, 'et|à'), 'v'))">
                                <xsl:text>r</xsl:text>
                            </xsl:if>
                            <xsl:if test="matches(substring-before($locus_full, 'et|à'), 'v')">
                                <xsl:value-of select="replace(., 'v°', 'v')"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="to">
                            <xsl:value-of
                                select="normalize-space(substring-after($locus_full, 'et'))"/>
                            <xsl:value-of
                                select="normalize-space(substring-after($locus_full, 'à'))"/>
                            <xsl:if test="not(contains(substring-before($locus_full, 'et|à'), 'v'))">
                                <xsl:text>r</xsl:text>
                            </xsl:if>
                            <xsl:if test="matches(substring-before($locus_full, 'et|à'), 'v')">
                                <xsl:value-of select="replace(., 'v°', 'v')"/>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="n">
                            <xsl:if
                                test="matches($locus_full, '\d+') or matches($locus_full, '[A-Z]+')">
                                <xsl:value-of select="normalize-space(.)"/>
                                <xsl:if test="not(matches(., 'v'))">
                                    <xsl:text>r</xsl:text>
                                </xsl:if>
                                <xsl:if test="matches(., 'v')">
                                    <xsl:value-of select="replace(., 'v°', 'v')"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="normalize-space($locus_full)"/>
            </xsl:element>
            <xsl:variable name="title">
                <xsl:value-of select="substring-after(., '.')"/>
            </xsl:variable>
            <xsl:if test="matches($title, 'Calendrier')">
                <xsl:element name="title">
                    <xsl:variable name="calendrier" select="."/>
                    <xsl:analyze-string select="$calendrier"
                        regex="([0-9|v°]+\.\s*)?(Calendrier+(.*?)\n*(.*?))([;|\.|:|—])+">
                        <xsl:matching-substring>
                            <xsl:value-of select="normalize-space(regex-group(2))"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:element>
            </xsl:if>
            <!-- Choix de mettre tout le contenu du paragraphe dans <note> pour éviter d'éventuelles pertes d'information
         avec des regex.-->
            <xsl:element name="note">
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p[@rend = 'Codico']">
        <xsl:element name="supportDesc">
            <xsl:variable name="material">
                <xsl:if
                    test="
                    starts-with(., 'Par')
                    or starts-with(., 'Vel')
                    or starts-with(., 'Vél')"
                    >parch</xsl:if>
                <xsl:if test="starts-with(., 'Pap')">paper</xsl:if>
            </xsl:variable>
            <xsl:attribute name="material">
                <xsl:value-of select="normalize-space($material)"/>
            </xsl:attribute>
            <xsl:variable name="material_developped">
                <xsl:if test="$material = 'parch'">Parchemin</xsl:if>
                <xsl:if test="$material = 'paper'">Papier</xsl:if>
            </xsl:variable>
            <xsl:element name="support">
                <xsl:element name="material">
                    <xsl:value-of select="normalize-space($material_developped)"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="extent">
                <xsl:if test="matches(., '(\d+)\s*(f|p)')">
                    <measure type="composition" unit="leaf">
                        <xsl:attribute name="quantity">
                            <xsl:variable name="measure" select="."/>
                            <xsl:analyze-string select="$measure" regex="((\d+)\s*(f|p))">
                                <xsl:matching-substring>
                                    <xsl:value-of select="normalize-space(regex-group(2))"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:attribute>
                        <xsl:variable name="measure" select="."/>
                        <xsl:analyze-string select="$measure" regex="(\d+)\s*(f|p)">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(1))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </measure>
                </xsl:if>
                <xsl:if test="matches(., '(\d+)\s*sur\s*(\d+)\s*mill')">
                    <dimensions scope="all" type="leaf" unit="mm">
                        <xsl:element name="height">
                            <xsl:attribute name="quantity">
                                <xsl:variable name="height" select="."/>
                                <xsl:analyze-string select="$height" regex="(\d+)\s*sur\s*(\d+)\s*mill">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:attribute>
                            <xsl:variable name="height" select="."/>
                            <xsl:analyze-string select="$height" regex="(\d+)\s*sur\s*(\d+)\s*mill">
                                <xsl:matching-substring>
                                    <xsl:value-of select="normalize-space(regex-group(1))"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:element>
                        <xsl:element name="width">
                            <xsl:attribute name="quantity">
                                <xsl:variable name="width" select="."/>
                                <xsl:analyze-string select="$width" regex="(\d+)\s*sur\s*(\d+)\s*mill">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:attribute>
                            <xsl:variable name="width" select="."/>
                            <xsl:analyze-string select="$width" regex="(\d+)\s*sur\s*(\d+)\s*mill">
                                <xsl:matching-substring>
                                    <xsl:value-of select="normalize-space(regex-group(1))"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:element>
                    </dimensions>
                </xsl:if>
            </xsl:element>
            <!-- Choix de prendre dans <condition> l'ensemble des informations relatives à la codicologie pour éviter d'éventuelles pertes d'informations. -->
            <xsl:element name="condition">
                <xsl:value-of select="normalize-space(.)"/>
                <!-- Tentative de récupérer uniquement les informations relatives à l'état matériel du manuscrit. -->
                <!--<xsl:choose>
                                                            <xsl:when test="contains(., 'incomplet|mutilés|lacunes')">
                                                                <xsl:variable name="etat" select="./p[@rend='Codico']"/>
                                                                <xsl:analyze-string select="$etat" regex="(col\.|lignes\s*),|;(.*?(incomplet|mutilés|lacunes)+.*?\n*)\.\s+(—)?">
                                                                    <xsl:matching-substring>
                                                                        <xsl:value-of select="regex-group(2)"/>    
                                                                    </xsl:matching-substring>
                                                                </xsl:analyze-string>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="./p[@rend='Codico']"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>-->
            </xsl:element>
        </xsl:element>
        <xsl:element name="layoutDesc">
            <xsl:element name="layout">
                <xsl:attribute name="columns">
                    <xsl:if test="matches(., 'col')">
                        <xsl:variable name="col" select="."/>
                        <xsl:analyze-string select="$col" regex="(.*?)(\d+)\s*col(.*?)">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(2))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:if>
                    <xsl:if test="not(matches(., 'col')) or matches(., 'longues lignes')">1</xsl:if>
                </xsl:attribute>
                <xsl:if test="matches(., 'col')">
                    <xsl:variable name="col" select="."/>
                    <xsl:analyze-string select="$col" regex="(.*?)(\d+\s*col)(.*?)">
                        <xsl:matching-substring>
                            <xsl:value-of select="normalize-space(regex-group(2))"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
                <xsl:if test="not(matches(., 'col')) or matches(., 'longues lignes')">
                    <xsl:text>1 col.</xsl:text>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p[@rend = 'Décoration'] | p/hi[@rend='Décoration_Car']">
        <xsl:element name="p">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p[@rend = 'Reliure'] | p/hi[@rend = 'Reliure_Car']">
        <xsl:element name="bindingDesc">
            <xsl:element name="binding">
                <xsl:element name="p">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="head/hi[@rend = 'Date_Manuscrit']">
        <xsl:element name="origDate">
            <xsl:value-of select="normalize-space(.)"/>
            <!-- Tentative de matcher les mentions de date dans les paragraphes relatifs 
         au contexte de production du manuscrit : pas automatisable ? Cf. problème de l'information de date 
        éclatée dans plusieurs paragraphes. -->
            <!-- <xsl:if test="following::p[@rend='Histoire'][contains(., 'date')]">
                                                    <xsl:variable name="date" select="."/>
                                                    <xsl:analyze-string select="$date" regex="\.((.*?)(\n*)(date)+(.*?)(\n*)\.)">
                                                        <xsl:matching-substring>
                                                            <xsl:value-of select="regex-group(1)"/>
                                                        </xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:if>-->
        </xsl:element>
    </xsl:template>

    <xsl:template match="p[@rend = 'Histoire']">
        <xsl:element name="p">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <!-- Tentative de prendre les phrases mentionnant les possesseurs des manuscrits : pas automatisable ? L'information peut
        concerner plus d'une phrase.... -->
        <!--<xsl:if test=".|following-sibling::p[@rend='Histoire'][contains(.,'possesseur|possesseurs')]">
                                                <xsl:element name="provenance" namespace="http://www.tei-c.org/ns/1.0">
                                                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:variable name="provenance" select="."/>
                                                        <xsl:analyze-string select="$provenance" regex="\.((.*?)\n*(possesseur|possesseurs)+(.*?)\n*\.)">
                                                            <xsl:matching-substring>
                                                                <xsl:value-of select="regex-group(1)"/>
                                                            </xsl:matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:if>-->
    </xsl:template>

    <xsl:template match="p/hi[@rend = 'Références_Bibliographie_Car']">
        <xsl:element name="additional">
            <xsl:element name="listBibl">
                <xsl:variable name="biblio" select="normalize-space(.)"/>
                <xsl:for-each select="tokenize($biblio, '—')">
                    <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:variable name="italic">
        <xsl:value-of select="./hi[@rend = 'italic']"/>
    </xsl:variable>

    <xsl:template match="p[@rend = 'Texte du corps (2)']">
        <xsl:variable name="p-id" select="generate-id(.)"/>
        <xsl:variable name="msItem_hypothese" select="tokenize(., '—')"/>
        <xsl:for-each select="$msItem_hypothese">
            <xsl:variable name="locus_full">
                <xsl:choose>
                    <xsl:when test="matches(., 'Fol.')">
                        <xsl:analyze-string select="." regex="—?\s*Fol\.((.*?)(\n*))\.">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(1))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:when test="matches(., 'fol.')">
                        <xsl:analyze-string select="." regex="—?\s*fol\.((.*?)(\n*))\.">
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
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(., '.')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="after_locus">
                <xsl:value-of select="substring-after(., $locus_full)"/>
            </xsl:variable>
            <xsl:element name="msItem">
                <xsl:attribute select="$p-id" name="corresp"/>
                <xsl:element name="locus">
                    <xsl:choose>
                        <xsl:when test="matches($locus_full, 'à') or matches($locus_full, 'et')">
                            <xsl:attribute name="from">
                                <xsl:value-of
                                    select="normalize-space(substring-before($locus_full, 'et'))"/>
                                <xsl:value-of
                                    select="normalize-space(substring-before($locus_full, 'à'))"/>
                                <xsl:if
                                    test="not(contains(substring-before($locus_full, 'et | à'), 'v°'))">
                                    <xsl:if test="matches($locus_full, 'Fol|fol')">
                                        <xsl:text>r</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:if
                                    test="matches(substring-before($locus_full, 'et | à'), 'v°')">
                                    <xsl:value-of
                                        select="replace(substring-before($locus_full, 'et | à'), 'v°', '')"/>
                                    <xsl:if test="matches($locus_full, 'Fol|fol')">
                                        <xsl:text>v</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:attribute name="to">
                                <xsl:value-of
                                    select="normalize-space(substring-after($locus_full, 'et'))"/>
                                <xsl:value-of
                                    select="normalize-space(substring-after($locus_full, 'à'))"/>
                                <xsl:if
                                    test="not(matches(substring-after($locus_full, 'et | à'), 'v°'))">
                                    <xsl:if test="matches($locus_full, 'Fol|fol')">
                                        <xsl:text>r</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:if
                                    test="matches(substring-after($locus_full, 'et | à'), 'v°')">
                                    <xsl:value-of
                                        select="replace(substring-after($locus_full, 'et | à'), 'v°', '')"/>
                                    <xsl:if test="matches($locus_full, 'Fol|fol')">
                                        <xsl:text>v</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="n">
                                <xsl:if
                                    test="matches($locus_full, '\d+') or matches($locus_full, '[A-Z]+')">
                                    <xsl:if test="not(matches($locus_full, 'v'))">
                                        <xsl:value-of select="normalize-space($locus_full)"/>
                                        <xsl:text>r</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="matches($locus_full, 'v°')">
                                        <xsl:value-of
                                            select="normalize-space(replace($locus_full, 'v°', ''))"/>
                                        <xsl:text>v</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="normalize-space($locus_full)"/>
                </xsl:element>
                <xsl:if
                    test="not(matches($after_locus, '«')) and not(matches($after_locus, '»')) and not(matches($after_locus, '...'))">
                    <xsl:element name="title">
                        <xsl:analyze-string select="$after_locus" regex="((.*?)\n*(.*?))([;|\.])+">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(1))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="matches($after_locus, '«')">
                    <xsl:element name="incipit">
                        <!-- Regex qui prend en compte toutes les possibilités observées : (([0-9|v°|A-Z]+\.\s*)?«\s*[A-ZÉÈÀÙ]{{1}}(.*?)(\n*)(.*?)(\.{{3}}|:|—)) -->
                        <xsl:analyze-string select="$after_locus"
                            regex="«\s*((.*?)(\n*)(.*?)\.{{3}})">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(1))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:element>
                </xsl:if>
                <xsl:if
                    test="matches($after_locus, '...') and not(matches($after_locus, '«')) and not(matches($after_locus, '»'))">
                    <xsl:element name="quote">
                        <!-- Regex qui prend en compte toutes les possibilités observées : (([0-9|v°|A-Z]+\.\s*)?(\.{{3}})?((.*?)(\n*)(.*?))\.{{3}}) -->
                        <xsl:analyze-string select="$after_locus"
                            regex="\.{{3}}(.*?)(\n*)(.*?)\.{{3}}">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(0))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="matches($after_locus, '»')">
                    <xsl:element name='explicit'>
                        <!-- Regex qui prend en compte toutes les possibilités observées : (([0-9|v°|A-Z]+\.\s*)?\.{{3}}(.*?)(\n*)(.*?)(\.|\.{{3}}))» -->
                        <xsl:analyze-string select="." regex="((\.{{3}})?(.*?)(\n*)(.*?)\.)»">
                            <xsl:matching-substring>
                                <xsl:value-of select="normalize-space(regex-group(1))"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="note">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>