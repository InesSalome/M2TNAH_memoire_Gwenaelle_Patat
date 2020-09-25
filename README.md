# M2TNAH_memoire_Gwenaelle_Patat

Vous trouverez dans ce dossier le mémoire et les livrables techniques liés au stage réalisé dans le cadre du master TNAH de l'École des Chartes (promotion 2020). Le mémoire _L’étude des livres d’heures à la lumière du numérique. Le cycle de vie des données et des métadonnées – Analyser, Modéliser, Structurer, Visualiser_ découle d'un stage effectué à l'IRHT d'avril à juillet 2020 autour du projet _HORAE. Hours - Recognition, Analysis, Editions_ piloté par Dominique Stutzmann. 

À la racine du dossier se trouvent le mémoire compilé avec LaTeX au format PDF, dont l'une des versions est compressée, ainsi qu'au format .tex, avec une bibliographie au format .bib et un dossier d'images ayant servi à l'illustration du mémoire. 

Le dossier ``` Livrables_techniques ``` contient les dossiers suivants : 

* ``` Definition_ODD_msDesc ```, soit les travaux relatifs à la définition d'un schéma d'encodage de notices de manuscrits le plus normalisé et le plus interopérable possible. On trouve dans ce dossier : 

    * Le fichier ``` ODDCatalogueEcmen.xml ```, soit le résultat du processus _oddbyexample_ à partir du catalogue de manuscrits répertoriés dans le cadre du projet ECMEN. Des contraintes ont été ajoutées au schéma à partir du module _msdescription_ l.134.
    * Le fichier ``` ODDCatalogueEcmen.rng ``` dans un dossier ``` out ```, généré à partir du fichier ``` ODDCatalogueEcmen.xml ```. On peut ainsi associé le schéma en relaxNG au document XML-TEI souhaité et contenant une description de manuscrits.

* ``` Encodage_catalogue_notices ```, avec les documents sources, les documents de réflexion, de transformation et de résultat d'un encodage semi-automatisé d'un catalogue de notices de livres d'heures établi par Victor Leroquais. On y trouve :

    * À la racine la première version de l'arbre de décision (``` ArbreDecisionNoticesLeroquais.pdf ```) et la deuxième (``` ArbreDecisionStructureNotices.pdf ```), ainsi que le modèle de structuration des notices choisi pour l'encodage, dans le respect de l'ODD définie auparavant (``` Modele_notices_VL.xml ```).
    * Dans le dossier ``` Documents_sources``` les documents servant de base à la transformation, soit les notices de Victor Leroquais océrisées (``` Les_livres_d'heures_manuscrits_de_[...]Leroquais_Victor_bpt6k15129612_notices_tout.docx ```) ; les notices océrisées auxquelles des styles ont été associés sous le logiciel Word (``` Structuration_styles_notices_Leroquais.docx ```) ; le résultat des notices océrisées au format .xml après conversion via OxGarage (``` Structuration_notices_Leroquais.xml ```) ; le résultat des notices océrisées après fusion des paragraphes éclatés pour mieux récupérer les informations ensuite (``` StructurationNoticesFusionsParagraphe.xml ```). Ce dernier document est celui qui a été transformé par les codes XSLT.
    * Dans le dossier ``` Codes_Transformation ``` le code XSLT encodant l'ensemble des informations sauf les rubriques (``` Match_tout_sauf_Rubric.xsl ```), celui encodant uniquement les rubriques (``` matchRubric.xsl ```), la requête XQuery fusionnant les documents de sortie des deux codes XSLT (``` requete.xq ```). Dans ce dossier se trouve aussi le dossier ``` Tests_Python ``` dans lequel on peut voir des codes de capture des informations présentes dans les notices à l'aide de regex (``` TestRegexNoticePython.py ``` ou ``` TestRegexNoticePython.ipynb ```) ; des codes pour délimiter les notices et les regrouper dans un tuple (``` TestDecoupageNoticePython.ipynb ``` ou ``` TestDecoupageNoticePython.py ```) ; des codes pour ajouter les balises souhaitées autour des informations capturées(``` TestEncodageNoticeTEIPython.py ```). Les fichiers .txt représentent les résultats de ces différentes opérations.
    * Dans le dossier ```Documents_sorties```le fichier final de la transformation dont les deux tiers ont pu être repris à la main lors du stage (``` Leroquais_Heures_notices_TEI.xml ```).
    * Dans le dossier ``` Document_de_passation ``` le fichier ``` Récapitulatif_reprise_Leroquais.docx ``` qui signale les dernières étapes pour la reprise manuelle du fichier encodé.

* ``` CSS/Framework_Oxygen ```, dans lequel on trouve un fichier .css et des captures d'écran de modifications d'actions dans le framework du logiciel Oxygen XML Editor, afin de répondre à des enjeux d'ergonomie dans la saisie de notices bibliographiques en mode auteur.

* ``` Base_donnees_Heurist ```, soit les documents relatifs à la modélisation et à l'import des données dans la base de données relationnelle de la plateforme Huma_Num Heurist. On y trouve deux dossiers :

    * ``` Import_donnees ``` avec le template XML contenant des exemples de données qui instancient les entités _Use_, _useItem_ et leurs relations d'imbrication et de succession, ainsi que le code python ``` code_final_heurist.py ``` pour l'import des données en XML.
    * ```Modelisation```, avec un premier modèle conceptuel (``` MODÉLISATION1.pdf ```), un deuxième modèle conceptuel inspiré des standards RDF et FRBR (``` Modelisation_RDF_FRBR.pdf ```), un modèle relationnel, aussi dit logique, inspiré de la première modélisation (``` MRD_Usages.mwb ```et ``` MRD_Usages.png ```), les différents tests d'implémentation des usages (``` UseTest1.png ``` à ``` UseTest4.png```), et les choix finaux pour l'import des entités _Use_ et _Work_ (``` choix_final_use.png ``` et ``` choix_final_work.png ```).

* ``` Alignement_Psaumes_Transkribus ``` contient le texte de référence des Sept Psaumes de la Pénitence à aligner avec Transkribus sur les manuscrits numérisés.

* ``` Annotation_Arkindex ``` avec des exemples d'annotations sur la plateforme Arkindex.

Enfin, la feuille de route témoigne des différentes réflexions menées lors du stage. 
