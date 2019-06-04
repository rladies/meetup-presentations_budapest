library("tidyverse")

# load data ---------------------------------------------------------------

data_path <- file.path(rprojroot::find_root('clean-r-code-student.Rproj'), "data")

# NA is valid country code, stands for Namibia, so should not be read as NA
countries <- read_csv(file.path(data_path, "countries.csv"), na = "")
home_cities <- read_csv(file.path(data_path, "home_cities_frequent.csv.gz"), na = "")

# data preparation -------------------------------------------------------

countries[!complete.cases(countries), ]
home_cities[!complete.cases(home_cities), ]

home_cities %>% 
  group_by(country_code, city) %>% 
  summarize(num_coord_per_city = n_distinct(long, lat)) %>% 
  filter(num_coord_per_city > 1)
