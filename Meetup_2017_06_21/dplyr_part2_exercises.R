#########################################################################################
## TELEPITES
## 
## Az alabbi csomagot kell telepiteni es betolteni: tidyverse, maps 
#########################################################################################

## 1.1 Csomag betoltese
library(tidyverse)

adat <- read.csv("pisa_hun_small.csv")
head(adat)

#########################################################################################
## SZURESEK
#########################################################################################

#########################################################################################
## Feladat: Az rendben van, hogy iskolatipusonkent vannak kulonbsegek mondjuk
## a matematika pontszamokban, de
## vannak-e kulonbsegek a legjobbaknal is?
#########################################################################################

## 2.1 Szurjuk le a 10 legtobb pontot elero hallgatot minden iskolara
## es szamoljuk ki az atlagos matematika pontszamukat!





## 2.2 Miert torzitott ez kicsit? Hany hallgatonk is van az egyes iskolakbol?




## 2.3 Mi van akkor, ha inkabb a top 5% hallgatot atlagoljuk iskolatipusonkent?




#########################################################################################
## HOSSZUBOL SZELESBE!
#########################################################################################

#########################################################################################
## Feladat: Keszitsunk QQ plotot a matematika pontszamokbol!
#########################################################################################

## 3.1 Keszitsunk egy uj oszlopot, ami minden hallgatora megmondja,
## hogy a sajat iskolajanak eloszlasaban hol helyezkedik el
## a matematika pontszama alapjan!







## 3.2 Transzformaljuk ugy szeles adatszerkezetube a mostani data frame-et, hogy az
## tartalmazza minden szegmenshez az atlagos matematika pontszamat a 
## hozza tartozo tanuloknak (iskolatipus szerint)!



## 3.3 Rajzoljuk ki mondjuk a 4 es 8 osztalyos gimnazistak pontszamait!



#########################################################################################
## JOINOK, MERGE-OK
#########################################################################################

#########################################################################################
## Feladat: Nezzuk meg, vajon a magyar eredmenyek mennyiben ternek el mas orszagok
## eredmenyeitol!
#########################################################################################

## 4.1 Olvassuk be a mintavetelezett, osszes orszagot tartalmazo allomanyt
## (pisa_small.csv)!

## setwd(?)
orszagok <- read.csv("pisa_small.csv")

## 4.2 Szamoljuk ki minden orszagra az atlagos matematika pontszamot!




## 4.3 Toltsuk be a maps csomagot es keszitsunk egz world_data valtozot,
## amiben egy vilagterkep koordinatait talaljuk!

library(maps)
world_map <- map_data("world")
head(world_map)  

## 4.4 Rajzoljunk ki ebbol egy terkepet!

ggplot(world_map) +
  geom_polygon(aes(x = long, y = lat, group = group))

## 4.5 Joinoljuk (merge-oljuk) ezt a terkep adatsort a mi sajat keszitesu
## atlagos pontszamot tartalmazo adatsorunkkal!



## 4.5 Rajzoljuk ki meg egyszer a terkepet ugy, hogy az egyes orszagok
## az atlagos pontszam szerint legyenek szinezve!




## 4.6 Zoomoljunk ra Europa kornyekere! 
## ggplot2 cheat sheet: https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf





## 4.7 Britannia peldaul tok ures. Valamit elrontottunk a joinnal?
## Ellenorizzuk le, milyen orszagokra nem talaltunk adatot a szineknel!




## Onallo feladat: rajzoljunk terkepet, amely megmutatja, hogy a nok es ferfiak
## atlagos pontszamai kozott mennyi a kulonbseg! Hasznaljuk a scale_fill_gradient2() fuggvenyt,
## megpedig ugy, hogy pirosak jeloljek,
## ahol a noke magasabb
## es keken, ahol a ferfiake, a "semleges" orszagok legyenek feherek!

## 5.1 Keszitsunk egy adatszerkezetet, amiben minden orszagban kulon a ferfiakra
## es nokre van gegy atlagunk



## 5.2 Keszitsunk egy olyan szeles adatszerkezetet, ahol a ferfiak es a nok kulon oszlopban
## jelennek meg!




## 5.3 Keszitsunk egy uj oszlopot a kulonbsegekre!



## 5.4 Joinoljuk ossze a world_map adatsorunkkal! Ugyeljunk a helyes join tipusra!




## 5.5 Rajzoljuk ki a kulonbsegekkel szinezett terkepet!





