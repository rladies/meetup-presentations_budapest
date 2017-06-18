library(data.table)
library(magrittr)
library(forcats)

unzip("Meetup_2017_06_21/births_by_mother_age_and_education_raw.csv.zip",
      exdir = "Meetup_2017_06_21/")
dt <- fread('Meetup_2017_06_21/births_by_mother_age_and_education_raw.csv')


filtered <- dt[!ISCED11 %in% c("All ISCED 2011 levels", "Unknown", "Not applicable")] %>% 
    .[!AGE %in% c('Total', 'Unknown')] %>% 
    .[Value != ':'] %>% 
    .[, UNIT := NULL]

setnames(
    filtered,
    names(filtered),
    c('year', 'education_level', 'age', 'country', 'num_birth')
)

cleaned_dt <- filtered %>%  
    .[, age := as.integer(stringr::str_replace_all(age, ' years', ''))] %>% 
    .[, num_birth := as.integer(stringr::str_replace_all(num_birth, ' ', ''))] %>% 
    .[, education_level := as.factor(education_level)] %>% 
    .[, education_level := fct_relevel(education_level, "Tertiary education (levels 5-8)", after = 2)] %>% 
    .[, country := as.factor(country)] %>% 
    as.data.frame()

saveRDS(cleaned_dt, 'Meetup_2017_06_21/eu_births_shiny_app/cleaned_birth_data.rds')
