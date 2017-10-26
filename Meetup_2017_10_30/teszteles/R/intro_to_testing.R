#########################################################################################
## TELEPITES
## 
## Az alabbi csomagot kell telepiteni es betolteni: ggplot2, dplyr
#########################################################################################

## 1.1 Csomag betoltese: a biztonsag kedveert toltsunk be egy ggplot2-t

library(ggplot2)
library(dplyr)
library(tidyr)


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
## ATLAGOK AZONOSSAGA
#########################################################################################

#########################################################################################
## Feladat: Vegyuk a jo oreg pisa adatokat es nezzunk ra arra, hogy
## a lanyok vagy a fiuk matematika pontszamanak
## az atlaga statisztikailag szignifikansan kulonbozik-e?
#########################################################################################

## 3.1 Olvassuk be az adatokat

setwd("C:/Users/asalanki/Documents/rladies/meetup-presentations_budapest/Meetup_2017_10_30/")
pisa <- read.csv(file  = "data/pisa_hun_small.csv")
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

## Egy populaciobol vettunk egy random mintat.
## Kiszamoltunk a mintabol valamit.
## A kerdes: mennyire valoszinu, hogy csak "rossz lapokat osztott a gep", 
## azaz a mintavetel hibajabol adodoan latunk csak valami kulonbseget?

## 3.4 Tegyuk fel, hogy a hallgato neme nem szamit es nezzuk meg, milyen egy "normalis"
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
(diff_gen)

## 3.5 Szimulaljuk le ugyanezt mondjuk 10000-szer es a kapott kulonbseg ertekekbol
## csinaljunk egy eloszlast! Abban az eloszlasban hol van a kapott ertek?

diffs <- numeric(0)
for(i in 1:1000) {
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
## A kulonbseg varhato erteke nulla kozeleben van es a szorasa is eleg pici
mean(diffs)
var(diffs)


## 3.6 Onallo feladat: Nezzuk meg a termeszettudomanyi pontszamokat
## a 3.3 es 3.5 kodok kis
## modositasaval!
mat <- pisa %>%
  group_by(Nem) %>%
  summarize(atlag = mean(PontTermTud))

diff <- mat %>% filter(Nem == "Ferfi") %>% select(atlag) - 
  mat %>% filter(Nem == "No") %>% select(atlag)

diff <- diff[[1]]
(diff)


diffs <- numeric(0)
for(i in 1:1000) {
  print(i)
  pisagen <- pisa %>%
    mutate(ujnem = sample(c("Ferfi", "No"), size = length(Nem), replace = T)) %>%
    select(ujnem, PontTermTud)
  
  mat <- pisagen %>%
    group_by(ujnem) %>%
    summarize(atlag = mean(PontTermTud))
  
  diff_gen <- mat %>% filter(ujnem == "Ferfi") %>% select(atlag) - 
    mat %>% filter(ujnem == "No") %>% select(atlag)
  
  diff_gen <- diff_gen[[1]]
  diffs <- c(diffs, diff_gen)
}

sum(abs(diffs) < diff)

ggplot(as.data.frame(diffs)) +
  geom_histogram(aes(x = diffs)) +
  geom_vline(aes(xintercept = diff))

## 3.6 Nezzuk meg a beepitett t.test() kimenetet!
## Adjuk meg a ket vektort, aminek a varhato erteket ossze
## szeretnenk hasonlitani. Az alternativ hipotezis legyen
## mondjuk greater, az var.equal parametert hagyjuk
## nyugodtan FALSE-on, a tobbi parameterrel nyugodtan probalkozzunk!
## A teszt inditasa elott nezzuk meg, mik a bemeneti feltetelezesek a mintara
## vonatkozolag, peldaul itt:
## http://stattrek.com/hypothesis-test/difference-in-means.aspx?Tutorial=AP!

t.test(pisa %>% filter(Nem == "Ferfi") %>% select(PontMat), 
       pisa %>% filter(Nem == "No") %>% select(PontMat),
       alternative = "two.sided", conf.level = 0.95)

t.test(pisa %>% filter(Nem == "Ferfi") %>% select(PontTermTud), 
       pisa %>% filter(Nem == "No") %>% select(PontTermTud),
       alternative = "two.sided", conf.level = 0.95)

#########################################################################################
## FUGGETLENSEG VIZGALATA DISZKRET ERTEKET KOZOTT
#########################################################################################

#########################################################################################
## Feladat: Nezzuk meg, hogy a nemek eloszlasa az egyes iskolatipusokban milyen!
#########################################################################################

## 4.1 Szamoljuk ki az aranyokat!
mat <- pisa %>%
  group_by(Nem, IskolaTipusa) %>%
  summarize(n = n())

ggplot(mat) +
  geom_bar(aes(x = Nem, y = n, fill = IskolaTipusa), stat = "identity")

## 4.2 Futtassunk le egy chi negyzet tesztet (chi square independence test), amiben
## megvizsgaljuk, vajon fuggetlenek-e a valtozok!
## A teszt inditasa elott nezzuk meg, mik a bemeneti feltetelezesek a mintara
## vonatkozolag, mondjuk itt: http://stattrek.com/chi-square-test/independence.aspx!

## 4.2.1 Nezzuk meg a leirasban, milyen tipusu bemenetet var a chisq.test()!
?chisq.test

M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
dimnames(M) <- list(gender = c("F", "M"),
                    party = c("Democrat","Independent", "Republican"))
(M)
(Xsq <- chisq.test(M))  # Prints test summary
Xsq$observed   # observed counts (same as M)
Xsq$expected   # expected counts under the null

## 4.2.2 Alakitsuk at a sajat bemenetunket is ilyenne, mondjuk egy table() hivassal!
ch_input <- table(pisa[, c("Nem", "IskolaTipusa")])

## 4.2.3 Futtassuk le a tesztet es nezzuk meg, mi lett volna az 'elvart' bemenet
## a fuggetlensegi feltetelezes mellett!
chisq_result <- chisq.test(ch_input)
(chisq_result)

exp <- as.data.frame(chisq_result$expected)
exp$Nem <- rownames(exp)

exp<- exp %>%
  gather(key = "IskolaTipusa", "n", -Nem)
  
ggplot(exp) +
  geom_bar(aes(x = Nem, y = n, fill = IskolaTipusa), stat = "identity")


#########################################################################################
## ELOSZLASOK AZONOSSAGA
#########################################################################################

#########################################################################################
## Feladat: Vajon a matematika es a termeszettudomanyi pontszamok eloszalasa 
## azonos-e a ferfiaknal es a noknel?
#########################################################################################

## 5.1. Rajzoljunk surusegdiagramot ra!

ggplot(pisa) +
  geom_density(aes(x = PontMat, col = Nem))


ggplot(pisa) +
  geom_density(aes(x = PontTermTud, col = Nem))

## 5.2 Futtassunk az azonossagvizsgalatra egy Kolmogorov-Szmirnov tesztet!
ks.test(unlist(pisa %>% filter(Nem == "Ferfi") %>% select(PontMat)), 
       unlist(pisa %>% filter(Nem == "No") %>% select(PontMat)))


ks.test(unlist(pisa %>% filter(Nem == "Ferfi") %>% select(PontTermTud)), 
        unlist(pisa %>% filter(Nem == "No") %>% select(PontTermTud)))

#########################################################################################
## ERTEKELJUNK KI EGY A/B TESZTET!
#########################################################################################

#########################################################################################
## Feladat: Ertekeljuk ki a 
#########################################################################################

## 6.1 Nezzuk meg, a teszt csoport tobb penzt hozott-e a konyhara, azaz az atlagos
## bevetali aranyuk nagyobb-e!
mean(full$purcahse_value[full$category == 'Test']) -  mean(full$purcahse_value[full$category == "Control"])

t.test(full$purcahse_value[full$category == 'Test'],
       full$purcahse_value[full$category == "Control"])


## 6.2 Nezzunk konverzios ratat a control es a teszt csoportra!
full %>%
  group_by(category) %>%
  summarise(konv  = sum(purcahse_value > 0))

t.test((full$purcahse_value > 0)[full$category == 'Test'],
       (full$purcahse_value > 0 )[full$category == "Control"])
## Melyik a jobb?


## 6.3 Milyen volt az open es a click rate? Mas-e a kettore?
full %>%
  group_by(category, clicked) %>%
  summarize( n = n())

t.test((full$clicked  == "Yes")[full$category == 'Test'],
       (full$clicked == "Yes" )[full$category == "Control"])

## 6.4 Hol nyitottak meg azokat az e-maileket?
opens <- full %>%
  filter(clicked == "Yes") %>% 
  group_by(category, platform) %>%
  summarize( n = n())

chisq.test(table(full[full$clicked == "Yes", c("category", "platform")]))


