#########################################################################################
## TELEPITES
## 
## Az alabbi csomagot kell telepiteni es betolteni: tidyverse
## Telepites: Packages -> Install -> tidyverse
## Ez egyszerre 
#########################################################################################

## 1.1 Csomag betoltese
library(tidyverse)


#########################################################################################
## BEOLVASAS
##
## Honnan lett adatunk? http://www.oecd.org/pisa/data/2015database/
## Adattranszformacios szkript: transform.R
## Oszlopnevek magyarazata: http://www.oecd.org/pisa/data/2015database/Codebook_CMB.xlsx
#########################################################################################

## 2.1 Adat beolvasasa
adat <- read.csv("pisa_hun_small.csv")
head(adat)

#########################################################################################
## GGPLOT2 retegek kombinacioja
#########################################################################################

## 3.1 Abrazoljuk a matematika pontszamok eloszlasat egy boxplottal
ggplot(adat) +
  geom_boxplot(aes(x = "Matek", y = PontMat))

## 3.2 Most tobb reteg egymasra illesztesevel abrazoljuk
## a matematika pontszamok mellett a szovegertest es a 
## tudomanyos pontszamokat is!

ggplot(adat) +
  geom_boxplot(aes(x = "Matek", y = PontMat), col = "orange")+
  geom_boxplot(aes(x = "Szoveg", y = PontSzovegertes), col = "darkgreen") +
  geom_boxplot(aes(x = "Termtud", y = PontTermTud), col = "darkred")


#########################################################################################
## SZELESBOL HOSSZU ADATSZERKEZET
#########################################################################################


#########################################################################################
## Keszitsunk egy olyan valtozot, ami a tartalmazza az osszes pontszamot egyszerre!
## Azaz: ahelyett, hogy lenne egy olyan rekordunk, hogy
## ID, PontMatek, PontSzoveg, PontTermTud, legyen inkabb harom sor:
## ID, Tantargy, Pontszam.
## Ez kb. olyan, mint a pivot tabla gyartasa Excelben.
#########################################################################################


## 4.1 Nezzuk meg a transzformaciot elobb csak az elso sorra!

## 4.1.1 A pipe %>% operator es a select/slice fuggvenyek segitsegevel kerjuk le
## az elso sorban talalhato hallgato pontszamait! 
hallgato <- adat %>%
  slice(1) %>%
  select(PontMat, PontSzovegertes, PontTermTud)

## 4.1.2 Most konvertaljuk at a hallgatot szelesbol hosszu szerkezetbe
## a gather fuggveny segitsegevel
hallgato_hosszu <- gather(data = hallgato, terulet, pontszam, c(1:3))

## 4.1.3 Keszitsunk egy olyan boxplotot, ami mindharom pontszamot tartalmazza.
ggplot(hallgato_hosszu) +
  geom_boxplot(aes(x = terulet, y = pontszam)) 


## 4.2 Most keszitsuk el a hosszu valtozatat az egesz adatsornak!
## 4.2.1 A biztonsag kedveert keszitsunk peldaul egy IDt a mutat fuggveny segitsegevel!
adat <- adat %>%
  mutate(hallgatoID = row.names(adat))

## 4.2.2 Az igy kapott dataframe-et konvertaljuk hosszura!
adat_hosszu <- gather(data = adat, Terulet, Pontszam, c(13:15))

## 4.2.3 Nezzuk meg a boxplotjukat!
ggplot(adat_hosszu) +
  geom_boxplot(aes(x = Terulet, y = Pontszam))

#########################################################################################
## ALAPVETO MUVELETEK DATA.FRAME-EKEN A PIPE (%>%) OPERATOR SEGITSEGEVEL
#########################################################################################

## 5.1 vizuaizaljuk a pontszamokat Iskolatipus szerint!

## 5.1.1 Hogyan nezett ez ki csak matematikara?
ggplot(adat) +
  geom_boxplot(aes(x = IskolaTipusa, y = PontMat))

## 5.1.2 Onallo feladat:
## Rajzoljuk at ugy, hogy mindharom pontszam latsszon! (Hasznaljuk a mar meglevo)
## adat_hosszu szerkezetet!
ggplot(adat_hosszu) +
  geom_boxplot(aes(x = Terulet, y = Pontszam)) +
  facet_wrap(~ IskolaTipusa)

## 5.2 Rendezzuk sorba az iskola tipusat aszerint, hogy 
## matekbol atlagosan hany pontot ertek el az itt tanulo hallgatok!

## 5.2.1 Egyaltalan milyen tipusok vannak most? Hasznaljuk a levels fuggvenyt! 
levels(adat$IskolaTipusa)

## 5.2.2 Melyik iskolatipus atlagosan hany pontot ert el?  Taroljuk az erteket
## egy AtlagMatek oszlopban!
levels <- adat %>% 
  group_by(IskolaTipusa) %>%
  summarise(AtlagMatek = mean(PontMat, na.rm = T))

## 5.2.3 Rendezzuk be a data.frame-et e szerint a metrika szerint
levels <- adat %>% 
  group_by(IskolaTipusa) %>%
  summarise(AtlagMatek = mean(PontMat, na.rm = T)) %>%
  arrange(AtlagMatek)

## 5.2.4 Transzformaljuk at a faktort!
adat <- adat %>%
  mutate(IskolaTipusa = factor(IskolaTipusa, levels = levels$IskolaTipusa))

## 5.2.5 Generaljuk le ujra a hosszu szerkezetet es az abrat!
adat_hosszu <- gather(data = adat, Terulet, Pontszam, c(13:15))
ggplot(adat_hosszu) +
  geom_boxplot(aes(x = Terulet, y = Pontszam)) +
  facet_wrap(~ IskolaTipusa)

