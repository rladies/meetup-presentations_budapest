fluidPage(
    
    title = "EU births shiny demo",
    
    sidebarPanel(
        'placeholder for input widgets'
    ),
    
    mainPanel(
        tabsetPanel(
            tabPanel(
                title = 'table',
                dataTableOutput("birth_dt")
            )
        )            
    )
)
