#################################################################################
## Work hard, play hard -- Kik és mennyit tanulnak otthon
## es számít-e ez egyáltalán a tesztírásnál?
#################################################################################


#################################################################################
## 1. Előkészületek
#################################################################################

## A tidyverse csomagokra valószínűleg szükségetek lesz.
library(tidyverse)

## Még mindig a legutóbbi alkalmunkon megismert PISA adatsorral dolgozunk.
## Esetleg szükség lehet egy working directory beállításra is (setwd() függvény).
adat <- read.csv("pisa_hun_small.csv")
head(adat)

#################################################################################
## 1. feladat: Van-e különbség a lányok és a fiúk otthon tanulási szokásaiban?
#################################################################################

#################################################################################
## 1.1. feladat: Készítsünk egy új oszlopot az eredeti adatsorban, amiben
## eltároljuk az otthon összesen (matematika, nyelv, természettudományok) 
## eltöltött időt.
## 1 pont
#################################################################################

#################################################################################
## 1.2. feladat: Milyen a nemek aránya a 20 otthon legtöbbet tanuló diák között?
## Ők mennyit időt töltenek otthon tanulással?
## 3 pont
#################################################################################

#################################################################################
## 1.3. feladat: Rajzoljunk boxplotot arról, hogy az egyes nem tagjai hány órát
## töltenek otthoni gyakorlással (össesen)!
## 2 pont
#################################################################################

#################################################################################
## 1.4. feladat: Az ábra azt sugallja, hogy mediánban nincs nagy különbség,
## a 75. percentilisben viszont igen. Számoljuk ki mindkét nemre ezt a két értéket,
## például a quantile() függvény segítségével!
## 3 pont
#################################################################################

#################################################################################
## 2. feladat: Vajon az egyes tárgyakból másképpen gyakorolnak otthon?
#################################################################################

#################################################################################
## 2.1. feladat: Transzformáljuk egyetlen változóba (hosszú szerkezetben) 
## az otthoni gyakorlást jelző változókat (Oraszam*)!
## 2 pont
#################################################################################

#################################################################################
## 2.1. feladat: Rajzoljuk át a fenti boxplotot úgy, hogy az összes tárgy
## külön-külön megjelenjen! Különbözik-e például a nyelvi gyakorlással eltöltött
## órák száma a matematikáétól?
## 2 pont
#################################################################################

#################################################################################
## 3. feladat: Vajon mennyit számít a gyakorlás?
#################################################################################

#################################################################################
## 3.1. feladat: Készítsünk egy új változót OraszamKategoria néven,
## ami az otthon nyelvgyakorlással
## töltött órák 2-es alapú logaritmusának az alsó egész részét tárolja majd!
## Esetleg nézzük meg a log2() és a floor() függvényeket!
## 3 pont
#################################################################################

#################################################################################
## 3.1. feladat: Rajzoljunk boxplotot a szövegértés pontszámokból a nemekre
## és a gyakorlással töltött órákra szeparáltan (például színezzünk a nemek
## szerint és faceteljünk a fönti változó mentén)!
## 3 pont
#################################################################################



