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


## 3.2 Most tobb reteg egymasra illesztesevel abrazoljuk
## a matematika pontszamok mellett a szovegertest es a 
## tudomanyos pontszamokat is!






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




## 4.1.2 Most konvertaljuk at a hallgatot szelesbol hosszu szerkezetbe
## a gather fuggveny segitsegevel


## 4.1.3 Keszitsunk egy olyan boxplotot, ami mindharom pontszamot tartalmazza.




## 4.2 Most keszitsuk el a hosszu valtozatat az egesz adatsornak!
## 4.2.1 A biztonsag kedveert keszitsunk peldaul egy IDt a mutat fuggveny segitsegevel!


## 4.2.2 Az igy kapott dataframe-et konvertaljuk hosszura!



## 4.2.3 Nezzuk meg a boxplotjukat!


#########################################################################################
## ALAPVETO MUVELETEK DATA.FRAME-EKEN A PIPE (%>%) OPERATOR SEGITSEGEVEL
#########################################################################################

## 5.1 vizuaizaljuk a pontszamokat Iskolatipus szerint!

## 5.1.1 Hogyan nezett ez ki csak matematikara?


## 5.1.2 Onallo feladat:
## Rajzoljuk at ugy, hogy mindharom pontszam latsszon! (Hasznaljuk a mar meglevo)
## adat_hosszu szerkezetet!



## 5.2 Rendezzuk sorba az iskola tipusat aszerint, hogy 
## matekbol atlagosan hany pontot ertek el az itt tanulo hallgatok!

## 5.2.1 Egyaltalan milyen tipusok vannak most? Hasznaljuk a levels fuggvenyt! 


## 5.2.2 Melyik iskolatipus atlagosan hany pontot ert el?  Taroljuk az erteket
## egy AtlagMatek oszlopban!




## 5.2.3 Rendezzuk be a data.frame-et e szerint a metrika szerint



## 5.2.4 Transzformaljuk at a faktort!



## 5.2.5 Generaljuk le ujra a hosszu szerkezetet es az abrat!



#########################################################################################
## DPLYR MUVELETEK: ISMETLES :)
#########################################################################################

#########################################################################################
## Feladat: nezzuk meg, hogy a legjobb matek pontszamot elero gimnazista
## egyeb pontszamai a tobbiekhez kepes hol (melyik percentilisnel) vannak?
#########################################################################################


## 6.1 Szurjuk le a gimnazistakat!



## 6.2 Sorrendezzuk oket a matek pontszamok alapjan!




## 6.3 Valasszuk ki a legjobb matek pontszamot generalot!




## 6.4 ilyen pontszamai vannak egyeb teruleteken?



## 6.5 Nyerjuk ki a tobbiek pontszamait egyeb teruletekrol!





## 6.6 Ellenorizzuk a pontszamokat
## az ecdf() fuggveny segitsegevel!



## 6.7 Onallo feladat: vegezzunk hihetosegvizsgalatot a matematika es szovegertes, valamint
## a matematika es termeszettudomanyos erteket abrazolasaval!






#########################################################################################
## Onallo Feladat: Az eggyel elotti abran ugy tunik, a szakmunkaskepzosok szovegertes
## pontszamainak medianja kisebb a matematikai pontszamaiknal. Na de mennyivel?
#########################################################################################
