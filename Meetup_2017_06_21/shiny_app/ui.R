fluidPage(
    title = "births shiny-demo",
    sidebarPanel(
        sliderInput(
            'period', 'Period to show:',
            min = min(birth_dt$year), max = max(birth_dt$year),
            value = c(min(birth_dt$year), max(birth_dt$year)),
            sep = '', step = 1
        ),
        checkboxGroupInput(
            'countries', "Countries to show:",
            choices = unique(birth_dt$country),
            selected = unique(birth_dt$country)
        ),
        actionButton('recalculate_plot', 'Apply filters on plot!'),
        width = 2
    ),
    mainPanel(
        plotOutput("birth_plot", height = "600px"),
        dataTableOutput("birth_dt"),
        width = 10
    )
)
