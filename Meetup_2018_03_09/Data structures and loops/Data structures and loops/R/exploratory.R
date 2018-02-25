#Loading the rvest package
library('rvest')
library('plyr')
library('dplyr')

################################################################################
## 1. feladat: talaljuk ki, mit jatszanak mostanaban a Katon szinpadan! ####
################################################################################

url <- "http://katonajozsefszinhaz.hu/eloadasok/repertoar"
webpage <- read_html(url)

eloadasok_html <- html_nodes(webpage, '#contents-news a')
eloadasok_cim <- html_text(eloadasok_html)

################################################################################
## 2. Feladat: hamozzuk ki az eloadasok relativ URL-jeit! ####
################################################################################

aktiv_eloadas_linkek <- c()
for(i in c(1: length(eloadasok_html))) {
  url_char <- as.character(eloadasok_html[[i]])
  print(i)
  if(!grepl(pattern = "><", x = url_char,
           fixed = T)) {
    elotte <- strsplit(x = url_char,
                       split = "=\"", fixed = T)[[1]][2]
    utana <- strsplit(x = elotte, split = "\">", fixed = T)[[1]][1]
    aktiv_eloadas_linkek <<- c(aktiv_eloadas_linkek, utana)
  }
}

################################################################################
## 3. Feladat: keszitsunk abszolut linkeket a relativ utak
## "http://katonajozsefszinhaz.hu/" prefixelesevel!
################################################################################

aktiv_eloadas_abszolut <- paste0("http://katonajozsefszinhaz.hu/",
                                 aktiv_eloadas_linkek)

################################################################################
## 4. Feladat: Scrape-elljuk az osszes eloadas adatlapjat es gyujtsuk ki 
## a szereploket
################################################################################

szineszek <- list()

lapply(aktiv_eloadas_abszolut, function(eloadas_url){
  print(eloadas_url)
  eloadas_webpage <- read_html(eloadas_url)
  szinesz_html <- html_nodes(eloadas_webpage, '.eloadason-szinesz-link')
  szineszek[[eloadas_url]] <<- html_text(szinesz_html)
})

################################################################################
## 5. eladat: Menjunk vegig a listan es gyujtsuk ki, a kedvenc szineszeink
## jatszanak-e egyutt
################################################################################

lapply(c(1:length(szineszek)), function(index){
  if(any(szineszek[[index]] == "Keresztes Tamás") &
     any(szineszek[[index]] == "Fekete Ern\U0151")
     ) {
    print(names(szineszek)[[index]])
  }
  T
})
