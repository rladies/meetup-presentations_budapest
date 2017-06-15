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

top10 <- adat %>% 
  group_by(IskolaTipusa) %>%
  top_n(10, PontMat) %>%
  summarise(avg_top10 = mean(PontMat))

## 2.2 Miert torzitott ez kicsit? Hany hallgatonk is van az egyes iskolakbol?
table(adat$IskolaTipusa)

## 2.3 Mi van akkor, ha inkabb a top 5% hallgatot atlagoljuk iskolatipusonkent?
top10 <- adat %>% 
  group_by(IskolaTipusa) %>%
  mutate(pr = percent_rank(PontMat)) %>%
  filter(pr >= 0.9) %>%
  summarize(avg_top10pr = mean(PontMat))

#########################################################################################
## HOSSZUBOL SZELESBE!
#########################################################################################

#########################################################################################
## Feladat: Keszitsunk QQ plotot a matematika pontszamokbol!
#########################################################################################

## 3.1 Keszitsunk egy uj oszlopot, ami minden hallgatora megmondja,
## hogy a sajat iskolajanak eloszlasaban hol helyezkedik el
## a matematika pontszama alapjan!

eloszlasok <- adat %>%
  group_by(IskolaTipusa) %>%
  mutate(szegmens = ntile(PontMat, 100)) %>%
  ungroup(IskolaTipusa)

unique(eloszlasok$szegmens)

## 3.2 Transzformaljuk ugy szeles adatszerkezetube a mostani data frame-et, hogy az
## tartalmazza minden szegmenshez az atlagos matematika pontszamat a 
## hozza tartozo tanuloknak (iskolatipus szerint)!

eloszlasok <- eloszlasok %>%
  group_by(IskolaTipusa, szegmens) %>%
  summarise(atlagPontSzegmensenkent = mean(PontMat)) %>%
  ungroup(IskolaTipusa, szegmens)

szeles <- spread(eloszlasok, IskolaTipusa, atlagPontSzegmensenkent)

## 3.3 Rajzoljuk ki mondjuk a 4 es 8 osztalyos gimnazistak pontszamait!

ggplot(szeles) +
  geom_point(aes(x = Gimn4Osztalyos, y = Gimn8Osztalyos))

#########################################################################################
## JOINOK, MERGE-OK
#########################################################################################

#########################################################################################
## Feladat: Nezzuk meg, vajon a magyar eredmenyek mennyiben ternek el mas orszagok
## eredmenyeitol!
#########################################################################################

## 4.1 Olvassuk be a mintavetelezett, osszes orszagot tartalmazo allomanyt
## (pisa_small.csv)!
orszagok <- read.csv("pisa_small.csv")

## 4.2 Szamoljuk ki minden orszagra az atlagos matematika pontszamot!
orszag_atlag <- orszagok %>%
  group_by(Orszag) %>%
  summarize(atlag = mean(PontMat)) %>%
  ungroup(Orszag)

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
world_map_colored <- left_join(world_map,
                               y = orszag_atlag,
                               by = c("region" = "Orszag"))

## 4.5 Rajzoljuk ki meg egyszer a terkepet ugy, hogy az egyes orszagok
## az atlagos pontszam szerint legyenek szinezve!
ggplot(world_map_colored) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = atlag)) +
  scale_fill_gradient(low = "grey", high = "darkgreen")

## 4.6 Zoomoljunk ra Europa kornyekere! 
## ggplot2 cheat sheet: https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf

ggplot(world_map_colored) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = atlag)) +
  coord_cartesian(xlim = c(-25, 50), ylim= c(25, 75)) +
  scale_fill_gradient(low = "grey", high = "darkgreen")

## 4.7 Britannia peldaul tok ures. Valamit elrontottunk a joinnal?
## Ellenorizzuk le, milyen orszagokra nem talaltunk adatot a szineknel!
sort(setdiff(world_map$region, orszag_atlag$Orszag))
sort(setdiff(orszag_atlag$Orszag, world_map$region))

## Onallo feladat: rajzoljunk terkepet, amely megmutatja, hogy a nok es ferfiak
## atlagos pontszamai kozott mennyi a kulonbseg! Hasznaljuk a scale_fill_gradient2() fuggvenyt,
## megpedig ugy, hogy pirosak jeloljek,
## ahol a noke magasabb
## es keken, ahol a ferfiake, a "semleges" orszagok legyenek feherek!

## 5.1 Keszitsunk egy adatszerkezetet, amiben minden orszagban kulon a ferfiakra
## es nokre van gegy atlagunk
orszag_atlag_fn <- orszagok %>%
  group_by(Orszag, Nem) %>%
  summarize(atlag = mean(PontMat)) %>%
  ungroup(Orszag, Nem)

## 5.2 Keszitsunk egy olyan szeles adatszerkezetet, ahol a ferfiak es a nok kulon oszlopban
## jelennek meg!
orszag_atlag_fn_szeles <- spread(orszag_atlag_fn, Nem, atlag)

## 5.3 Keszitsunk egy uj oszlopot a kulonbsegekre!
orszag_atlag_fn_szeles <- orszag_atlag_fn_szeles %>%
  mutate(kul = No - Ferfi)

## 5.4 Joinoljuk ossze a world_map adatsorunkkal! Ugyeljunk a helyes join tipusra!
world_map_colored <- left_join(world_map,
                               y = orszag_atlag_fn_szeles,
                               by = c("region" = "Orszag"))

## 5.5 Rajzoljuk ki a kulonbsegekkel szinezett terkepet!
ggplot(world_map_colored) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = kul)) +
  coord_cartesian(xlim = c(-25, 50), ylim= c(25, 75)) +
  scale_fill_gradient2(low = "darkblue", mid = "white", high = "darkred")
