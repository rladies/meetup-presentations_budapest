fluidPage(
    
    title = "EU births shiny demo",
    
    sidebarPanel(
        sliderInput(
            inputId = "period", label = "Period to show:",
            min = 2007, max = 2015, value = c(2007, 2015),
            sep = "", step = 1
        ),
        width = 2
    ),
    
    mainPanel(
        tabsetPanel(
            tabPanel(
                title = "table",
                dataTableOutput(outputId = "birth_dt")
            ),
            tabPanel(
                title = "summary plot",
                plotOutput("birth_summary_plot", height = "700px")
            )
        ),
        width = 10
    )
)
