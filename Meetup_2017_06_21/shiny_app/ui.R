fluidPage(
    title = "births shiny-demo",
    sidebarPanel(
        p('for future widgets')
    ),
    mainPanel(
        plotOutput("birth_plot"),
        dataTableOutput("birth_dt")
    )
)
