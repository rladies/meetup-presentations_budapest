library("shiny")
library("ggplot2")

function(input, output) {
    
    output$birth_dt <- renderDataTable(
        readRDS('cleaned_birth_data.rds')
    )
    
    output$birth_plot <- renderPlot(
        ggplot(readRDS('cleaned_birth_data.rds'), aes(x = age, y = num_birth, fill = education_level)) + 
            geom_col(position = 'dodge') + 
            facet_grid(year ~ country) + 
            theme(legend.position = 'bottom', legend.direction = 'vertical')
    )
}
