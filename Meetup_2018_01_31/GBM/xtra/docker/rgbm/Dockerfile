FROM rocker/rstudio

RUN apt-get update && \
  apt-get install -y default-jdk-headless libcurl4-gnutls-dev zlib1g-dev cmake && \
  rm -rf /var/lib/apt/lists/*

RUN R CMD javareconf

RUN R -e 'install.packages(c("data.table","ggplot2","dplyr","ROCR"), repos="https://cran.rstudio.com/")'
RUN R -e 'install.packages(c("gbm","xgboost","h2o","devtools"), repos="https://cran.rstudio.com/")'
RUN R -e 'devtools::install_github("Microsoft/LightGBM", subdir = "R-package")'

