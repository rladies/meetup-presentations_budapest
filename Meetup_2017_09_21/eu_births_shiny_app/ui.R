fluidPage(
    
    title = "EU births shiny demo",
    
    sidebarPanel(
        sliderInput(
            inputId = "period_lower", label = "Period to show:",
            min = 2007, max = 2015, value = 2007,
            sep = "", step = 1
        ),
        sliderInput(
            inputId = "period_upper", label = "Period to show:",
            min = 2007, max = 2015, value = 2015,
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
