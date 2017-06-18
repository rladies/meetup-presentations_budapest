library("shiny")
library("ggplot2")
library("dplyr")

function(input, output) {
    
    filtered_birth_dt <- reactive({
        filter(
            birth_dt,
            year >= input$period[1] & year <= input$period[2] &
                country %in% input$countries
        )
    })
    
    output$birth_dt <- renderDataTable(
        filtered_birth_dt()
    )
    
    output$birth_summary_plot <- renderPlot({
        
        input$recalculate_plot
        
        isolate(
            ggplot(filtered_birth_dt(), aes(x = age, y = num_birth, fill = education_level)) + 
                geom_col(position = 'dodge') + 
                facet_grid(year ~ country) + 
                theme(legend.position = 'bottom', legend.direction = 'vertical')
        )
    })
    
    output$births_by_education_plot <- renderPlot({
        input$recalculate_plot
        
        isolate({
            filtered_birth_dt() %>% 
                group_by(year, country, education_level) %>% 
                summarise(num_birth = sum(num_birth)) %>% 
                ggplot(aes(x = year, y = num_birth, fill = education_level)) + 
                geom_area(position = 'fill') + 
                scale_y_continuous(labels = scales::percent_format()) + 
                facet_grid(. ~ country) + 
                theme(legend.position = 'bottom', legend.direction = 'vertical')
        })
    })
}
