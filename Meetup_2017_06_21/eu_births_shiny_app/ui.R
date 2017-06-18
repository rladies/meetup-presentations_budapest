fluidPage(
    title = "EU births shiny demo",
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
        tabsetPanel(
            tabPanel(
                title = 'summary plot',
                plotOutput("birth_summary_plot", height = "600px")
            ),
            tabPanel(
                title = 'table',
                dataTableOutput("birth_dt")
            ),
            tabPanel(
                title = 'births by mothers\' education',
                plotOutput('births_by_education_plot', height = "600px")
            )
        ),
        width = 10
    )
)
