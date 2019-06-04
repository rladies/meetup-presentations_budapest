get_population_share_of_top_cities <- function(city_populations) {
  city_populations %>% 
    add_country_population() %>%
    filter_top_city_by_country() %>%
    mutate(population_share = num_contact / country_population)
}

add_country_population <- function(df) {
  df %>% 
    group_by(country_code) %>% 
    mutate(country_population = sum(num_contact)) %>% 
    ungroup()
}

filter_top_city_by_country <- function(df) {
  df %>% 
    group_by(country_code) %>% 
    mutate(city_rank_in_country = min_rank(desc(num_contact))) %>%
    ungroup() %>%
    filter(city_rank_in_country == 1)
}

summarize_population <- function(home_cities, ...) {
  home_cities %>% 
    group_by(...) %>% 
    summarize(num_contact = sum(num_contact)) %>%
    ungroup()
}
