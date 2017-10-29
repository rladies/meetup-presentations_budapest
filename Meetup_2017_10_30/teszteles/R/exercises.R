################################################################################
## TELEPITES
## 
## Az alabbi csomagot kell telepiteni es betolteni: ggplot2, dplyr
################################################################################

## 1.1 Csomagok betoltese: a biztonsag kedveert toltsunk be nehany
## adattranszformacios csomagot

library(ggplot2)
library(dplyr)
library(tidyr)


################################################################################
## SZIMULACIO: HADLUM KONTRA HADLUM
################################################################################

################################################################################
## Feladat: Szimulaljunk egy normalis eloszlast mean = 40, sd = 2 parameterekkel
## es nezzuk meg, hol helyezkedik el a 349/7 het az eloszlasban!
##
## (Ez a becsles egyaltalan nem pontos, egy csomot irnak rola itt hogy miert nem: 
## https://datayze.com/labor-probability-calculator.php)
################################################################################

## 2.1 Szimulaljuk le az eloszlast az rnorm() fuggveny segitsegevel!



## 2.2 Hany ertek kisebb, mint a 349/7?




## 2.3 Rajzoljuk ki az eloszlast es az erteket!





#########################################################################################
## SZIMULACIO: KET ELOSZLAS VIZSGALATA
#########################################################################################

#########################################################################################
## Feladat: Vegyuk a jo oreg pisa adatokat es nezzunk ra arra, hogy
## a lanyok vagy a fiuk matematika pontszamanak
## az atlaga kulonbozik-e?
#########################################################################################

## 3.1 Olvassuk be az adatokat

setwd("...")
pisa <- read.csv(file  = "data/pisa_hun_small.csv")
head(pisa)


## 3.2 Rajzoljunk surusegdiagramot a matematika pontszamokbol!




## 3.3 Mekkorak az atlagok? Mekkora a kulonbseg?
mat <- pisa %>%
  group_by(Nem) %>%
  summarize(atlag = mean(PontMat))

diff <- mat %>% filter(Nem == "Ferfi") %>% select(atlag) - 
  mat %>% filter(Nem == "No") %>% select(atlag)

diff <- diff[[1]]
(diff)

## Egy populaciobol vettunk egy random mintat.
## Kiszamoltunk a mintabol valamit.
## A kerdes: mennyire valoszinu, hogy csak "rossz lapokat osztott a gep", 
## azaz a mintavetel hibajabol adodoan latunk csak valami kulonbseget?

## 3.4 Tegyuk fel, hogy a hallgato neme nem szamit es nezzuk meg, milyen egy "normalis"
## kulonbseg: minden ertekhez rendeljunk egy nemet veletlenszeruen a sample() fuggveny 
## segitsegevel, majd szamoljuk ki a kulonbseget!

sample(c("Ferfi", "No"), size = 10, replace = T)











## 3.5 Szimulaljuk le ugyanezt mondjuk 1000-szer es a kapott kulonbseg ertekekbol
## csinaljunk egy eloszlast! Abban az eloszlasban hol van a kapott ertek?





## Tanulsagok?
## A kulonbseg varhato erteke nulla kozeleben van es
## a szorasnegyzete is eleg pici



## 3.6 Onallo feladat: Nezzuk meg a termeszettudomanyi pontszamokat
## a 3.3 es 3.5 kodok kis
## modositasaval!






#########################################################################################
## KERETRENDSZEREK: KET MINTA ATLAGANAK AZONOSSAGA
#########################################################################################

#########################################################################################
## Feladat: Vegyuk a jo oreg pisa adatokat es nezzunk ra arra, hogy
## a lanyok vagy a fiuk matematika pontszamanak
## az atlaga kulonbozik-e?
#########################################################################################


## 4.1 Nezzuk meg a beepitett t.test() kimenetet!
## Adjuk meg a ket vektort, aminek a varhato erteket ossze
## szeretnenk hasonlitani. Az alternativ hipotezis legyen
## mondjuk greater, az var.equal parametert hagyjuk
## nyugodtan FALSE-on, a tobbi parameterrel nyugodtan probalkozzunk!
## A teszt inditasa elott nezzuk meg, mik a bemeneti feltetelezesek a mintara
## vonatkozolag, peldaul itt:
## http://stattrek.com/hypothesis-test/difference-in-means.aspx?Tutorial=AP!





#########################################################################################
## KERETRENDSZEREK: FUGGETLENSEG VIZSGALATA DISZKRET ERTEKET KOZOTT
#########################################################################################

#########################################################################################
## Feladat: Nezzuk meg, hogy a nemek eloszlasa az egyes iskolatipusokban milyen!
#########################################################################################

## 5.1 Szamoljuk ki az aranyokat!



## 5.2 Futtassunk le egy chi negyzet tesztet (chi square independence test), amiben
## megvizsgaljuk, vajon fuggetlenek-e a valtozok!
## A teszt inditasa elott nezzuk meg, mik a bemeneti feltetelezesek a mintara
## vonatkozolag, mondjuk itt: http://stattrek.com/chi-square-test/independence.aspx!

## 5.2.1 Nezzuk meg a leirasban, milyen tipusu bemenetet var a chisq.test()!
?chisq.test

M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
dimnames(M) <- list(gender = c("F", "M"),
                    party = c("Democrat","Independent", "Republican"))
(M)
(Xsq <- chisq.test(M))  # Prints test summary
Xsq$observed   # observed counts (same as M)
Xsq$expected   # expected counts under the null

## 5.2.2 Alakitsuk at a sajat bemenetunket is ilyenne, mondjuk egy table() hivassal!



## 5.2.3 Futtassuk le a tesztet es nezzuk meg, mi lett volna az 'elvart' bemenet
## a fuggetlensegi feltetelezes mellett!


##
exp <- as.data.frame(chisq_result$expected)
exp$Nem <- rownames(exp)

exp<- exp %>%
  gather(key = "IskolaTipusa", "n", -Nem)

ggplot(exp) +
  geom_bar(aes(x = Nem, y = n, fill = IskolaTipusa), stat = "identity")


#########################################################################################
## KERETRENDSZEREK: ELOSZLASOK AZONOSSAGA
#########################################################################################

#########################################################################################
## Feladat: Vajon a matematika es a termeszettudomanyi pontszamok eloszalasa 
## azonos-e a matematika pontszamokkal?
#########################################################################################

## 6.1. Rajzoljunk surusegdiagramot ra!



## 6.2 Futtassunk az azonossagvizsgalatra egy Kolmogorov-Szmirnov tesztet!




#########################################################################################
## ERTEKELJUNK KI EGY A/B TESZTET!
#########################################################################################

#########################################################################################
## Feladat: Marketing csapatunk az alabbi ket e-mailt kuldte ki veletlenszeruen
## kivalasztott 1000-1000 felhasznalonak.
## A mi feladatunk kiertekelni a tesztet, azaz megallapitani, melyik verzio a
## "jobb".
#########################################################################################

## 7.1 Olvassuk be a hotels_email.csv allomanyt a data konyvtarunkbol!

hotels <- read.csv("data/hotels_email.csv")
head(hotels)

hotels %>%
  group_by(category) %>%
  summarize(users = n(),
            opened = sum(opened == "Yes"),
            platform_desktop = sum(platform == "Desktop", na.rm = T),
            platform_mobile = sum(platform == "Mobile", na.rm = T),
            clicked = sum(clicked == "Yes", na.rm = T),
            purchase = sum(purchase_value))

## 7.2 Nezzuk meg, az egzes csoport tobb penzt hozott-e a konyhara, azaz az atlagos
## bevetali aranyuk nagyobb-e!




## 7.3 Nezzunk konverzios ratat a control es a teszt csoportra!



## Melyik a "jobb" valtozat akkor?

## 7.4 Milyen volt az open es a click rate? 



## 7.4 Hol nyitottak meg azokat az e-maileket, ahol rakattintottak a gombra?
## Futtassunk le egy tesztet, amiben lemerjuk, a click rate fuggetlen-e a
## platformtol!


