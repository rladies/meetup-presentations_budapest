library("shiny")

function(input, output) {
    output$birth_dt <- renderDataTable({
        readRDS('cleaned_birth_data.rds')
    })
}
