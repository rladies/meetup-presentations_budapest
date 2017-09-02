## Steps for creating a simple shiny app to explore some data on births and mother's education in the EU.

The example used today is deployed [here](https://ildi-czeller.shinyapps.io/eu_births_shiny_app/).

[shiny cheatsheet](https://www.rstudio.com/wp-content/uploads/2016/01/shiny-cheatsheet.pdf)

### Prerequisites

required packages: shiny, ggplot2, dplyr (ggplot2 and dplyr is in tidyverse)
```
install.packages(c('shiny', 'ggplot2', 'dplyr'))
```

download these 3 files to a directory:
- `server.R`
- `ui.R`
- `cleaned_birth_data.rds`

To download `global.R` and `app.R` as well is optional.

To work in RStudio is highly recommended, but not necessary.

At any point to run your app, either press the green run App button in RStudio, or paste the following to your R console: `shiny::runApp(launch.browser = TRUE)`

### Step 1 - try minimal sample app

**Q**: Run your app, it already shows our raw data with interactive searching.

The ui part is about what type of components to show in what layout, and the server is about what to show.

### Step 2 - add summary plot

In `ui.R` add a new tab with title `birth summary` containing a `plotOutput` with id `birth_summary_plot`.

In `server.R` assign a call to `renderPlot` to `output$birth_summary_plot`. To generate the plot, put the following code inside the `renderPlot` function. Do not forget to add `library(ggplot2)` or `library(tidyverse)` to the beginning of your `server.R` file.

```
# server.R

ggplot(readRDS('cleaned_birth_data.rds'), aes(x = age, y = num_birth, fill = education_level)) + 
    geom_col(position = 'dodge') + 
    facet_grid(year ~ country) + 
    theme(legend.position = 'bottom', legend.direction = 'vertical')
```

It is crucial that the ids are the same in your ui and server:

```
# ui.R

plotOutput("whatever_id_you_type_in_here")

# server.R

output$whatever_id_you_type_in_here <- renderPlot(...)
```

### Optional step 3 - adjust layout

you can adjust the relative width of main elements, and also the absolute height of plots:

```
# ui.R

sidebarPanel(..., width = 2)
```

```
# ui.R

plotOutput(..., height = "600px")
```

**Q**: What is the default value of width for `sidebarPanel`, `mainPanel`, and for the height of `plotOutput`?

### Step 4 - filter data on period of years

Raw data contains data for years from 2007 to 2015. The user may want to focus on a narrower period, but want to change this period dynamically.

You can receive user input and use it on the server side with widgets. Examples are [here](https://shiny.rstudio.com/gallery/widget-gallery.html).

Let's use a slider range for filtering!

In `ui.R`, create your widget with params:

```
# ui.R

sliderInput(
    inputId = 'period', label = 'Period to show:',
    min = 2007, max = 2015, value = c(2007, 2015),
    sep = '', step = 1
)
```

You can use the current value of the slider at all times with `input$period`. This is a range slider, so its value is a vector of length 2. `input$period[1]` is the lower endpoint.

Use `dplyr::filter` inside your `renderPlot` function to keep data only within the selected period.

```
# server.R

filter(..., year >= input$period[1] & year <= ...)
```

I advise the use of the pipe, but it is optional.

Without pipe:

```
ggplot(filter(readRDS(...), ...), aes(...)) + 
    geom_col(...)
```
or
```
birth_dt <- readRDS(...)

filtered_dt <- filter(birth_dt, ...)

ggplot(filtered_dt, aes(...)) + 
    geom_col(...)
```

With pipe:

```
readRDS(...) %>%
    filter(year >= input$period[1] & ...) %>%
    ggplot(aes(...)) + 
    geom_col(...)
```

**Q**: Apply the same filtering in the call to `renderDataTable`.

### Step 5 - use reactive expressions

We now have a significant amount of repeated code - let's move this to a function!

This is within our server function, so no need to pass the `input$period` as parameter, it is available already.

```
# server.R

filtered_birth_dt <- function() {
    filter(
        readRDS('cleaned_birth_data.rds'),
        year >= input$period[1] & year <= input$period[2]
    )
}
```

Now use this function within `renderPlot` and `renderDataTable` as well.

To track how many times and with what parameters is this called, let's add a message inside:

```
# server.R

filtered_birth_dt <- function() {
    message('filtered birth dt function has been called with ', input$period)
    ...
}
```

**Q**: Run your app and verify that the function gets called twice upon every change of the slider.

Imagine this filtering was a somewhat more expensive calculation, or we have more plots using the same data. Then it is important to recalculate if and only if the values of the relevant input widgets change.

This is achieved with so called `reactive` expressions in `shiny`. You just have to define your function as a reactive expression and optimal recalculation and caching is automatically taken care of.

```
# server.R

filtered_birth_dt <- reactive({
    message('filtered birth dt function has been called with ', input$period)
    ...
})
```
**Q**: Run your app and verify that the function now gets called only once upon every change of the slider.

### Optional step 6 - use `global.R` for values available to ui and server as well

Now the endpoints of the period is hardcoded into `ui.R` (2007, 2015) although it comes from the raw data used. Let's read these values from the data in `ui.R`.

```
# ui.R

birth_dt <- readRDS("cleaned_birth_data.rds")
min_year <- min(birth_dt$year)
max_year <- max(birth_dt$year)

fluidPage(
    ...
)
```

```
sliderInput(
    inputId = 'period', label = 'Period to show:',
    min = min_year, max = max_year, value = c(min_year, max_year),
    sep = '', step = 1
)
```

Now `readRDS("cleaned_birth_data.rds")` is used in both `server.R` and `ui.R`. For similar precalculations, or settings default values you can use a file named `global.R`.

If there is a file named exactly `global.R` in your folder it will be run before server and ui so you can place these kind of pre calculations there.

```
# global.R

birth_dt <- readRDS("cleaned_birth_data.rds")
```

Delete this line from ui and server, use the available birth_dt instead.

### Optional step 7 - practice filtering based on user input

**Q**: Add the option of filtering for an arbitrary subset of countries.

Hints:

```
# ui.R

checkboxGroupInput(
    inputId = 'countries', label = "Countries to show:",
    choices = unique(...),
    selected = ...
),
```

```
# server.R

filter(
    readRDS('cleaned_birth_data.rds'),
    year >= input$period[1] & year <= input$period[2] &
        country %in% input$countries
)
```

**Q**: Notice that now that we use the same reactive expression for rendering the table and the plot as well, this new filter gets applied to both of them.

### Step 8 - control execution with action buttons

By default a recalculation will happen every time a value of any input widget changes. It means 4 recalculations if you decide you want to focus on only one country but have to uncheck 4 checkboxes one by one. This recalculation is quite fast with this amount of data but the rendering of the plot already takes up a noticable amount of time.

An action button is a special input widget which changes its value on startup and every time it is pressed.

So if it is included in a expression with the server that expression will recalculate every time you press the button.

However, if your calculation depends on other input values as well you want to stop recalculation if those values change but your user haven't pressed the action button yet. This can be achieved with `isolate`: Although it can contain input values, their change won't trigger a recalculation. But when you press the action button it will recalculate and use the current values of input widgets.

```
# ui.R

actionButton(inputId = 'recalculate_plot', label = 'Apply filters on plot!')
```

```
# server.R

output$birth_plot <- renderPlot({
    
    input$recalculate_plot
    
    isolate(
        ggplot(filtered_birth_dt(), aes(x = age, y = num_birth, fill = education_level)) + 
            geom_col(position = 'dodge') + 
            facet_grid(year ~ country) + 
            theme(legend.position = 'bottom', legend.direction = 'vertical')
    )
})
```

Now your renderPlot function encloses multiple expressions so don't forget to enclose them with `{}`.

**Q**: Notice that the table recalculated upon every filter change but the plot does not.

**Q**: What happens if you leave the call to `isolate` out?

**Q**: What can you use if you want to wait for the button press at the first time as well?

*Hint*: `eventReactive`

### Practice

**Q**: add a new tab with a plot on ratio of all births by education, regardless of mother's age.

*Hint*:

for aggregating you can use `dplyr::group_by` and `dplyr::summarise`:

```
filtered_birth_dt() %>% 
    group_by(year, country, education_level) %>% 
    summarise(num_birth = sum(num_birth))
```

For the plot you may use `geom_area(position = 'fill')`

**Q**: Put the summary table alongside of this plot and try different layouts: below, alongside.

*Hint*: two columns of width 6 make a 100% width:

```
tabPanel(
    title = "",
    column(
        6, plotOutput(...)
    ),
    column(
        6, dataTableOutput(...)
    )
)
```

**Q**: Add a new tab and a new user input widget to show min/max/avg/median of age by year, country, education level.

*Hint*: use `selectInput(..., choices = c('min', 'max', 'mean', 'median'))` to control the shown metric.
