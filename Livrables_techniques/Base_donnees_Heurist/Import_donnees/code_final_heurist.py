# coding: utf8

from lxml import etree
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
import untangle
from datetime import datetime
import csv

#Récupération des données depuis le document d'export XML de la base Heurist
exportXML = untangle.parse('/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/BaseHeurist/Import_données/Export_stutzmann_horae_20200424152411.xml')

#Element racine
hml= etree.Element("hml")

#Sous-éléments de la balise hml
database = etree.SubElement(hml, "database")
records = etree.SubElement(hml, "records")

#Sous-élément de la balise records
#Multiplier le nombre de balise record en fonction du nombre de données declaré et ajouté depuis le CSV
with open ("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/BaseHeurist/Données/UseItem_Test_LL.csv") as csvfile:
    donnees_Heurist = csv.reader(csvfile, delimiter=';', quotechar='"')
    #id_record = 599999
    for id_record, row in enumerate(donnees_Heurist, 600000) :
        #id_record += 1
        record = etree.SubElement(records, "record")
        #Sous-éléments de la balise record
        id_node = etree.SubElement(record, "id")
        id_node.text = "H-ID-" + str(id_record)

        type_node = etree.SubElement(record, "type")
        #Valeurs d'attributs de la balise type dépendant de la base Heurist
        type_node.set("conceptID", exportXML.hml.records.record[0].type["conceptID"])
        #Récupération du nom de l'entité dans l'élément type depuis le CSV
        for line in csvfile :
            type_node.text = str(row[1])


with open ("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/BaseHeurist/Données/UseItem_Test_LL.csv") as csvfile:
    donnees_Heurist = csv.reader(csvfile, delimiter=';', quotechar='"')
    #id_record = 599999
    for id_record, row in enumerate(donnees_Heurist, 600000) :

        detail1 = etree.SubElement(record, "detail")
        if type_node.text == "Use" :
            detail1.set("conceptID", "2-1")
            detail1.set("name", "Title")
            detail1.text = str(row[1]) + " (Use) [2]"

            #Difficile de récupérer depuis le document d'export la clé étrangère correspondant à la bonne organisation,
            #car il faudrait pouvoir une condition d'égalité entre le nom de l'usage et celui de l'organisation.

            """
            detail2.set("conceptID", "2-21")
            detail2.set("name", "Organisation")
            detail2.set("isRecordPointer", "True")
            detail2.text = str(exportXML.hml.records.record.id)

            """

# Attribut xmlns : espace de nom vers la page d'accueil de la base Heurist,
#Lien vers le schema hml sur Heurist où sont stockées les données : à faire à la main
#Espace de nom pour le schéma de référence d'XML : à faire à la main
hml.set("xmlns", exportXML.hml["xmlns"])
#hml.set("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
#hml.set("xsi:schemaLocation", exportXML.hml["xsi:schemaLocation"])

#Attribut et texte relatifs à la balise database :
database.text = str(exportXML.hml.database.cdata)
database.set("id", exportXML.hml.database["id"])

#Ajout de l'élément detail autant de fois que l'utilisateur enrichi les informations relatives à l'entité en question : à tester
#for ajout_detail in record :
	#if element.tag == 'detail':
		#detail.append(record)


print(etree.tostring(hml, xml_declaration=True,encoding="UTF-8",pretty_print=True))
tree = ET.ElementTree(hml)
tree.write("ImportUseHeurist.xml".encode('utf8'))