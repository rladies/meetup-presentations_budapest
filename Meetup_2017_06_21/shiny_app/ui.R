fluidPage(
    title = "births shiny-demo",
    sidebarPanel(
        sliderInput(
            'period', 'Period to show:',
            min = 2007, max = 2015, value = c(2007, 2015),
            sep = ''
        ),
        width = 2
    ),
    mainPanel(
        plotOutput("birth_plot", height = "600px"),
        dataTableOutput("birth_dt"),
        width = 10
    )
)
