library('rvest')
library('dplyr')

################################################################################
## 1. feladat: talaljuk ki, mit jatszanak mostanaban a Katon szinpadan! ####
################################################################################

url <- "http://katonajozsefszinhaz.hu/eloadasok/bemutatok"
webpage <- read_html(url)

eloadasok_html <- html_nodes(webpage, '#contents-news a')
eloadasok_cim <- html_text(eloadasok_html)

################################################################################
## 2. Feladat: hamozzuk ki az eloadasok relativ URL-jeit! ####
## Hasznaljunk mondjuk for ciklust, kozben nezzunk ra a gsub es a 
## regexpr hasznalatara!
################################################################################

################################################################################
## 3. Feladat: keszitsunk abszolut linkeket a relativ utak
## "http://katonajozsefszinhaz.hu" prefixelesevel!
## Hasznaljunk mondjuk vektorizalast!
################################################################################

################################################################################
## 4. Feladat: Scrape-elljuk az osszes eloadas adatlapjat es gyujtsuk ki 
## a szereploket! Menjunk vegig peldaul az eloadas linkeken ehhez!
## Hint: '.cell-left-wide-highlighted a'
################################################################################

################################################################################
## 5. eladat: Menjunk vegig a listan es gyujtsuk ki, a kedvenc szineszeink
## jatszanak-e egyutt.
## Ehhez mondjuk a szineszek listajan menjunk vegig indexelessel!
## (A Fekete Erno sztringet igy keressuk: "Fekete Ern\U0151")
################################################################################
