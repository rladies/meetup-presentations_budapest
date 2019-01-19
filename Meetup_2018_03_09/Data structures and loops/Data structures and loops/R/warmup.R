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
rm(y, z)
x <- data.frame(a = c(10, 20, 30),
                b = c(TRUE, FALSE, FALSE))

## Milyen tipusu indexelesek mukodnek jol data frame-eknel? Nezzuk meg, hogy a
## [,],  [[]], $ operatorok mivel ternek vissza!
 
################################################################################
####################### 4 A fantasztikus for ciklus ###########################
################################################################################

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!


##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE!

################################################################################
####################### 4 S/Lapply fuggveny ######################################
################################################################################

##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!



##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! Nezzuk meg, mi a kulonbseg a klasszikus
##  <- es a <<- operator kozott!


## Szamoljuk ki az x data frame elso oszlopaban talalhato szamok negyzetet es
## taroljuk el egy uj vektorban


################################################################################
####################### 5 Purrr ################################################
################################################################################
library(purrr)


##  Irassuk ki az x data frame elso oszlopanak elemeit egyesevel!


##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! Nezzuk meg, mi a kulonbseg a klasszikus
##  <- es a <<- operator kozott!

################################################################################
####################### 6 vektorizalas, ahol csak lehet ########################
################################################################################

##  Szamoljuk az x data frame elso oszlopanak negyzetosszeget azokon a helyeken,
##  ahol a masodik oszlop erteke FALSE! 


