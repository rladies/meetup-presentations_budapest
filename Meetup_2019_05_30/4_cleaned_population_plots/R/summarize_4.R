summarize_population <- function(home_cities, ...) {
  home_cities %>% 
    group_by(...) %>% 
    summarize(num_contact = sum(num_contact)) %>%
    ungroup()
}
