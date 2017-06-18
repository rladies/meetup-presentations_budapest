library("shiny")
library("ggplot2")
library("dplyr")

function(input, output) {
    
    filtered_birth_dt <- function() {
        message('filtered birth dt function has been called')
        filter(
            readRDS('cleaned_birth_data.rds'),
            year >= input$period[1] & year <= input$period[2]
        )
    }
    
    output$birth_dt <- renderDataTable(
        filtered_birth_dt()
    )
    
    output$birth_plot <- renderPlot({
        ggplot(filtered_birth_dt(), aes(x = age, y = num_birth, fill = education_level)) + 
            geom_col(position = 'dodge') + 
            facet_grid(year ~ country) + 
            theme(legend.position = 'bottom', legend.direction = 'vertical')
    })
}
