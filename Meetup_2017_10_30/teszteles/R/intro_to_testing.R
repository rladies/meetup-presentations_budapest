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
## a lanyok vagy a fiuk matematika pontszamanak
## az atlaga kulonbozik-e?
#########################################################################################

## 3.1 Olvassuk be az adatokat

pisa <- read.csv(file  = "E:/rladies/meetup-presentations_budapest/Meetup_2017_10_30/teszteles/data/pisa_hun_small.csv")
head(pisa)


## 3.2 Rajzoljunk surusegdiagramot a matematika pontszamokbol!

ggplot(pisa) +
  geom_density(aes(x = PontMat, col = IskolaTipusa))

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

## 3.6 Nezzuk meg a beepitett t.test() kimenetet!
## Adjuk meg a ket vektort, aminek a varhato erteket ossze
## szeretnenk hasonlitani. Az alternativ hipotezis legyen
## mondjuk greater, az var.equal parametert hagyjuk
## nyugodtan FALSE-on. 
## A teszt inditasa elott nezzuk meg, mik a bemeneti feltetelezesek a mintara
## vonatkozolag, peldaul itt:
## http://stattrek.com/hypothesis-test/difference-in-means.aspx?Tutorial=AP!

t.test(pisa %>% filter(Nem == "Ferfi") %>% select(PontMat), 
       pisa %>% filter(Nem == "No") %>% select(PontMat),
       alternative = "greater")

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

exp <- as.data.frame(chisq_result$expected)
exp$Nem <- rownames(exp)

exp<- exp %>%
  gather(key = "IskolaTipusa", "n", -Nem)
  
ggplot(exp) +
  geom_bar(aes(x = Nem, y = n, fill = IskolaTipusa), stat = "identity")


