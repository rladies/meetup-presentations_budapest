library(data.table)
library(nycflights13)

# Convert the flights dataframe to data.table
data <- data.table(flights)
names(data)

####################
## Set values - fast and efficient, because no duplicate data.table is created!
####################

## The not so efficient way
data[1,1]<-2017
data[1,1]

## The efficient way: set(DT, i, j, value) - i refers to the row index, j refers to the column index
set(data, 1L, 1L, 2017)
set(data, 1L, 1L, 2013)

####################
## Set key - When the running time is crucial
####################
## Similar to SQL INDEX
## An index is used to speed up the performance of queries. 
## The key also determines the physical order of data in the table. 

## set the key
setkey(data, origin)
## the data is sorted, but we do not see any other change
data
## tables() shows the keys
tables()

## aggregation by the key is very fast
data[, sum(air_time, na.rm = TRUE), keyby=origin]

## we can filter by the values of the key easier
data["JFK",]
data[c("JFK","LGA")]

## summarize on a value of the key
data["JFK", mean(air_time, na.rm=TRUE)]

## When multiple rows in x match to the row in i, mult controls which are returned: 
## "all" (default), "first" or "last".

data["JFK", mult="first"]
data["JFK", mult="last"]

########################
##  Exercise
##  set carrier as key and calculate max arr delay on "UA" carriers
setkey(data, carrier)
data["UA", max(arr_delay, na.rm=TRUE)]

####################
## Multiple keys
####################
## set multiple keys
setkey(data, origin, dest)
tables()

## Filter by keys
data[.("JFK", "MIA")]

## Aggregate by keys
data[.("JFK", "MIA"), mean(arr_delay, na.rm=TRUE) ]

####################
## Merge
####################

## Prepare another data.table
data_hun<-data.table(month=1:4, honap=c("Jan", "Febr", "Marc", "Apr"))

## merge the tables, the keys are automatic
setkey(data, month)
tables()
data_with_months_names <- data[data_hun]

####################
## Rolling join
####################

## set keys
dataFilled <- data[air_time>0]
setkey(dataFilled, air_time)
dataFilled[, .(origin, dest, air_time)]
## The values are 20 .. 691, 695

## rolling join - find ”nearest” record

## there is no air_time=692 but we can find the nearest row
dataFilled[.(692), roll="nearest"][, .(origin, dest, air_time, year, month, day)]

## there is noair_time=692 but we can find the closest among the smaller values
dataFilled[.(692), roll=+Inf][, .(origin, dest, air_time, year, month, day)]

## there is no air_time=692 but we can find the closest among the larger values
dataFilled[.(692), roll=-Inf][, .(origin, dest, air_time, year, month, day)]

## there is no air_time=692 but we can find a row
## where the value is smaller with at most 10 
dataFilled[.(692), roll=+10][, .(origin, dest, air_time, year, month, day)]

########################
##  Exercise
##  find the flight where dep_delay is the closest to -40

setkey(dataFilled, dep_delay)
dataFilled[.(-40), roll="nearest"][, .(origin, dest, air_time, dep_delay, year, month, day)]

#Find the flight where dep_delay is between -40 and -35
dataFilled[.(-40), roll=-5][, .(origin, dest, air_time, dep_delay, year, month, day)]

#Find the flight where dep_delay is between -40 and -30
dataFilled[.(-40), roll=-10][, .(origin, dest, air_time, dep_delay, year, month, day)]

###########################
## Melt and dcast functions
###########################

#create a unique id column
data[ , IDX := 1:.N]

#create rows from columns -> Long data fromat
melted_data <- melt(data, id.vars = "IDX", measure.vars=c("air_time", "dep_delay"))
melted_data

#create columns from values in a column -> Wide data format
dcasted_data <- dcast(melted_data, IDX ~ variable, value.var="value")

## calculate nr of flights form each origins for each destination
data[,count:=1]
dest_origin_counts <- dcast(data, dest ~ origin, value.var="count", fun.aggregate = sum)

###########################
## Exercise
## When did the only JFK BHM flight start?
data[origin=="JFK"&dest=="BHM"][,.(year, month, day, dep_time, sched_dep_time, arr_time)]

###########################
## Exercise2
## List months when there were more flights departing from LGA than from JFK 
dcast(data, month ~ origin, value.var="count", fun.aggregate = sum)[LGA>JFK]


###########################
###########################
###########################
## Install dev

## Test parallel fread!

# First remove the current version
remove.packages("data.table")

# Then install devel version
install.packages("data.table", type = "source", repos = "http://Rdatatable.github.io/data.table") 

## Revert the CRAN version
remove.packages("data.table")         # First remove the current version
install.packages("data.table")        # Then reinstall the CRAN version
