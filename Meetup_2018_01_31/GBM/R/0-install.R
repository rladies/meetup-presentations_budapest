
## pre-req:
install.packages("data.table")
install.packages("ggplot2")
install.packages("ROCR")


install.packages("gbm")

install.packages("xgboost")

install.packages("h2o")   ## needs Java

install.packages("devtools")
devtools::install_github("Microsoft/LightGBM", subdir = "R-package")       ## needs cmake
## install info:  https://github.com/Microsoft/LightGBM/tree/master/R-package
## (easy on Linux)


## xgboost and lightgbm also have GPU versions
## install: https://github.com/szilard/GBM-perf/blob/master/install.txt
## performance: https://github.com/szilard/GBM-perf#gbm-performance

