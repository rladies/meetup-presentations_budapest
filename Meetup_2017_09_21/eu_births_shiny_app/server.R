library("shiny")
library("ggplot2")
library("dplyr")

function(input, output) {
    
    filterFromBelow <- reactive({
        message("filter from below called with ", input$period_lower)
        
        readRDS("cleaned_birth_data.rds") %>%
            filter(year >= input$period_lower)
    })
    
    getFilteredBirthDt <- reactive({
        message("filtered birth dt function has been called with ", input$period_upper)

        filterFromBelow() %>%
            filter(year <= input$period_upper)
    })
    
    output$birth_dt <- renderDataTable({
        getFilteredBirthDt()
    })
    
    output$birth_summary_plot <- renderPlot({
        getFilteredBirthDt() %>% 
            ggplot(aes(x = age, y = num_birth, fill = education_level)) + 
            geom_col(position = "dodge") + 
            facet_grid(year ~ country) + 
            theme(legend.position = "bottom", legend.direction = "vertical")
    })
    
}
