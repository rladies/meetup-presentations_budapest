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

adat <- adat %>%
  mutate(OrszamOssz = OraszamOtthonMat + OraszamOtthonTermTud +
           OraszamOtthonNyelv)

#################################################################################
## 1.2. feladat: Milyen a nemek aránya a 20 otthon legtöbbet tanuló diák között?
## Ők mennyit időt töltenek otthon tanulással?
## 3 pont
#################################################################################

adat %>%
  arrange(-OrszamOssz) %>%
  slice(1:20) %>%
  select(Nem, OrszamOssz)

#################################################################################
## 1.3. feladat: Rajzoljunk boxplotot arról, hogy az egyes nem tagjai hány órát
## töltenek otthoni gyakorlással (össesen)!
## 2 pont
#################################################################################

ggplot(adat) +
  geom_boxplot(aes(x = Nem, y = OrszamOssz))

#################################################################################
## 1.4. feladat: Az ábra azt sugallja, hogy mediánban nincs nagy különbség,
## a 75. percentilisben viszont igen. Számoljuk ki mindkét nemre ezt a két értéket,
## például a quantile() függvény segítségével!
## 3 pont
#################################################################################

adat %>%
  group_by(Nem) %>%
  summarize(median = median(OrszamOssz, na.rm = T),
            percentile75 = quantile(OrszamOssz, 0.75, na.rm = T))

#################################################################################
## 2. feladat: Vajon az egyes tárgyakból másképpen gyakorolnak otthon?
#################################################################################

#################################################################################
## 2.1. feladat: Transzformáljuk egyetlen változóba (hosszú szerkezetben) 
## az otthoni gyakorlást jelző változókat (Oraszam*)!
## 2 pont
#################################################################################

adat_hosszu <- gather(adat, Targy, Oraszam, 7:9)

#################################################################################
## 2.1. feladat: Rajzoljuk át a fenti boxplotot úgy, hogy az összes tárgy
## külön-külön megjelenjen! Különbözik-e például a nyelvi gyakorlással eltöltött
## órák száma a matematikáétól?
## 2 pont
#################################################################################

ggplot(adat_hosszu) +
  geom_boxplot(aes(x = Nem, y = Oraszam)) +
  facet_wrap(~Targy)

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

adat <- adat %>%
  mutate(Oraszam2 = floor(log2(OraszamOtthonNyelv)))

#################################################################################
## 3.1. feladat: Rajzoljunk boxplotot a szövegértés pontszámokból a nemekre
## és a gyakorlással töltött órákra szeparáltan (például színezzünk a nemek
## szerint és faceteljünk a fönti változó mentén)!
## 3 pont
#################################################################################

ggplot(adat) +
  geom_boxplot(aes(x = Nem, y = PontSzovegertes)) +
  facet_wrap(~ Oraszam2)







