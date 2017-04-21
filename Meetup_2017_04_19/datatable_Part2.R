## install required packages
## install.packages("data.table")

## needed only if you get the following error: "Error: isLOGICAL(showProgress) is not TRUE"
## options(datatable.showProgress=T)

## load required packages
library(data.table)

## read a csv file and create a data.table
## The input file location: https://github.com/hyzhangsf/stat133-1/blob/master/datasets/starwars.csv
data<-fread("R/DataTable/starwars.csv")

# create a new column containing BMI
data[ , BMI:=weight/(height*height)]

####################
## group_by: Group observations by one or more variables 
####################

## Calculate the mean weight for each Species
data[, mean(weight), by=species]

## Add this mean to the original data.table as a column
data[, MeanWeight := mean(weight), by=species]

## Calculate the mean weight for all species-jedi combination
data[, mean(weight), by=.(species, jedi)]

## .N can be used in j too = the num rows in this group
data[, .(.N ,mean(weight)), by=jedi]

## we can use functions inside
## Calculate the mean height for each first letter of the Species name 
data[, mean(height, na.rm=TRUE), by=substr(species,1,1)]

## We can use logical expressions in by
data[, max(height), by=.(BMI>25, grepl("S", name))]

## We can make chains by DT[][]
data[species=="human"][,.(name, jedi)]

###################################
## Exercise
## calculate the average BMI by species and return only those records, 
## where the BMI is higher than the average
## Solution:
data[, MeanBMI:=mean(BMI), by=species][BMI>MeanBMI]

####################
## order a data table
####################

## Order the data by weight ascending
data[order(weight)]

## Order the data by weight descending
data[order(-weight)]

## or sort the result fo the excercie
data[, MeanBMI:=mean(BMI), by=species][BMI>MeanBMI][order(BMI)]

####################
## Keyby = Groupby + order + set key
####################

data[, MeanBMI:=mean(BMI), keyby=species]
tables()

####################
## Operations on several columns
####################

## .SD is a data.table containing the Subset of x’s Data for each group, 
## excluding any columns used in by (or keyby).

## Get the mean of all the columns by Species
data_numeric <- data[,.(weight, height, BMI, species)]
data_numeric[, lapply(.SD, mean), by=species]
data_numeric[, lapply(.SD, mean), by=species, .SDcols=2:3]

## .SDcols Specifies the columns of x included in .SD. May be character column
## names or numeric positions.

# Select column names by their positions
data[,.SD, .SDcols=3:6]

########################
##  Exercise
##  Exclude data where weight>=80, calculate the sum of height and weight 
data[weight<80, lapply(.SD, sum), by=species, .SDcols=3:4]

## Get the first 2 columns from every group
data[, head(.SD, 2), by=weapon]

####################
## Delete coloumns
####################

## Remove the TotalWeight column
## oszlopok torlese
data[, MeanWeight:=NULL]

## Given myCols, delete columns born, died and MeanWeight.
mycols<-c("born", "died")
data[, (mycols):=NULL]

####################
## Modify column names
####################

## use setnames to modify the colnames
## syntax: setnames(x, old, new)
setnames(data, "homeland", "home")
data

## Add a postfix "_2" to all column names.
setnames(data, paste0(names(data),"_2"))
data

####################
## Exercise
## Remove the last 2 characters of the column names
setnames(data, substr(names(data), 1, nchar(names(data))-2 ))
data

####################
## Reorder the columns
####################

## Set the order of the columns.
setcolorder(data, c(3,2,1,4:13))
