library(data.table)

## ha szükséges, installáld a nycflights13 package-t a következő paranccsal:
## install.packages("nycflights13")
library(nycflights13)

# Konvertáld át a flights dataframe-et data.table formába
data <- data.table(flights)

# Az adat repülőjáratokról szól. Minden gépnek adott az indulási 
# és az érkezési helye, ideje, a gép típusa, stb.
# Bővebb információ: https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf
# Ismerkedj meg az adattal! Ehhez az első két sort beírtam, de bártan 
# használhatsz más függvényeket, vagy akár a ggplot2-t is!

dim(data)
names(data)

## Jöjjenek a feladatok.
## A helyes megoldásokhoz többféle úton is el lehet jutni!
## A segítségek részekben egy megoldáshoz adok ötleteket, de ha te máshogy jutsz
## ugyanarra az eredményre, az is tökéletes.
## A feladatok után lesz egy segítség rész, ahol összírtam, milyen lépésekben
## érdemes nekiállni a megoldásnak. Ez segíthet akkor is, ha nem egyértelmű
## mit kell pontosan csinálni.
## A segítségek után pedig az eredményeket is bemutatom, melynek segítségével 
## leellenőrizheted, hogy az eredményül kapott adatod megegyezik-e
## a várt megoldással. 

## A megoldások (ez az .R állomány kiegészítve a kódokkal) május 16-a 
## éjfélig el is küldhetők a windhager.p.e@gmail.com címre, egyrészt így 
## kaphattok a munkátokról közvetlen visszajelzést, másrészt
## a helyes megoldást beküldők dicsőségük teljesen fényében 
## egy vállveregetésben részesülnek majd. :)
## Nekünk nagyon hasznos lenne, hogy lássuk, ki meddig tudott eljutni 
## az önálló munkában, mert ezek alapján finomhangolhatjuk a következő 
## workshop anyagát, kicsit képet kaphatnánk arról, kinek mi megy vagy 
## mik okoztak általánosan nehézséget.
## Természetesen megoldásokat a következő meetup-on megbeszéljük.

##################################
##        FELADATOK             ##
##################################

#####################################################
## 1. Feladat
## A késés az indulásnál természetesen befolyásolja a késést az érkezésnél is. 
## Keressük meg a leghosszabb "levegőben" keletkezett késést! 
## Azaz az érkezéskori késésből vonjuk ki az induláskori késés idejét
## és ennek az értéknek keressük meg a maximumát!

#####################################################
## 2. Feladat
## Rendezd a kiinduló állomás - célállomás párokat csökkenő népszerűségi
## sorrendbe. Csak a ténylegesen elindult járatokat vedd figyelembe!

#####################################################
## 3. Feladat
## Jelenítsd meg azokat a járatokat, amelyek a kiinduló és célállomásuk közötti
## átlagos repülési időnek (air_time) több mint másfélszeresét töltötték a levegőben! 
## Az így kapott sorokat rendezd arr_delay szerint csökkenő sorrendbe!

##################################
##        SEGÍTSÉGEK            ##
##################################

#------------------------------------
# Segítség az 1. Feladathoz:
# 1. hozz létre egy új változót, amelybe az arr_delay és a dep_delay különbsége kerül
# 2. számítsd ki ennek az új változónak a maximumát (használd a chaining-et)
# 3. ne felejtsd el a hiányzó értékek kezelését

#------------------------------------
# Segítség a 2. Feladathoz:
# 1. szűrd le az adatot a ténylegesen felszállt járatokra (pl air_time>0)
# 2. csoportosítsd az adatot az origin és dest szerint 
# 3. és számítsd ki az egyes csoportokban előforduló sorok számát
# 4. rendezd az eredményt csökkenő sorrendbe a csoportok mérete szerint

#------------------------------------
# Segítség a 3. Feladathoz:
# 1. csoportosítsd az adatot az origin és dest szerint 
# 2. és számítsd ki az átlagos air_time értéket
# 3. ne felejtsd el a hiányzó értékeket kezelni
# 4. az eddigiek egy új oszlopba kerüljenek az eredeti data.table-ben
# 5. szűrd le azokat a sorokat, ahol az air_time nagyobb  mint az előbb létrehozott átlag szorozva 1.5-del
# 6. rendezd sorba arr_delay szerint csökkenő sorrendben

##################################
##        EREDMÉNYEK            ##
##################################

#......................
# 1. Feladat Eredmény
# 196

#......................
# 2. Feladat Eredmény
# data.table első 3 sora:
# origin dest     N
# 1:    JFK  LAX 11159
# 2:    LGA  ATL 10041
# 3:    LGA  ORD  8507

#......................
# 3. Feladat Eredmény
# 330 ilyen sor van
# az eredmény data.table első 3 sora:
# origin dest air_time AvgAirTime arr_delay
# 1:    JFK  BOS       67   38.48121       372
# 2:    JFK  SYR       97   44.53406       350
# 3:    LGA  ORD      176  115.79981       335
