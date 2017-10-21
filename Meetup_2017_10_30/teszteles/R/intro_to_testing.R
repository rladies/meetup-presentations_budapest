#########################################################################################
## TELEPITES
## 
## Az alabbi csomagot kell telepiteni es betolteni: ggplot2, dplyr
#########################################################################################

## 1.1 Csomag betoltese: a biztonsag kedveert toltsunk be egy ggplot2-t

library(ggplot2)
library(dplyr)


#########################################################################################
## Hadlum kontra Hadlum
#########################################################################################

#########################################################################################
## Feladat: Szimulaljunk egy normalis eloszlast mean = 40, sd = 2 parameterekkel es
## nezzuk meg, hol helyezkedik el a 349/7 het az eloszlasban!
##
## (A becsles egyaltalan nem pontos, egy csomot irnak rola itt hogy miert nem: 
## https://datayze.com/labor-probability-calculator.php)
#########################################################################################

## 2.1 Szimulaljuk le az eloszlast az rnorm() fuggveny segitsegevel!

labor_prob <- rnorm(n = 100000, mean = 40, sd = 2)

## 2.2 Hany ertek kisebb, mint a 349/7?

sum(labor_prob < 349 / 7)


## 2.3 Rajzoljuk ki az eloszlast es az erteket!
ggplot(as.data.frame(labor_prob)) +
  geom_histogram(aes(x = labor_prob)) +
  geom_vline(aes(xintercept = 349 / 7))


#########################################################################################
## ELOSZLASOK VARHATO ERTEKENEK AZONOSSAGA
#########################################################################################

#########################################################################################
## Feladat: Vegyuk a jo oreg pisa adatokat es nezzunk ra arra, hogy
## a lanyok es a fiuk varhato matematika pontszamanak
## az atlaga kulonbozik-e?
#########################################################################################

## 3.1 Olvassuk be az adatokat

pisa <- read.csv(file  = "E:/rladies/meetup-presentations_budapest/Meetup_2017_10_30/teszteles/data/pisa_hun_small.csv")
head(pisa)


## 3.2 Rajzoljunk surusegdiagramot a matematika pontszamokbol!

ggplot(pisa) +
  geom_density(aes(x = PontMat, col = Nem))

## 3.3 Mekkorak az atlagok? Mekkora a kulonbseg?
mat <- pisa %>%
  group_by(Nem) %>%
  summarize(atlag = mean(PontMat))

diff <- mat %>% filter(Nem == "Ferfi") %>% select(atlag) - 
  mat %>% filter(Nem == "No") %>% select(atlag)

diff <- diff[[1]]

## 3.4 Tegyuk fel, hogy a nem nem szmit es nezzuk meg, milyen egy "normalis"
## kulonbseg: minden ertekhez rendeljunk egy nemet veletlenszeruen a sample() fuggveny 
## segitsegevel, majd szamoljuk ki a kulonbseget!

sample(c("Ferfi", "No"), size = 10, replace = T)

pisagen <- pisa %>%
  mutate(ujnem = sample(c("Ferfi", "No"), size = length(Nem), replace = T)) %>%
  select(ujnem, PontMat)

mat <- pisagen %>%
  group_by(ujnem) %>%
  summarize(atlag = mean(PontMat))

diff_gen <- mat %>% filter(ujnem == "Ferfi") %>% select(atlag) - 
  mat %>% filter(ujnem == "No") %>% select(atlag)

diff_gen <- diff_gen[[1]]

## 3.5 Szimulaljuk le ugyanezt mondjuk 10000-szer es a kapott kulonbseg ertekekbol
## csinaljunk egy eloszlast! Abban az eloszlasban hol van a kapott ertek?

diffs <- numeric(0)
for(i in 1:10000) {
  print(i)
  pisagen <- pisa %>%
    mutate(ujnem = sample(c("Ferfi", "No"), size = length(Nem), replace = T)) %>%
    select(ujnem, PontMat)
  
  mat <- pisagen %>%
    group_by(ujnem) %>%
    summarize(atlag = mean(PontMat))
  
  diff_gen <- mat %>% filter(ujnem == "Ferfi") %>% select(atlag) - 
    mat %>% filter(ujnem == "No") %>% select(atlag)
  
  diff_gen <- diff_gen[[1]]
  diffs <- c(diffs, diff_gen)
}

sum(diffs < diff)

ggplot(as.data.frame(diffs)) +
  geom_histogram(aes(x = diffs)) +
  geom_vline(aes(xintercept = diff))

## Tanulsagok?
## A kulonbseg mintha normal eloszlas lenne
mean(diffs)
sd(diffs)
ferfiak <- pisa %>% filter(Nem == "Ferfi") %>% select(PontMat)
nok <- pisa %>% filter(Nem == "No") %>% select(PontMat)
var(ferfiak)

## 3.6 Onallo feladat: Csinaljuk vegig ezt az egeszet a termeszettudomanyi pontszammal
##a 3.3 es 3.5 kodok kis
## modositasaval!


## 3.6 Ellenorizzuk le az ertekeket a t.test() segitsegevel!
## Adjuk meg a ket vektort, aminek a varhato erteket ossze
## szeretnenk hasonlitani. Az alternativ hipotezis legyen
## mondjuk greater, az var.equal parametert hagyjuk
## nyugodtan FALSE-on.

t.test(pisa %>% filter(Nem == "Ferfi") %>% select(PontMat), 
       pisa %>% filter(Nem == "No") %>% select(PontMat),
       alternative = "greater")

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

