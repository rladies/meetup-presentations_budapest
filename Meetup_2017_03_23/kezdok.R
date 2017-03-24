rm(list=ls())

setwd("C:/Data Science/R-Ladies Budapest/2017.03.23")
#dir("C:/Data Science/R-Ladies Budapest/2017.03.23")



#install.packages("readxl")
library(readxl)
data <- read_excel("KerdoivEredmenyek.xlsx")
#data <- read.csv("KerdoivEredmenyek.csv")

#data
#str(data)
#class(data)

#ncol(data)
#nrow(data)
#length(data)

#class(length(data))



#R-objects:
#Vectors
#Lists
#Matrices
#Arrays
#Factors
#Data Frames

#data types of vector
#numeric
#integer
#complex
#logical 
#character



#colnames(data)
#rownames(data)
#names(data)

#class(names(data))

#értelmezzük az oszlop neveket és cseréljünk:
#ehhez kell egy karakter vektor
names <- names(data)
names[16:17] <- c("gépitanulás", "felügyelttanulás")
names(data) <- names



#válasszunk oszopot, dobjuk ki Julia-t:

#[] megoldás 1
R <- data[,1]
#vagy
R <- data$R
data320 <- data[,3:20]
filteredData <- cbind(R,data320)
#rbind

#[] megoldás 2
filteredData <- data[,c(1,3:20)]

#[] megoldás 3
filteredData <- data[,-2]

#subset megoldás
filteredData <- subset(data, select=-Julia)

#dplyr megoldás
#install.packages("dplyr")
library(dplyr)
#??dplyr
filteredData <- select(data, -Julia)



#válasszunk sort, dobjuk ki azokat akik képesek voltak NA-kat produkálni:
#complete.cases(data)
#class(complete.cases(data))

#[] megoldás
filteredDataWithoutNA<- filteredData[complete.cases(filteredData), ]

#subset megoldás
filteredDataWithoutNA <- subset(filteredData, complete.cases(filteredData))

#dplyr megoldás
filteredDataWithoutNA <- filter(filteredData, complete.cases(filteredData))

#direkt megoldás
filteredDataWithoutNA <- na.omit(filteredData)



boxplot(filteredDataWithoutNA$boxplot)
boxplot(filteredDataWithoutNA$R, filteredDataWithoutNA$ggplot2, filteredDataWithoutNA$shiny)

