## Steps for creating a simple shiny app to explore some data on births and mother's education in the EU.

Goal is deployed [here](https://ildi-czeller.shinyapps.io/eu_births_shiny_app/).

### Prerequisites

required packages: shiny, ggplot2, dplyr
```
install.packages(c('shiny', 'ggplot2', 'dplyr'))
```

download these 3 files to a directory:
- `server.R`
- `ui.R`
- `cleaned_birth_data.rds`

To work in RStudio is highly recommended, but not necessary.

At any point to run your app, either press the green run App button in RStudio, or paste the following to your R console: `shiny::runApp(launch.browser = TRUE)`

