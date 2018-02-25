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



eloadasok_link <- lapply(eloadasok_html, function(mini_url){
  url_char <- as.character(mini_url)
  print(url_char)
  
  if(strsplit(url_char, split = "\">", fixed = T)[[1]][2] != "</a>" &
     strsplit(url_char, split = "\">", fixed = T)[[1]][2] != "\n  <br />\n</a>") {
    gsub(pattern = "<a href=\"",replacement = "http://katonajozsefszinhaz.hu",
         strsplit(url_char, split = "\">", fixed = T)[[1]][1])  
  } else {NA}
})

actors <- lapply(eloadasok_link, function(url_extended){
  if(!is.na(url_extended)){
    print(url_extended)
    play_webpage <- read_html(url_extended)
    actors_and_directors_html <- html_nodes(play_webpage, ".cell-left-wide-highlighted a")
    html_text(actors_and_directors_html)  
  } else {character(0)}
})

actors_graph <- data.frame(from = character(0),
                           to = character(0),
                           title = character(0))

lapply(seq(from = 1, to = length(eloadasok_cim)), function(i){
  print(i)
  if(length(actors[[i]]) >= 2) {
    actors_graph <<- rbind(actors_graph,
                           cbind(as.data.frame(t(combn(x = actors[[i]], m = 2, simplify = T))),
                                 eloadasok_cim[i]))  
  }
  T
})

colnames(actors_graph) <- c("from", "to", "title")


