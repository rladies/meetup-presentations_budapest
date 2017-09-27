## Homework assignments after shiny session 2016-09-21

Please send your solutions to czeildi@gmail.com till 28th October in order to get feedback.
 
If you did not fully follow the meetup, check the final code in the Meetup_2017_09_21/eu_births_shiny_app folder and run the app on your computer, play with it!

The example used at the meetup is deployed [here](https://ildi-czeller.shinyapps.io/eu_births_shiny_app/).

[shiny cheatsheet](https://www.rstudio.com/wp-content/uploads/2016/01/shiny-cheatsheet.pdf)

At any point to run your app, either press the green run App button in RStudio, or paste the following to your R console: `shiny::runApp(launch.browser = TRUE)`

### Questions (you may submit any subset to czeildi `at` gmail `pont` com):

- use a different `id` for the shown table. check if the app is still working

- use `tableOutput` and `renderTable` instead of `dataTableOutput` and `renderDataTable`. What is the difference?

- add a new completely empty tab with some title
 
- Show the current value of the period slider with a `textOutput` and `renderText`, in the `sidebarPanel`, below the slider.
 
- Add the option of filtering for an arbitrary subset of countries. (Hint: use `checkboxGroupInput`). [Reference here](https://shiny.rstudio.com/gallery/widget-gallery.html)
 
- Add a new tab with a plot on ratio of all births by education, regardless of mother's age. (Hint: for aggregating you can use `dplyr::group_by` and `dplyr::summarise`)

- Create an entirely new shiny app which uses a built-in dataset, e.g. diamonds. Show an arbitrary plot of your choice.
