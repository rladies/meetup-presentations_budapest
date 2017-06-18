fluidPage(
    title = "births shiny-demo",
    sidebarPanel(
        p('for future widgets')
    ),
    mainPanel(
        dataTableOutput("birth_dt")
    )
)
