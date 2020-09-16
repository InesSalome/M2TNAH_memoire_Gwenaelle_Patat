import re
import docx2txt

notices = docx2txt.process('/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/noticesTestsocr.docx', 'r')
manuscrits=str(re.split(r'(\W+)', notices))

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

#for char in structure_notices:
    #print('Titre : %s \n Contenu : %s \n\n' % (char[0], char[1]))
          
"""
#Capture des résumés du contenu des manuscrits : Regex fausse
for index, char in enumerate(structure_notices) :
    #try:
        msContents=re.search(r"(^Bibliothèque nationale,){1}.*?\n+" + '(.*?\n.*?\n)+' + r"(^Pareil\.{1}|^Parch\.{1})", char[1]).group(0)  # char[1] est le contenu dans notre tuple
        print(msContents)
        #structure_notices[index].append(msContents)  #Modification de la liste principale
    #except :
        #print(index)
        #continue
"""


#Capture des descriptions matérielles des manuscrits 
for index, char in enumerate(structure_notices):
    try:
        physDesc=re.search(r"(Pareil\.|Parch\.){1}((.*?)\n)*(Rel\.|Rcl\.|Demi\-reliure){1}(.*?)\.( —)?", char[1]).group(0)  # char[1] est le contenu dans notre tuple
        structure_notices[index].append(physDesc)  #Modification de la liste principale
        #print(physDesc)
    except :
        #print(index)
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
        structure_notices[index].append(additional)#Modification de la liste principale
        #print(history)
    except :
        print(index)
        continue 