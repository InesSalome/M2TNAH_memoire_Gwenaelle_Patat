import re
import docx2txt

notices = docx2txt.process('/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/noticesTestsocr.docx', 'r')


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

for char in structure_notices:
    fichier = open("/Users/gwenaellepatat/Desktop/Stage_TNAH/MémoireHORAE/Catalogue_VL/notice_Leroquais.txt", "a")
    fichier.write('<TEI> Titre : %s \n Content : %s </TEI> \n\n' % (char[0], char[1]))
    fichier.close()
    #print('<TEI> Titre : %s \n Content : %s </TEI> \n\n' % (char[0], char[1]))