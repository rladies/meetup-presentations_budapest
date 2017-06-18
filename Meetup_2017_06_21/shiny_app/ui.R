fluidPage(
    title = "births shiny-demo",
    sidebarPanel(
        p('for future widgets'),
        width = 2
    ),
    mainPanel(
        plotOutput("birth_plot", height = "600px"),
        dataTableOutput("birth_dt"),
        width = 10
    )
)
