#########################################################################################
## KULONBSEGEK
#########################################################################################


library(maps)
library(tidyverse)

## Rajzoljunk terkepet, amely megmutatja, hogy a nok es ferfiak
## atlagos pontszamai kozott mennyi a kulonbseg! Hasznaljuk a scale_fill_gradient2() fuggvenyt,
## megpedig ugy, hogy pirosak jeloljek,
## ahol a noke magasabb
## es keken, ahol a ferfiake, a "semleges" orszagok legyenek feherek!


orszagok <- read.csv("pisa_small.csv")


## Keszitsunk egy adatszerkezetet, amiben minden orszagban kulon a ferfiakra
## es nokre van gegy atlagunk



## Keszitsunk egy olyan szeles adatszerkezetet, ahol a ferfiak es a nok kulon oszlopban
## jelennek meg!




## Keszitsunk egy uj oszlopot a kulonbsegekre!



## Joinoljuk ossze a world_map adatsorunkkal! Ugyeljunk a helyes join tipusra!


world_map <- map_data("world")
head(world_map)  



## Rajzoljuk ki a kulonbsegekkel szinezett terkepet!





