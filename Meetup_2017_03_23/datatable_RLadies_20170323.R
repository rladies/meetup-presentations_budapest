## install required packages
## install.packages("data.table")

## load required packages
library(data.table)

## create a data.table manually
DT = data.table(a=1:2, b=LETTERS[1:4])
DT

## Download the input file from this location: https://github.com/hyzhangsf/stat133-1/blob/master/datasets/starwars.csv
## And copy it to your working directory

## read a csv file and create a data.table
data<-fread("R/DataTable/starwars.csv")

####################
## Describe the data.table
####################

## Print the column names of data, number of rows and number of columns
names(data) ## or names(data)
dim(data)      ## or ncol(data) & nrow(data)
tables()

####################
## filter: get a subset of the rows of a data table
####################

## Print the third row to the console
data[3]

## Print the second, third and fourth row to the console
data[2:4]

## Select row 2 twice and row 4 and row 17, returning a data.table with four rows 
## where row 2 is a duplicate of row 1.
data[c(2, 2, 4, 17)]

## Print the penultimate row using `.N`
data[.N-1]

## Print the jedis
data[jedi=="jedi"]

## Print human jedis
data[jedi=="jedi" & species == "human"]

####################
## select: select certain columns from the data frame
####################

data[ , .(name,jedi)]

####################
## Exercise
## Let's combine these!
## Print the name, jedi, gender columns for every second rows 
## Solution:
data[ seq(2, 20, by=2), .(name, jedi, weapon)]

####################
## modify or create columns based on others
####################

## Do not need <- operator, the data.table is updated automatically if we use :=
data[ , BMI:=weight/(height*height)]
data

## create multiple new columns with `:=` ()
data[ , `:=` (E=substring(gender,1,1), F=5) ]
data

## Add 5 to column weight just in rows 2 and 4.
data[c(2,4), weight:=weight+5]
data

#############################
## Exercise
## Create a new column called J containing the first 2 characters of jedi, but only for humans
## Solution:
data[species=="human", J:=substring(jedi, 1, 2)]
data

####################
## summarise: collapse a data frame into one row 
####################

## Print the sum of column weight  as a vector
## na.rm = TRUE will drop missing values
## otherwise the result would be na, becuse Jabba's weight is missing
data[, sum(weight, na.rm = TRUE)]

## If we use .() then a data.table is returned. 
data[, .(sum(weight, na.rm = TRUE))]

## We can set the name of the column in the rseult data.table 
data[, .(Total_weight=sum(weight, na.rm = TRUE))]

## Calculate the median of height as well as the sum of weight 
## and name the two columns Total and Median in that order. 
data[, .(Total_weight=sum(weight, na.rm=TRUE), Median_height=median(height, na.rm=TRUE))]

## Return the first 4 items of name and the sum of weight. Call 
## these columns First4 and TotalWeight. Notice how TotalWeight 
## (a single value) is recycled to match the length of First4. 
data[,.(FirstFour=head(name,4), TotalWeight=sum(weight, na.rm=TRUE))]

## Return number of rows where weight*height<100
data[, sum((weight*height)<100, na.rm=TRUE)]

#############################
## Exercise
## Return the sum of weights for humans
## Solution:
data[species=="human", sum(weight, na.rm=TRUE)]

###########################################
## Further expressions in j

## We can use plot functions, as well
## For rows of jedis, plot height against weight.
data[jedi=="jedi", plot(weight,height)]

## We can use multiple commands in { ; }
## For all the rows of humans, print column name, 
## plot height against weight and return the mean of BMI.
data[species=="human",{print(name); plot(weight, height); mean(BMI, na.rm=TRUE)}]
