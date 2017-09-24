# R csomagok gyűjtöhelye: https://cran.r-project.org

# Első kód
print("Hello world!")

# Példák különböző típusú változók létrehozására és műveletekre
# egész számok
a <- 5
b <- 37
a+b

# character változó
c <- "Hello Ladies!"
print(c)

# logikai változó
logical_var <- TRUE
# valós szám változó
real_var <- 2/3
# dátum változó
date_var <- as.Date("2017-09-21")

# Vektorok
c(5:39)

vector_var <- c(1, 2, 5, "alma", TRUE)
vector_var[5]
vector_var[1] +vector_var[2]
vector_var[2:4]

vector_var2 <- c(3,6,8,12)

# DataFrame

# Létrehozás manuálisan
n <- c(2,3,5)
s <- c("alma", "barack", "szilva")
l <- c(TRUE, FALSE, TRUE)

df <- data.frame(n,s,l)

# Munkakönyvtár beállítása
setwd("/home/wpe/Documents/Rladies/")

# dataframe léterhozása csv file-ból
data <- read.csv("starwars.csv")
# help elérése
?read.csv

# Dataframe tartalmát összegző függvények
# méretek
dim(data)
#oszlopnevek
colnames(data)
# első 3 sor kiírása
head(data,3)
# egy adott oszlopra hivatkozás 
data$name
# egy oszlopon átlag számítás
mean(data$height)
# struktúra
str(data)
# summary
summary(data)

# dplyr csomag installálása - csak 1x kell lefuttatni, később már elég betölteni
install.packages("dplyr")
# dplyr csomag betöltése
library(dplyr)

# filter - megtartjuk a teljesen kitöltött sorokat
completed_data <- filter(data, complete.cases(data))
# új változót (oszlopot) adunk a dataframe-hez
completed_data <- mutate(completed_data, BMI = weight/(height*height))
# átrendezzük a dataframe sorait
completed_data <- arrange(completed_data, BMI)

# egy numerikus oszlopból histogram-ot készítünk
hist(completed_data$BMI)

?plot
# 2 numerikus oszlopot scatterplot-on ábrázolunk
plot(completed_data$weight, completed_data$height)



