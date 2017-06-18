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
