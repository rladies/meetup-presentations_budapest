library("tidyverse")
library("plotly")

purrr::walk(list.files("5_cleaned_capital_effect/R", full.names = TRUE), source)

# load data ---------------------------------------------------------------

data_path <- file.path(rprojroot::find_root('clean-r-code-student.Rproj'), "data")

# NA is valid country code, stands for Namibia, so should not be read as NA
countries <- read_csv(file.path(data_path, "countries.csv"), na = "")
home_cities <- read_csv(file.path(data_path, "home_cities_frequent.csv.gz"), na = "")

# data preparation -----------------------------------------------------

get_rows_with_missing_value(countries)
get_rows_with_missing_value(home_cities)

get_cities_with_multiple_coords(home_cities)

# data exploration --------------------------------------------------------

glimpse_extreme_regions(home_cities, countries, country_code, city)
glimpse_extreme_regions(home_cities, countries, country_code)

home_cities %>% 
  summarize_population(country_code, city, long, lat) %>%
  filter(num_contact >= 1000) %>%
  plot_city_populations()

home_cities %>%
  summarize_population(country_code) %>%
  plot_country_populations(countries)

# capital city effect -----------------------------------------------------

home_cities %>% 
  summarize_population(country_code, city) %>%
  get_population_share_of_top_cities() %>%
  plot_population_share(countries)

# industry comparison based on spread of clients --------------------------

clients <- read_csv(file.path(data_path, "clients.csv"))
get_rows_with_missing_value(clients)

home_cities %>% 
  group_by(client_id) %>%
  summarize(num_country = n_distinct(country_code)) %>% 
  inner_join(clients, by = "client_id") %>% 
  ggplot(aes(x = num_country, color = industry)) + 
  geom_density() + 
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
