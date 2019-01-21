# 0. DATA PREP WORKING WITH BASE PACKAGE(S)  ==============================================================

ls()
rm(list=ls())

setwd("~/03_R_PROJECTS/R_Ladies/Beginner_session_by_RK")
wd <- getwd()

data <- read.csv(paste0(wd,"/data/","data_R_users.csv"))

col_RLadies<-"#88398A"

countries_to_continents <- read.csv(paste0(wd,"/data/","countries_to_continents.csv"))
data<- merge(data, countries_to_continents, by="Country")

# library(ggplot2)

# 1. WORKING WITH BASE PACKAGE(S)  ========================================================================

# A. Get to know the data -------------------------------------------------------------------------------------------

# Have a look at the records
head(data)
View(head(data))
View(head(data,n=10))


# Have a look at the structure

class(data)
names(data)
nrow(data)
ncol(data)
dim(data)
str(data) # Displays by default 100, has no return values
str(data, list.len =130)
apply(data,2,class)
View(sapply(data,class))
as.data.frame(lapply(data,class))
variable_types<-lapply(data,class)
variable_types[variable_types=="numeric"]
View(variable_types[variable_types=="integer"])

#NAs...
NA_ratio_per_question <- as.data.frame(apply(as.data.frame(lapply(data,is.na)),2,sum)/nrow(data))




# HAve a look at some variables 
View(levels(data$Country))
View(levels(data$Continent))
View(levels(data$DevType))
View(levels(data$FormalEducation))
View(levels(data$Employment))
View(levels(data$Student))




# B. Draw some plots-------------------------------------------------------------------------------------------------

counts_country <- table(data$Country)
View(counts_country)
barplot(sort(counts_country, decreasing=TRUE)[1:10]
        , main="Top 10 of Country"
        , ylab="Number of Respondents"
        , col="#88398A"
)

counts_continents <- table(data$Continent)
View(counts_continents)
barplot(sort(counts_continents, decreasing=TRUE)
        , main="Continents"
        , ylab="Number of Respondents"
        , col="#88398A"
)

View(data[data$Country])
counts_gender <- table(data$Gender)
View(counts_gender)
barplot(sort(counts_gender, decreasing=TRUE)[1:10]
        , main="Gender distribution"
        , ylab="Number of Respondents"
        , col="#88398A"
        , horiz=TRUE
)

counts_age <- table(data$Age)
View(counts_age)
barplot(counts_age
        , main="Age distribution"
        , ylab="Number of Respondents"
        , col="#88398A"
        # , horiz=TRUE
)


hist(data$ConvertedSalary)

# In R’s default boxplot{graphics} code,
# 
# upper whisker = min(max(x), Q_3 + 1.5 * IQR) 
# lower whisker = max(min(x), Q_1 – 1.5 * IQR)
# 
# where IQR = Q_3 – Q_1, the box length.
# So the upper whisker is located at the *smaller* of the maximum x value and Q_3 + 1.5 IQR, 
# whereas the lower whisker is located at the *larger* of the smallest x value and Q_1 – 1.5 IQR.

boxplot(ConvertedSalary~YearsCoding
        # , data=data
        , data=data[data$ConvertedSalary>0,]
        , main=""
        , xlab=""
        , ylab=""
        , outline=FALSE
        , col=col_RLadies
        )

boxplot(ConvertedSalary~CompanySize
        , data=data
        , main=""
        , xlab=""
        , ylab=""
        , outline=FALSE
        , col=col_RLadies
        )

boxplot(ConvertedSalary~Continent
        , data=data
        , main=""
        , xlab=""
        , ylab=""
        , outline=FALSE
        , col=col_RLadies
        )

data2<-data[data$Continent=="Europe",]
data2$Country<-factor(data2$Country)

boxplot(ConvertedSalary~Country
        # , data=data
        , data=data2
        , main=""
        , xlab=""
        , ylab=""
        , outline=FALSE
        , col=col_RLadies
)


# 2. WORKING WITH DPLYR  ==================================================================================
options(scipen = 999)

library(dplyr)

# Descriptive language for the steps of data manipulation -------------------------------------------------

select(data, Country,CompanySize)
select(data, one_of(c("Country","Age","ConvertedSalary","CompanySize")))
select(data, starts_with("Assess"))

filter(data, Country=="United States")

select(filter(data, Country=="United States"),c("Country","Age"))

select(data, Continent, ConvertedSalary)

View(top_n(data,1,Country))
View(top_n(data,100,ConvertedSalary))

class(data$ConvertedSalary)


View(group_by(data,Continent))
count(data,Continent)

#  Pipe syntax --------------------------------------------------------------------------------------------

data %>%
  select(Country,Age,ConvertedSalary, CompanySize)  %>%
  filter(Country=="United States")  %>%
  filter(is.na(ConvertedSalary)==FALSE)  %>%
  group_by(CompanySize)  %>%
  # summarise(avg_salary=mean(ConvertedSalary)) 
  mutate(avg_salary=median(ConvertedSalary)) 





# CHALLENGE =================================================================================

# 

# salary non NA
# number of respondents by country
# top ten responder countries
# sort by country median salary

# Solution A - with base functions -------------------------------------------------
# salary non NA
 
data2_A<-data2[is.na(data2$ConvertedSalary)==FALSE,]

# number of respondents by country
table(data2_A$Country)

# top ten responder countries

top_ten_responder_countries<-names(sort(table(data2_A$Country),decreasing=TRUE)[1:10])

data2_A[data2_A$Country %in% top_ten_responder_countries,]
dim(data2_A[data2_A$Country %in% top_ten_responder_countries,])
sum(sort(table(data2_A$Country),decreasing=TRUE)[1:10])

data2_A <- data2_A[data2_A$Country %in% top_ten_responder_countries,]

# calculate and sort by country median salary

median_salaries<-setNames(aggregate(data2_A$ConvertedSalary
                   , by=list(data2_A$Country)
                   , FUN=median)
         ,c("Country","MedianSalary"))

data2_A <- merge(data2_A, median_salaries,by="Country")
data2_A <- order(data2_A,$MedianSalary),]

# order(data2_A,data2_A$MedianSalary,decreasing=TRUE)

data2_A$Country<-factor(data2_A$Country)

# data2_A$Country<- ordered(data2_A$Country, levels=levels(data2_A$data2_A)[data2_A$MedianSalary])   

boxplot(ConvertedSalary~Country
        # , data=data
        , data=data2_A
        , main="Salary distribution across European countries (Top 10 responders)"
        , xlab="Countries"
        , ylab="Converted Salary in USD"
        , outline=FALSE
        , col=col_RLadies
)


# Solution B - with dplyr functions ------------------------------------------------
# salary non NA

# number of respondents by country

# top ten responder countries

# sort by country median salary



