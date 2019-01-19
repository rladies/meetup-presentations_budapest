################################################################################
####################### 1 Vektorok #############################################
################################################################################
x <- c(1, 2, 3)
y <- c("Jancsi", "Juliska")
z <- c(TRUE, FALSE) 

## Nezzuk meg, az egyes indexek ([1], [2], [3] stb.) mivel ternek vissza.
x[1]
x[2]
x[3]
y[1]
y[2]
y[3]
y[4]
z[1]
z[2]
z[3]
# Konlk 1: NA-val ter vissza, nem pedig out of bounds errorral
# Konkl 2: egytol indexelunk
# Konkl 3: csak azonos tipusu elemek kerulnek bele, egyebkent kasztolodik
c(1, 2, FALSE)
################################################################################
####################### 2 Listak ###############################################
################################################################################
x <- list("a", TRUE, 1)
y <- list(list("a", "b"),
          list(1, 2))
z <- list("a" = c(1, 2, 3))

## Nezzuk meg, az egyes listaindexek ([[1]], [[2]], [[3]] stb.) mivel
## ternek vissza!
x[[1]]
x[[2]]
x[[3]]
x[[4]]
y[[2]][[2]]
z[[1]][2]
z[["a"]]

## Most nezzuk meg, a szimpla indexek ([1], [2], [3] stb.) mivel ternek vissza!
x[1]
x[1:2]
y[1]

# Konkl 1: ide barmi johet
# Konkl 2: a nevesites sokkal jobban kijon
# Subscript out of bounds-zal ter vissza

################################################################################
####################### 3 Data frame-ek ########################################
################################################################################

x <- data.frame(a = c(1, 2, 3),
                b = c(TRUE, FALSE, FALSE))

## Milyen tipusu indexelesek mukodnek jol data frame-eknel? Nezzuk meg, hogy a
## [,],  [[]], $ operatorok mivel ternek vissza!
x[1, 2]
x[2, 1]
x[3, 13]
x$a
x[["a"]]
x[[1]]
x[1, 2]
x[[2]][1]
################################################################################
####################### 4 A fantasztikus for ciklus ###########################
################################################################################

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!
for(i in c(1, 2, 3)){
  print(x[[1]][i])
}

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE!
negyzetosszeg <- 0
for(i in c(1:3)){
  if(x[[2]][i] == FALSE) {
    negyzetosszeg <- negyzetosszeg + x[[1]][i] 
  }
}
(negyzetosszeg)
################################################################################
####################### 4 Lapply fuggveny ######################################
################################################################################

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!
sapply(X = c(1, 2, 3), FUN = function(index){
  print(index)
  T
})

sapply(X = x$a, FUN = function(item){
  print(item)
  T
})
# konkl: melyik a kenyelmesebb?

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! Nezzuk meg, mi a kulonbseg a klasszikus
##  <- es a <<- operator kozott!

negyzetosszeg <- 0

sapply(X = c(1, 2, 3), FUN = function(index){
  browser()
  if(x$b[index] == FALSE) {
    negyzetosszeg <<- negyzetosszeg + index^2 
  }
  T
})

## Szamoljuk ki az x data frame elso oszlopaban talalhato szamok negyzetet es
## taroljuk el egy uj vektorban

negyzetek <- c()
for(i in c(1:3)) {
  negyzetek <- c(negyzetek, x$a[i]^2)  
}

negyzetek2 <- sapply(x$a, FUN = function(item){
  item^2
  })

################################################################################
####################### 5 Purrr ################################################
################################################################################
library(purrr)

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!
map(x$a, .f = function(item){print(item)})

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! Nezzuk meg, mi a kulonbseg a klasszikus
##  <- es a <<- operator kozott!
negyzetosszeg <- 0
map_if(x$a, x$b == FALSE, function(item){
  negyzetosszeg <<- negyzetosszeg + item^2
})


################################################################################
####################### 6 vektorizalas, ahol csak lehet ########################
################################################################################

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! 
sum(x$a[x$b == FALSE]^2)
