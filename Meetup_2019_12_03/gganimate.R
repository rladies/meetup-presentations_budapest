library(data.table)
library(ggplot2)         
library(gganimate)
library(transformr)
library(gifski)
library(png)
library(datasauRus)

## Anscombe-i qaurtett
anscombe

##kiválasztani egy adathalmazt
anscombe[, c(1, 5)]

##ábrázolni
plot(anscombe[, c(1, 5)])

## lineáris modellt illeszteni
lm(anscombe[, c(1, 5)])

##vegyük észre, hogy az y alapján végzi a becslést az x-re, fordítva kell
lm(anscombe[, c(5, 1)])

## ábrázolni a lineáris modellt is
abline(lm(anscombe[, c(5, 1)]))

## intro to loops --- mi az lapply?? listát készít
lapply(1:4, identity)
lapply(1:4, function(i) i)
lapply(1:4, function(i) i + 4)

## milyenek ezek az adathalmazok? x-re
lapply(1:4, function(i) mean(anscombe[,i]))
lapply(1:4, function(i) sd(anscombe[,i]))

## milyenek ezek az adathalmazok? y-re
lapply(1:4, function(i) mean(anscombe[,i+4]))
lapply(1:4, function(i) sd(anscombe[,i+4]))

## x és y-t vizsgáljuk
lapply(1:4, function(i) cor(anscombe[,c(i, i+4)]))

##korreláció helyett adjuk vissza a szűrt data frame-eket
lapply(1:4, function(i) anscombe[, c(i, i+4)])

##fűzzük össze egy data frame-mé
rbindlist(lapply(1:4, function(i) anscombe[, c(i, i+4)]))

##kiegészítjük set oszloppal
rbindlist(lapply(1:4, function(i) cbind(set = i, anscombe[, c(i, i+4)])))

##mentés
df <- rbindlist(lapply(1:4, function(i) cbind(set = i, anscombe[, c(i, i+4)])))
str(df)

## setnames-zel át lehet nevezni az oszlopokat
setnames(df, c("set", "x", "y"))
str(df)


## mostantól adatviz, csak a df kell
ggplot(df, aes(x, y)) + geom_point()
ggplot(df, aes(x, y)) + geom_point() + facet_wrap(~set)

##kieg
ggplot(df, aes(x, y)) + geom_point() + facet_wrap(~set) + geom_smooth()

ggplot(df, aes(x, y)) + geom_point() + facet_wrap(~set) + geom_smooth(method ='lm')

##animáció:)
ggplot(df, aes(x, y)) + geom_point() + transition_states(set)

##további extrákat szeretnék
ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method ='lm') + transition_states(set)

##még extrát
ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method ='lm') + 
  transition_states(set) +
  labs(title = "{closest_state}")

##még-még
ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method ='lm') + 
  transition_states(set) +
  labs(title = "{closest_state}") + ease_aes('bounce-in-out')

## #############################################################################
## Datasaurus
##
## install.packages('datasauRus')
library(datasauRus)

datasaurus_dozen_wide
str(datasaurus_dozen_wide)

library(data.table)
rbindlist(lapply(1:13, function(i) cbind(
  set = sub('_y$', '', names(datasaurus_dozen_wide)[i*2]),
  setnames(
    datasaurus_dozen_wide[, c((i-1)*2 + 1:2)],
    c('x', 'y')))))

datasaurus_dozen

library(ggplot2)
ggplot(datasaurus_dozen, aes(x, y)) +
  geom_point() + facet_wrap(~dataset)

library(gganimate)
ggplot(datasaurus_dozen, aes(x, y)) +
  geom_point() + geom_smooth(method = 'lm') +
  transition_states(dataset)

subtitle <- function(df, digits = 4) {
  paste0(
    'mean(x)=', round(mean(df$x), digits), ', ', 'sd(x)=', round(sd(df$x), digits), '\n',
    'mean(y)=', round(mean(df$y), digits), ', ', 'sd(y)=', round(sd(df$y), digits), '\n',
    'cor(x,y)=', round(cor(df$x, df$y), digits)
  )
}
subtitle(datasaurus_dozen)

ggplot(datasaurus_dozen, aes(x, y)) +
  geom_point() + geom_smooth(method = 'lm') +
  transition_states(dataset) +
  labs(
    title = paste("{closest_state}"),
    subtitle = '{subtitle(subset(datasaurus_dozen, dataset == closest_state))}')


## #########################################################################
## Visualize the Simpson's paradox in the iris dataset
## when fitting a linear model on Sepal Length to predict Sepal Width
## (split by Species)

## global model
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point() + geom_smooth(method = 'lm')

## local models
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point() + geom_smooth(method = 'lm') +
  facet_wrap(~Species)

## local models on same plot
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() + geom_smooth(method = 'lm')

## global + local models on same plot
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point(aes(color = Species)) +
  geom_smooth(color = 'black', method = 'lm') +
  geom_smooth(aes(color = Species), method = 'lm')

## local models animated
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point() + geom_smooth(method = 'lm') +
  transition_states(Species) +
  labs(title = "{closest_state}")

## fancy animation showing gobal + local model after a bit of data engineering
irisanim <- rbindlist(lapply(levels(iris$Species), function(species) {
  rbind(
    cbind(filtered = FALSE, Species = species, iris[, 1:4]),
    cbind(filtered = TRUE, Species = species, subset(iris, Species == species)[, 1:4]))
}))

ggplot(irisanim, aes(Sepal.Length, Sepal.Width, color = filtered)) +
  geom_point() + geom_smooth(method = 'lm') +
  theme(legend.position = 'none') +
  transition_states(Species) +
  labs(title = "{closest_state}")

#########################################################################################################
## Első feladat:
## Ábrázold a mtcars adattömbjének elemeit a ggplot2 csomag segítségével pontdiagramon úgy, 
## hogy a lóerőt a súly függvényében veszed, és a sebességek száma szerint bontod különböző
## aspektusokra (facet)! 

## Második feladat:
## Az előző feladat sebesség szerinti bontását most animálással végezd el a gganimate csomag segítségével!


## Harmadik feladat:
## Ismerkedj meg a diamonds adattömbbel, és készíts különféle animációkat pont- és oszlopdiagrammokról, 
## boxplotokról, például a szín, vagy a csiszolás minősége bontásában!
##########################################################################################################