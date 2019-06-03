plot_city_populations <- function(city_populations) {
  city_populations %>% 
    plot_geo(lat = ~lat, lon = ~long) %>%
    add_markers(
      size = ~log10(num_contact),
      color = ~log10(num_contact),
      text = ~str_c(country_code, city, num_contact, sep = "<br />")
    ) %>% 
    log_population_colorbar()
}

plot_country_populations <- function(country_populations, countries) {
  country_populations %>% 
    attach_country_metadata(countries) %>%
    plot_geo(locations = ~iso3c) %>% 
    add_trace(
      z = ~log10(num_contact), 
      text = ~paste(country, prettyNum(num_contact, big.mark = " "), sep = "<br />")
    ) %>%
    log_population_colorbar()
}

log_population_colorbar <- function(p) {
  colorbar(p, title = "Population", tickprefix = "10^")
}

attach_human_readable_country_metadata <- function(df, countries) {
  df %>%
    attach_country_metadata(countries) %>%
    select(country, everything(), -iso3c, -country_code)
}

attach_country_metadata <- function(df, countries) {
  inner_join(df, countries, by = "country_code")
}

