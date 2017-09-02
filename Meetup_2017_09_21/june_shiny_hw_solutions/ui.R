fluidPage(
    
    title = "EU births shiny demo",
    
    sidebarPanel(
        sliderInput(
            inputId = "period", label = "Period to show:",
            min = 2007, max = 2015, value = c(2007, 2015),
            sep = "", step = 1
        ),
        textOutput("period_value"),
        checkboxGroupInput(
            inputId = "countries", label = "Countries to show:",
            choices = unique(readRDS("cleaned_birth_data.rds")$country),
            selected = unique(readRDS("cleaned_birth_data.rds")$country)
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
            ),
            tabPanel(
                title = "births by education",
                plotOutput("births_by_education_plot", height = "700px")
            )
        ),
        width = 10
    )
)
