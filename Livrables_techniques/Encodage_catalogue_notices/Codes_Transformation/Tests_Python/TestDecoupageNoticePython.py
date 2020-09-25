import re
import docx2txt
import lxml
import xml.etree.ElementTree as ET

notices = docx2txt.process('/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/noticesTestsocr.docx', 'r')

#paragraphe = re.findall('.*\n.*\n', notices)
#num_notice = re.search('^(([0-9]|I|l)+(-[0-9]+)?)(\.).*([A-Z]{2,3})+', notices)
#titre_notice = re.search('[0-9|I|l]+\.(.*[A-ZÉÈÀÙ]+)\.', notices)
#print(titre_notice.group(1))

#Capture des titres de notices dans l'ordre stockées dans un dictionnaire
livres_heures={}
for char in range(1, 320):
    try:
        titre=re.search(r"\n"+'((l|I){1,2})?'+ str(char) + "\." + '.*?[A-ZÉÈÙÀ]{2,}.*?\n', notices).group(0)
        livres_heures[char]=titre
        #print(titre)
    except: #Exceptions utiles pour détecter les possibles dénominations irrégulières
        #print(char)
        continue
        
#Utilisation des valeurs du dictionnaire, soit les titres de notices, pour diviser le texte et associer le contenu à chaque titre
regexPattern = '|'.join(map(re.escape, livres_heures.values()))
contenu=re.split(regexPattern, notices)
        
        
#Zip de la liste pour créer une liste de tuples contenant les titres et leur contenu
structure_notices = list(zip(livres_heures.values(), contenu[1:]))



#Capture des descriptions matérielles des manuscrits 
for index, char in enumerate(structure_notices) :
    try:
        physDesc=re.search(r"(Pareil\.|Parch\.){1}((.*?)\n)*(Rel\.|Rcl\.|Demi\-reliure){1}(.*?)\.( —)?", char[1]).group(0)  # char[1] est le contenu dans notre tuple
        #print(physDesc)
        list(structure_notices[index]).append(physDesc)  #Modification de la liste principale
        print(structure_notices)
    except :
        print(index)
        continue
        
#Capture de la bibliographie
for index, char in enumerate(structure_notices):
    try:
        additional=re.search('(Rel\.|Rcl\.|Demi\-reliure){1}(.*?)\.\s+\—\s+([A-ZÉÈÀÙ]{1,}.*)\n', char[1]).group(3)  # char[1] est le contenu dans notre tuple
        structure_notices[index].append(additional)#Modification de la liste principale
        #print(additional)
    except :
        print(index)
        continue
        
#Capture de l'historique du manuscrit : Regex avec faible risque d'erreurs
for index, char in enumerate(structure_notices):
    try:
        history=re.search(r"(\n.*?(usage|possesseur)+.*" + '(\n*.*)[r"^Pareil\.|Parch\.|Rel\.|Rcl\.|Demi\-reliure"](.*?))' + "(Pareil\.|Parch\.|Rel\.|Rcl\.|Demi\-reliure)?", char[1]).group(1)  # char[1] est le contenu dans notre tuple
        structure_notices[index].append(history)#Modification de la liste principale
        #print(history)
    except :
        print(index)
        continue 

for char in structure_notices:
    fichier = open("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/Transformation_Python/delimitation_notice_Leroquais.txt", "a")
    fichier.write('<TEI> Titre : %s \n Content : %s </TEI> \n\n' % (char[0], char[1]))
    fichier.close()
    #print('<TEI> Titre : %s \n Content : %s </TEI> \n\n' % (char[0], char[1]))

for char in structure_notices:
    fichier = open("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/Transformation_Python/DescriptionMaterielle_notice_Leroquais.txt", "a")
    fichier.write(str(physDesc))
    fichier.close()
    
for char in structure_notices:
    fichier = open("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/Transformation_Python/Biblio_notice_Leroquais.txt", "a")
    fichier.write(str(additional))
    fichier.close()
    
for char in structure_notices:
    fichier = open("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/Transformation_Python/historique_manuscrits_notice_Leroquais.txt", "a")
    fichier.write(str(history))
    fichier.close()
