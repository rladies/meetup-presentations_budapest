# R-LADIES
# DPLYR & GGPLOT 
# 2019. DECEMBER 3. 

# 0. Preparation ----------------------------------------------------------

# import libraries
library(tidyverse)
library(RColorBrewer)
library(gridExtra)

# clear the environment
rm(list=ls())

# set the main library/-ies
wd <- "C:/Users/user/Documents/eszter/other/r ladies/dplyr_ggplot_ws_1203"

# import your data
setwd(wd)
thanksgiving_raw <- read.csv("thanksgiving_usa.csv", stringsAsFactors = FALSE)


#*** RCurl #***
# from the website
# library(RCurl)
# x <- getURL("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2018/2018-11-20/thanksgiving_meals.csv")
# raw <- read.csv(text = x, stringsAsFactors = FALSE)
#******************


# 0. Look at your data -------------------------------------------------------
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2018/2018-11-20 -- description of variables
str(thanksgiving_raw)
summary(thanksgiving_raw)

# ratio of NAs
NA_ratio_per_variables <- as.data.frame(apply(as.data.frame(lapply(thanksgiving_raw,is.na)),2,sum)/nrow(thanksgiving_raw)*100)
View(NA_ratio_per_variables)

# I. Data manipulation w dplyr -------------------------------------------------------
library(dplyr)

# tidy data principles: 
# 1. each variable -> a column
# 2. observation -> row
# 3. each type of obs. unit forms a table

# pipe syntax: to use multiple functions at once


# cheatsheets: www.rstudio.com/resources/cheatsheets

glimpse(thanksgiving_raw)  # ~ str()

# Main dplyr functions
# FILTER: subset data row-wise
df <- filter(thanksgiving_raw,celebrate == "Yes" )   # drop observations where they do not celebrate thanksgiving or missing

# SELECT: subset data on variables/columns
df <- select(df, -prayer, -kids_table_age)  # drop variables

#...

# pipe operator: %>%

# main dish variable
unique(df$main_dish_other)
unique(df$main_dish)

# MUTATE: create new variable
## --> let's create a new variable for main dish with mutate
df <- df %>%
  mutate(main_dish_new=case_when(main_dish=="Other (please specify)" ~ main_dish_other,
                                 TRUE ~ main_dish)) 

  # in case when we only need the newly created variable, include this in the pipe:

  #select(-main_dish,-main_dish_other) %>%  # drop variables
  #rename("main_dish"="main_dish_new")     # rename variable

unique(df$main_dish_new)

# drop NAs: drop_na
df <- df %>%
  drop_na(main_dish)


# MUTATE: modify variables
# convert variables
str(df) 

# family income: chr --> factor
df <- df %>%
  mutate(family_income=as.factor(family_income))
unique(df$family_income)


#********************************************************
### Put it all together and write your own code! 
# convert gender variable to 0 & 1:
## 1. drop NAs (drop_na)
## 2. replace Male=1, Female=0

 # df_gender <- df %>%
 #   __()%>%
 #   (gender_new=__)

#********************************************************

# SEPARATE: separate  one column into several <--> UNITE
df <- df %>%
  separate(family_income, c("family_income1", "family_income2"), sep = " to ", remove = FALSE)

# look at what we have done
df %>%
  select(family_income,family_income1, family_income2) %>%
  head(10)

# SUMMARISE: reduce multiple values down to a single value
df_sum <-  df %>%
  group_by(us_region, main_dish) %>%  # GROUP BY: group the data by a column
  dplyr::summarise(nr_of_people=n()) %>%
  arrange(-nr_of_people)
df_sum
  
# how many people have prepared turkey as a main dish by region ?
turkey1 <- df_sum %>%
  group_by(us_region) %>%
  filter(main_dish=="Turkey") %>%
  summarise(turkey=sum(nr_of_people))

# percentage of total?
turkey2 <- df_sum %>%
  group_by(us_region) %>%
  summarise(total=sum(nr_of_people))

turkey <- merge(turkey1, turkey2)

turkey <- turkey %>%
  mutate(percent=(turkey/total)*100)
turkey


# Gather: reshape data from wide to long
## sidedish 
library(tidyverse)
side_long <- df %>% 
  group_by(id) %>%   # group the data by a column
  
  gather(side_nr, side_dish, side1:side15 ) %>%   
  # from wide to long
  # key: Name of new key column  
  # value: Name of new value column 
  # ... : names of source columns that contain values
  
  arrange(id)    # arrange: arrange (re-order) rows by a column

side_long %>%
  select(id, side_dish, side_nr) %>%
  View()

# Spread: from long to wide

#********************************************
# Put it all together!
# family income groups by gender?
df_sum_income_gender <- df %>%
  drop_na(gender, family_income) %>%
  group_by(gender, family_income) %>%
  dplyr::summarise(nr_of_people=n()) %>%
  arrange(-nr_of_people) %>%
  spread(gender, nr_of_people)  # from long to wide
df_sum_income_gender


# II. Data visualization w ggplot2 --------------------------------------------
# Setup
options(scipen=999)  # turn off scientific notation like 1e+06
library(ggplot2)
library(RColorBrewer)

# Initialize a basic ggplot
# load a sample dataset
ggplot(diamonds, aes(x=carat, y=price))  # no plut until you add the geom layers

# point 
ggplot(diamonds, aes(x=carat, y=price)) +
  geom_point() +
  geom_smooth()


# simple bar chart: By default, ggplot makes a ‘counts’ barchart
# people who celebrate vs who do not by age groups:
# who celebrate
plot1 <- df %>%
  drop_na(age) %>%
  group_by(age) %>%
  ggplot(aes(x=age)) +
  geom_bar()
plot1

# who don't
plot2 <- thanksgiving_raw %>%
  filter(celebrate=="No") %>%
  drop_na(age) %>%
  group_by(age) %>%
  summarise(people=n()) %>%
  ggplot(aes(x=age, y=people)) +
  geom_col(fill="blue") # add color
plot2

# compare in one graph
# stacked
thanksgiving_raw %>%
  drop_na(age, celebrate) %>%
  group_by(age, celebrate) %>%
  summarise(people=n()) %>%
  ggplot(aes(x=age, y=people, fill=celebrate)) +
  geom_col(position= "fill") # equal size columns to compare percentages
  #geom_col(position = "dodge") # to see side by side

# or: library(gridExtra)
library(gridExtra)
grid.arrange(plot1,plot2, ncol=2)


# Most popular maind dish age-group
df %>%
  drop_na(age, main_dish) %>% 
  group_by(age, main_dish) %>%
  filter(age != "Other (please specify)") %>%
  summarize(nr=n()) %>%
  ggplot(aes(main_dish, reorder(nr, main_dish), fill=age)) + # reorder: to show it in a descending order
  geom_col(position = "dodge") +
  coord_flip() +  # flip 
  theme_classic() +  # built-in themes  OR "ggthemes" package: additional themes
  # theme_bw() +
  # theme_minimal() +
  # ... 
  scale_fill_brewer(palette = "Accent") +  # add a color palette
  labs(title = "What is the main dish at Thanksgiving dinner (by age groups)?",
       x = "Type of main dish",
       y = "Freq")

# with facet wrap
df %>%
  drop_na(age, main_dish) %>% 
  group_by(age, main_dish) %>%
  summarize(nr=n()) %>%
  ggplot(aes(main_dish, reorder(nr, main_dish), fill=age)) + # reorder: to show it in a descending order
  geom_col() +
  facet_wrap(~age, scale="free", ncol=2) +
  coord_flip() +  # flip 
  theme_classic() +
  scale_fill_brewer(palette = "Accent") +  # add a color palette
  labs(title = "What is the main dish at Thanksgiving dinner (by age groups)?",
       x = "Type of main dish",
       y = "Freq")
  
# What are the most popular pies for Thanksgiving?
thanksgiving_raw %>%
  select(pie1:pie13, age, gender) %>%
  gather(pie_type = pie1:pie13, 
         value = count) %>%
  select(pie_type = key, 
         pie = count) %>%
  na.omit() %>%
  filter(!grepl('Other', pie), pie != 'None') %>% 
  group_by(pie) %>%
  count() %>% 
  filter(n > 10) %>%
  ungroup() %>%
  ggplot(aes(reorder(pie, n), n, label = n)) +
  geom_bar(aes(fill = pie),
           alpha = 0.9,
           stat='identity') +
  coord_flip() +
  theme_classic() + 
  theme(legend.position = 'none') +
  labs(title = "Most Popular Pies for Thanksgiving (n=980)",
       subtitle = "Question: Which type of pie is typically served at your Thanksgiving dinner? \n Please select all that apply",
       x = "",
       y = "")




