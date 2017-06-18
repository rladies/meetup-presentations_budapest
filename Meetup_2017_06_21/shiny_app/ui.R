fluidPage(
    title = "births shiny-demo",
    sidebarPanel(
        sliderInput(
            'period', 'Period to show:',
            min = 2007, max = 2015, value = c(2007, 2015),
            sep = ''
        ),
        checkboxGroupInput(
            'countries', "Countries to show:",
            choices = unique(readRDS('cleaned_birth_data.rds')$country),
            selected = unique(readRDS('cleaned_birth_data.rds')$country)
        ),
        width = 2
    ),
    mainPanel(
        plotOutput("birth_plot", height = "600px"),
        dataTableOutput("birth_dt"),
        width = 10
    )
)
