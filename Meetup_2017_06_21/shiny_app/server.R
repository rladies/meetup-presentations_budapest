library("shiny")
library("ggplot2")

function(input, output) {
    
    birth_dt <- readRDS('cleaned_birth_data.rds')
    
    output$birth_dt <- renderDataTable(
        birth_dt
    )
    
    output$birth_plot <- renderPlot(
        ggplot(birth_dt, aes(x = age, y = num_birth, fill = education_level)) + 
            geom_col(position = 'dodge') + 
            facet_grid(year ~ country) + 
            theme(legend.position = 'bottom', legend.direction = 'vertical')
    )
}
