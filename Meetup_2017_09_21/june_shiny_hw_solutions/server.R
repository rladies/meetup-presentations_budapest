library("shiny")
library("ggplot2")
library("dplyr")

function(input, output) {
    
    getFilteredBirthDt <- function() {
        message("filtered birth dt function has been called with ", input$period)
        
        readRDS("cleaned_birth_data.rds") %>%
            filter(year >= input$period[1] & year <= input$period[2] & 
                       country %in% input$countries)
    }
    
    output$period_value <- renderText({
        paste(
            "current lower limit: ", input$period[1],
            "current upper limit: ", input$period[2]
        )
    })
    
    output$birth_dt <- renderDataTable(
        getFilteredBirthDt()
    )
    
    output$birth_summary_plot <- renderPlot({
        getFilteredBirthDt() %>% 
            ggplot(aes(x = age, y = num_birth, fill = education_level)) + 
            geom_col(position = "dodge") + 
            facet_grid(year ~ country) + 
            theme(legend.position = "bottom", legend.direction = "vertical")
    })
    
    output$births_by_education_plot <- renderPlot({
        getFilteredBirthDt() %>% 
            group_by(country, education_level) %>% 
            summarise(num_birth = sum(num_birth)) %>% 
            ggplot(aes(x = country, y = num_birth, fill = education_level)) + 
            geom_col(position = position_fill(reverse = TRUE)) + 
            theme(legend.position = "bottom", legend.direction = "vertical")
    })
    
}
