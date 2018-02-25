################################################################################
####################### 1 Vektorok #############################################
################################################################################
x <- c(1, 2, 3)
y <- c("Jancsi", "Juliska")
z <- c(TRUE, FALSE) 

## Nezzuk meg, az egyes indexek ([1], [2], [3] stb.) mivel ternek vissza.


################################################################################
####################### 2 Listak ###############################################
################################################################################
x <- list("a", TRUE, 1)
y <- list(list("a", "b"),
          list(1, 2))
z <- list("a" = c(1, 2, 3))

## Nezzuk meg, az egyes listaindexek ([[1]], [[2]], [[3]] stb.) mivel
## ternek vissza!

## Most nezzuk meg, a szimpla indexek ([1], [2], [3] stb.) mivel ternek vissza!

################################################################################
####################### 3 Data frame-ek ########################################
################################################################################

x <- data.frame(a = c(1, 2, 3),
                b = c(TRUE, FALSE, FALSE))

## Milyen tipusu indexelesek mukodnek jol data frame-eknel? Nezzuk meg, hogy a
## [,],  [[]], $ operatorok mivel ternek vissza!
 
################################################################################
####################### 4 A fantasztikus for ciklus ###########################
################################################################################

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!
for(i in c(1:length(x$a))) {
  print(x$a[i])
}

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE!

negyzetosszeg <- 0

for(i in c(1:length(x$a))) {
  if(x$b[i] == FALSE) {
    negyzetosszeg <- negyzetosszeg +  x$a[i]
  }
}


################################################################################
####################### 4 Lapply fuggveny ######################################
################################################################################

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!
?lapply
sapply(X = x$a, FUN = function(a_eleme) {
  print(a_eleme)
  T
})

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! Nezzuk meg, mi a kulonbseg a klasszikus
##  <- es a <<- operator kozott!
negyzetosszeg <- 0
sapply(X = c(1:length(x$a)), FUN = function(index) {
  if(x$b[index] == FALSE) {
    negyzetosszeg <<- negyzetosszeg +  x$a[index]
  }
  T
})

##  TODO: Kis kitero: merjuk le az idoket mondjuk egy egymillio elemu tombon for
##  ciklussal es apply fuggvennyel is!

library(profvis)

x_large <- data.frame(a = c(1:1000000),
                      b = sample(x = c(TRUE, FALSE), size = 1000000, replace = T,
                                 prob = c(0.5, 0.5)))
negyzetosszeg <- 0
profvis({
  for(i in c(1:length(x_large$a))) {
    if(x_large$b[i] == FALSE) {
      negyzetosszeg <- negyzetosszeg +  x_large$a[i]
    }
  }
})

negyzetosszeg <- 0
profvis({
  for(i in c(1:length(x_large$a))) {
    negyzetosszeg <- negyzetosszeg +  x_large$a[i]
  }
})


negyzetosszeg <- 0
profvis({
  sapply(X = c(1:length(x_large$a)), FUN = function(index) {
    if(x_large$b[index] == FALSE) {
      negyzetosszeg <<- negyzetosszeg +  x_large$a[index]
    }
    T
  })
})

negyzetosszeg <- 0
profvis({
  sapply(X = c(1:length(x_large$a)), FUN = function(index) {
    negyzetosszeg <<- negyzetosszeg +  x_large$a[index]
    T
  })
})

################################################################################
####################### 5 Purrr ################################################
################################################################################
library(purrr)


##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!
map(.x = x$a, .f = function(i){
  print(i)
  T
  }
)

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! Nezzuk meg, mi a kulonbseg a klasszikus
##  <- es a <<- operator kozott!

negyzetosszeg <- 0
map_if(.x = x$a, .p = !x$b, .f = function(a_elem){
  negyzetosszeg <<- negyzetosszeg + a_elem
})

################################################################################
####################### 6 vektorizalas, ahol csak lehet ########################
################################################################################

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! 

negyzetosszeg <- sum(x$a * !x$b)
