## Homework assignments after shiny session 2016-06-21

Reminder: we proceeded until half of Step 5, last done step was "**Q**: Run your app and verify that the function gets called twice upon every change of the slider."

Our shiny app needed three files in the working directory: 
- `server.R`
- `ui.R`
- `cleaned_birth_data.rds`

If you submit your homework, please submit your `server.R` and `ui.R` files as well.  

### Questions (you may submit any subset):

- Show the current value of the period slider with a `textOutput` and `renderText`, in the `sidebarPanel`, below the slider.
- Add the option of filtering for an arbitrary subset of countries. (Hint: use `checkboxGroupInput`)
- Add a new tab with a plot on ratio of all births by education, regardless of mother's age. (Hint: for aggregating you can use `dplyr::group_by` and `dplyr::summarise`)
- Create an entirely new shiny app which uses a built-in dataset, e.g. diamonds. Show an arbitrary plot of your choice.
