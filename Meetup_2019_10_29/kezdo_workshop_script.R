################################
# R LADIES - Beginner workshop
# October 29, 2019
################################

# Keyboard shortcuts: 
# add new section: crtl + shft + R 
# comment selected parts of scripts: ctrl + shft + c
# <- : Alt + - 


# A. BASICS ----------------------------------------------------------------

# basic arithmetic operations 
1+2
5*8
5/9
log(2)
sqrt(2)
abs(-4)

# assign values to variables
vektor <- "a"
vektor

nmr <- 2


# data types: chr, num, logical
class(vektor)

# vector: A vector is a sequence of data elements of the same basic type.
chr <- c("a", "b", "c", "d") # character vector
num <- 1:3  # numeric vector
log <-  c(TRUE, FALSE, FALSE, TRUE)  # logical vector

# extract elements from vector by position
chr[2]


vektor <-  letters[seq(1:3)]
vektor <-  LETTERS[seq(1:3)]
vektor <-  letters[which(letters == "h") : which(letters == "z")]

# matrices: like an Excel sheet containing multiple rows and columns. Combination of multiple vectors with the same types (numeric, character or logical).
t <- matrix(
       1:12,                 # the data components
       nrow=4,               # number of rows
       ncol=3,               # number of columns
       byrow = FALSE)        # fill matrix by columns
  
# print the matrix
  t                         

# extract elements of matrices
t[2,3] # 2nd row and 3rd column
t[,3]  # 3rd column
t[1,]  # 1st row

# factor 
fruits <- factor(c("apple", "orange", "grape", "plum"))
levels(fruits)

# data frames: A data frame is more general than a matrix, in that different columns can have different basic data types. Data frame is the most common data type we are going to use in this class.



# B. LOOK AT YOUR DATA -------------------------------------------------------


# 0. PREPARATION ----------------------------------------------------------

# clear environment
ls()
rm(list=ls())


# install & load packages
install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)

# Getting some help
?install.packages
help("dplyr")

# Paths and working directory
getwd()
setwd("C:\\Users\\user\\Documents\\eszter\\other\\r ladies\\kezdo_workshop\\")

### (Files/More/Set As Working directory)
# setwd("~/eszter/other/r ladies/kezdo_worskhop")


# read data
world_dev_indicators <- read.csv("world_dev_indicators.csv", stringsAsFactors=FALSE)
countries_to_continents <- read.csv("countries_to_continents.txt", stringsAsFactors=FALSE)


# Match countries with continents
data<- merge(world_dev_indicators, countries_to_continents, by = "Country")



# I. WORKING WITH BASE PACKAGES  ------------------------------------------


# 1. OVERVIEW OF THE DATA -------------------------------------------------

# have a look at the data and its structure
View(data)
head(data)
head(data, 10)
View(head(data, 10))
str(data) # Displays by default 100, has no return values
str(data, list.len =13)
summary(data)
names(data) # colnames(data) does the same

nrow(data)
ncol(data)
dim(data)

# classes/types of variables
### + apply functions

# apply: apply: Apply Functions Over Array Margins
# The apply function simply applies a function over an array and returns a vector of results. 
# For example, if we have a matrix of numbers and want the column or row sums we could use the apply function.
apply(data,2,class)

# sapply: Apply a Function over a List or Vector
# The sapply function loops through a set of values provided and returns a vector, matrix (if appropriately sized),
#  or list.
View(sapply(data,class))

View(as.data.frame(lapply(data,class)))

variable_types<-lapply(data,class)
variable_types
variable_types[variable_types=="integer"]
View(variable_types[variable_types=="character"])

# ratio of NAs
data[data==".."]<-NA # replace .. with NA
NA_ratio_per_variables <- as.data.frame(apply(as.data.frame(lapply(data,is.na)),2,sum)/nrow(data)*100)


# 2. DATA MANIPULATION ----------------------------------------------------

# rename columns
names(data)   # list variable names 
              # colnames(data) does the same

newnames <- c("country", "year", "time_code", "country_code", "gdp", "co2", "unempl", "lifeexp", "mortality", 
              "pop", "pop_above65", "continent", "subregion")
colnames(data) <-  newnames


# have a look at some variables
View(unique(data$country))
View(unique(data$subregion))

# transform variables 
## from chr to numeric
data$gdp <- as.numeric(data$gdp) # one variable
data$country <- as.character(data$country) # one variable

## list of variables
cols_to_numeric <-  c("co2", "unempl", "lifeexp", "mortality", "pop", "pop_above65")
data[cols_to_numeric] <- sapply(data[cols_to_numeric],as.numeric)
sapply(data, class)


# 3. BASIC PLOTS ----------------------------------------------------------
hist(data$gdp)
hist(data$lifeexp)

boxplot(data$mortality)
boxplot(data$unempl, ylab = "Unemployment rate (2010-2018)")

plot(data$gdp, data$lifeexp, 
     xlab="GDP per capita", 
     ylab = "Lie expectancy", 
     main = "GDP and Life expectancy")

with(data = data, expr = {
  plot(x = gdp,y = lifeexp)
  abline(lm(lifeexp~gdp))
})


# plot(data$gdp, data$mortality)
# plot(data$gdp, data$unempl)

# II. WORKING WITH DPLYR AND GGPLOT2 --------------------------------------


# 3. DPLYR: Descriptive language for the steps of data manipulation --------------------------
# cheatsheet: www.rstudio.com/resources/cheatsheets

# tidy data: 1 row / observation

# |install.packages("dplyr")
library(dplyr)

# two ways:
# a. Without the pipe syntax: -----------------------

# rename columns 
data$year_code <-  data$time_code
data <-  rename(data, "co2_emission" = "co2")


# select variables
select(data, gdp, unempl)

# columns starting with a name
select(data, starts_with("pop"))

# store it in a new dataframe
newdf <-  select(data, gdp, unempl, pop)
View(newdf)

# filter
# >, <, ==, >=, <= operators 
Hungary <- filter(data, country == "Hungary")
View(Hungary)
filter(data,
       year==2018,
       gdp < 3000,
       pop > 30000000)

# sort the data
arrange(data, year, -gdp)
arrange(data, country, year, -lifeexp)
arrange(data, desc(pop))

# create new variable: mutate
data <- mutate(data, log_pop=log(pop), log_gdp=log(gdp))

# observations with the highest and lowest gdp per capita
View(top_n(data, 100, gdp))
View(top_n(data, -100, gdp))

# how many years are available for the countries
View(count(data, country))


# b. With the pipe syntax: %>% -----------------------
# to use multiple functions in a row

# rename specific column(s)
data <-  data %>%
  rename("time_c" = "time_code")

# drop/keep variables
data2 <-  data %>%
  select(-subregion, -year_code)  # to select which ones to keep: select(var1, var2, var3...etc)

# summarise
data3 <- data %>%
  group_by(country) %>%
  summarise(gdp_sum=sum(gdp))
View(data3)

data4 <- data %>%
  group_by(country) %>%
  summarise(gdp_mean=mean(gdp), 
            pop_median=median(pop)) %>%
  filter(gdp_mean > 40000) %>%
  arrange(-pop_median)


# 4. DRAW SOME PLOTS W GGPLOT2 ------------------------------------------------------
library(ggplot2)

# bar graphs
data4 %>%
  arrange(gdp_mean) %>%
  ggplot(., aes(country, gdp_mean)) +
  geom_col() 

data4 %>%
  arrange(gdp_mean) %>%
  ggplot(., aes(country, gdp_mean)) +
  geom_col() +
  ggtitle("Mean GDP of countries between 2010-2018") +
  ylab("Mean GDP per capita in US dollars") +
  xlab("Countries") +
  coord_flip()


data4 %>%
  arrange(gdp_mean) %>%
  ggplot(., aes(country, gdp_mean)) +
  geom_col(fill = "#88398A") +
  ggtitle("Mean GDP of countries between 2010-2018") +
  ylab("Mean GDP per capita in US dollars") +
  xlab("Countries") +
  coord_flip()


data4 %>%
  arrange(pop_median) %>%
  ggplot(., aes(country, pop_median)) +
  geom_col(fill = "#88398A") +
  ggtitle("Median population of countries with high GDP between 2010-2018") +
  ylab("Mean population") +
  xlab("Countries") +
  coord_flip()

# order in descending order
data4 %>%
  arrange(pop_median) %>%
  ggplot(., aes(reorder(country, pop_median), pop_median)) +
  geom_col(fill = "#88398A") +
  ggtitle("Median population of countries with high GDP between 2010-2018") +
  ylab("Mean population") +
  xlab("Countries") +
  coord_flip()


# scatterplot
data %>%
  ggplot(., aes(log_gdp, lifeexp)) +
  geom_point(color= "blue")

# add linear regression line
data %>%
  ggplot(., aes(log_gdp, lifeexp)) +
  geom_point(color= "#EBB8BD") +
  geom_smooth(method = "lm", se = FALSE, colour="#88398A")


 # export, save data
setwd("")
write.csv(data3, "gdp_sum.csv")



# Useful sources --------------------------

# swirl: https://swirlstats.com/ 
  # an R package designed to teach you R straight from the command line. 
  # Swirl provides exercises and feedback from within your R session to help you learn in a structured, interactive way.

# Beginner R Workshop written in R Markdown 
# https://rstudio-pubs-static.s3.amazonaws.com/222325_ad39df865a984159af4861d9194d079b.html


