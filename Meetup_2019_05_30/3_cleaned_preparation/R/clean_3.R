get_rows_with_missing_value <- function(df) {
  df[!complete.cases(df), ]
}

get_cities_with_multiple_coords <- function(home_cities) {
  home_cities %>% 
    group_by(country_code, city) %>% 
    summarize(num_coord_per_city = n_distinct(long, lat)) %>% 
    ungroup() %>% 
    filter(num_coord_per_city > 1)
}

glimpse_extreme_regions <- function(home_cities, countries, ...) {
  home_cities %>% 
    summarize_population(...) %>% 
    filter_extreme_regions_by_population() %>%
    attach_human_readable_country_metadata(countries)
}

summarize_population <- function(home_cities, ...) {
  home_cities %>% 
    group_by(...) %>% 
    summarize(num_contact = sum(num_contact)) %>%
    ungroup()
}

filter_extreme_regions_by_population <- function(region_populations) {
  region_populations %>%
    arrange(desc(num_contact)) %>%
    {rbind(head(.), tail(.))}
}

attach_human_readable_country_metadata <- function(df, countries) {
  df %>%
    inner_join(countries, by = "country_code") %>%
    select(country, everything(), -iso3c, -country_code)
}

attach_country_metadata <- function(df, countries) {
  inner_join(df, countries, by = "country_code")
}
