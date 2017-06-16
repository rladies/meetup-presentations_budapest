library(data.table)
library(nycflights13)

# Konvertáld át a flights és a weather dataframe-eket data.table formába
data_flights <- data.table(flights)
data_weather <- data.table(weather)

# Az flights adat repülőjáratokról szól. Minden gépnek adott az indulási 
# és az érkezési helye, ideje, a gép típusa, stb.
# A weather adat időjárási információkat tartalmaz a 3 reptérhez, óránkénti bontásban
# Bővebb információ: https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf
# Ismerkedj meg az adattal!

dim(data_flights)
names(data_flights)

dim(data_weather)
names(data_weather)

## Jöjjenek a feladatok.
## A helyes megoldásokhoz többféle úton is el lehet jutni, de kérem, hogy 
## a megoldásban a data.table függvényeket használjátok!
## A feladatok után lesz egy segítség rész, ahol összírtam, milyen lépésekben
## érdemes nekiállni a megoldásnak. Ez segíthet akkor is, ha nem sikerült egyértelműen
## leírnom mit kell pontosan csinálni.
## A segítségek után pedig az eredményeket is bemutatom, így 
## leellenőrizheted, hogy az eredményül kapott adatod megegyezik-e
## a várt megoldással. 

## A megoldások (ez az .R állomány kiegészítve a kódokkal) június 20-a 
## éjfélig el is küldhetők a windhager.p.e@gmail.com címre, egyrészt így 
## kaphattok a munkátokról közvetlen visszajelzést, másrészt
## a helyes megoldást beküldők dicsőségük teljesen fényében 
## egy vállveregetésben részesülnek majd. :)
## Természetesen részmegoldást is beküldhettek. Tehát ha csak az 1A,1B és a 2A
## feladatokig jutottál (akár időhiány, akár a feladatok nehézsége miatt)
## akkor is küldd be a megoldásodat! A részeredményeket is értékeljük.
## Illetve ha elakadtál és segítségre van szükséged, küldj e-mailt és segítek!
##
## Nekünk nagyon hasznos lenne, hogy lássuk, ki meddig tudott eljutni 
## az önálló munkában, mert ezek alapján finomhangolhatjuk a következő 
## workshop anyagát, kicsit képet kaphatnánk arról, kinek mi megy vagy 
## mik okoztak általánosan nehézséget.
## A megoldásokat igény esetén a következő meetup-on megbeszéljük.

##################################
##        FELADATOK             ##
##################################

## Ebben a házi feladatban arra a kérdésre keressük a választ, hogy a repülőjáratok
## felszállásának késése és törlése milyen kapcsolatban áll az időjárási 
## körülményekkel

#####################################################
## 1. Feladat
## Készítsük elő a táblákat a további elemzéshez!
## 
## A) A data_flights data.table előkészítése
## A data_flights data.table-ben hozzunk létre egy új változót "indulas" névvel az alábbi
## értékekkel:
## indulas = "torolt", ha arr_time hiányzik (azaz nem szállt le a gép)
## indulas = "keses", ha dep_delay > 10
## indulas = "idoben" minden más esetben
## Tartsuk meg a táblában az origin, time_hour, indulas oszlopokat a többi oszlopra 
## nem lesz a továbbiakban szükségünk
##
## B) A data_weather data.table előkészítése
## A data_weather data.table-ben hozzunk létre egy új változót "csapadek" névvel az alábbi
## értékekkel:
## csapadek = "nincs_csapadek", ha precip=0
## csapadek = "keves_csapadek", ha precip>0 és precip<0.2
## csapadek = "sok_csapadek" , ha preci>=0.2
## Végül válasszuk ki az origin, time_hour, csapadek oszlopokat a többi oszlopra nem lesz
## a továbbiakban szükségünk

#####################################################
## 2. Feladat
##
## A) Kapcsoljuk össze a két táblát az origin és a time_hour alapján. Mivel a time_hour
## mindkét tábla esetén órákra kerekített értéket tartalmaz, ezért a "sima" join működik
## nincs szükség rolling join használatára.
## Ha az összekapcsolás sikeres volt, akkor most egy táblában látjuk a járatok indításának
## státuszát (időben, késés, törölt) illetve a csapadék kategóriákat.
## Az időjárás táblázatból néhány óra hiányzik (pl. LGA origin esetén a 2013-12-31 0 óra 
## kivételével minden más óra), így az összekapcsolt tábla sorainak száma 
## valamivel kevesebb lesz, mint a data_flights sorainak száma.
##
## B) Vannak olyan órák, amelyekben nem volt tervezve repülőjárat indulás. 
## Ezeket az adatokat szűrjük ki az összekapcsolt táblából! (pl !is.na(indulas) 
## kifejezés használatával)
## Az eredményt mentsük el egy flights_with_weather nevű data.table-be!

#####################################################
## 3. Feladat
##
## A) Egy count változó és a dcast segítségével számoljuk össze hogy az egyes csapadék 
## kategóriák fennállása esetén hány járat indult időben, késéssel illetve került törlésre!
## A csapadék kategóriák legyenek a sorokban, az indulás státuszát jelző kategóriák
## pedig az oszlopokban.
##
## B) Egy új oszlopban adjuk össze a csapadék kategóriánként tervezett járatok számát
## majd ezen oszlop segítségével számoljuk ki, hogy az egyes kategóriákon belül
## a járatok hány százaléka késett, illetve került törlésre.

#####################################################
## + Bónusz Feladat
##
## Ha a fentieket sikerült végigvinni, megnézheted, hogy a szélerősség milyen hatással van
## a járatok késésére és törlésére.
## Ehhez a fenti műveleteket kell újra végigcsinálnod, de csapadék helyett a 
## szélerősség vizsgálatával.
## Ehhez az alábbi kategóriákat javasolom:
## szel = "nincs_szel", ha wind_speed<7
## szel = "gyenge_szel", ha wind_speed>=7 és wind_speed<12
## szel = "eros_szel", ha wind_speed>=12
##
## Bónusz kérdés:
## Melyik időjárási körülmény befolyásolja erősebben a felszállást, a csapadék vagy a szél?

##################################
##        SEGÍTSÉGEK            ##
##################################

#------------------------------------
# Segítség az 1. Feladathoz:
# Az új változó mindkét tábla esetén 3 különböző értéket vesz fel, 3 különböző 
# feltétel esetén.
# Legegyszerűbb megoldás, ha a feltétel résszel leszűröd a megfelelő sorokat
# majd itt megadod az új változó értékét. Ilyen formában:
# data[feltétel, új_változó := érték]
# A fentieket 3x megismételve a 3 különböző szűrési feltétellel és a megfelelő értékkel
# előáll az új változó minden sorra
# Végül ne felejtsd el leválogatni a megadott oszlopokat!

#------------------------------------
# Segítség a 2. Feladathoz:
# 1. kulcsok beállítása a data_flights data.table-ra
# 2. data_flights és data_weather összekapocsolása
# 3. !is.na(indulas) feltétellel kidobjuk azokat az időpontokat, amelyekhez nem tartozott
# tervezett repülőjárat indulás

#------------------------------------
# Segítség a 3. Feladathoz:
# 1. Hozz létre az összekapcsolt táblában egy új oszlopot csupa 1-es értékkel feltöltve
# 2. dcast függvény használatával készíts egy "széles" formátumú táblát az 
# indulási kategóriákról, ahol a sorokban a csapadék kategóriák állnak
# 3. Ebben az új "széles" táblában hozz létre egy új változót, amely az
# idoben, keses, torolt oszlopok összegéből áll
# 4. Az összeg oszlop segítségével számold ki a törölt járatok arányát illetve 
# a késő járatok arányát

##################################
##        EREDMÉNYEK            ##
##################################

#......................
# 1. Feladat Eredmény
#
# data_flights első 3 sora
#     origin           time_hour indulas
# 1:    EWR 2013-01-01 05:00:00  idoben
# 2:    LGA 2013-01-01 05:00:00  idoben
# 3:    JFK 2013-01-01 05:00:00  idoben
# ...
#
# data_weather első 3 sora
#   origin           time_hour       csapadek
# 1:    EWR 2013-01-01 01:00:00 nincs_csapadek
# 2:    EWR 2013-01-01 02:00:00 nincs_csapadek
# 3:    EWR 2013-01-01 03:00:00 nincs_csapadek

#......................
# 2. Feladat Eredmény
#
# Az összekapcsolt és leszűrt táblának 335577 sora van
# Első 3 sora:
#   origin           time_hour indulas       csapadek
# 1:    EWR 2013-01-01 07:00:00  idoben nincs_csapadek
# 2:    EWR 2013-01-01 07:00:00  idoben nincs_csapadek
# 3:    EWR 2013-01-01 07:00:00  idoben nincs_csapadek

#......................
# 3. Feladat Eredmény
#
#         csapadek idoben keses torolt  total torolt_arany keses_arany
# 1: keves_csapadek   9635  7612   1795  19042     9.426531    39.97479
# 2: nincs_csapadek 234679 74739   6582 316000     2.082911    23.65158
# 3:   sok_csapadek    258   228     49    535     9.158879    42.61682
