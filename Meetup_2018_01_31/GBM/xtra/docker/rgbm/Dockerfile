FROM rocker/rstudio

RUN apt-get update && \
    apt-get install -y default-jdk-headless libcurl4-gnutls-dev zlib1g-dev cmake && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN R CMD javareconf

## TODO: install binary packeges (r-cran-data.table...) from ppa
RUN MAKE="make -j4" install2.r -e data.table ggplot2 dplyr ROCR \
                  gbm xgboost h2o devtools

## TODO: instalGithub.r (needs subdir arg)
RUN R -e 'devtools::install_github("Microsoft/LightGBM", subdir = "R-package")'

