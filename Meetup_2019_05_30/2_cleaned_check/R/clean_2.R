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
