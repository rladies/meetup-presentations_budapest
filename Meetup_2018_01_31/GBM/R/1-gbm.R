
library(gbm)
library(data.table)
library(ROCR)
library(ggplot2)


d <- fread("../data/airline100K.csv", stringsAsFactors=TRUE)    ## this gbm-pkg needs factors
head(d)
d$dep_delayed_15min <- ifelse(d$dep_delayed_15min=="Y",1,0)     ## this gbm-pkg needs 0/1 target

table(d$dep_delayed_15min)
## slightly unbalanced


set.seed(123)
N <- nrow(d)
idx <- sample(1:N, 0.9*N)    ## 10K enough for test here, for smaller N maybe 60-40 split
d_train <- d[idx,]
d_test <- d[-idx,]
## could use cross-validation
## in practice maybe time separated train-test / might have slightly different distribution


## TRAIN/fit/model
system.time({
  md <- gbm(dep_delayed_15min ~ ., data = d_train, distribution = "bernoulli",
          n.trees = 100, interaction.depth = 10, shrinkage = 0.1)
})
## may take a long time on larger datasets

?gbm   ## arguments

md

## SCORE/predict/evaluate/test
phat <- predict(md, d_test, n.trees = 100, type="response") 
hist(phat)

table(ifelse(phat>0.5,1,0), d_test$dep_delayed_15min) 

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
plot(performance(rocr_pred, measure = "tpr", x.measure = "fpr"), colorize = TRUE)
performance(rocr_pred, "auc")@y.values[[1]]

table(ifelse(phat>0.7,1,0), d_test$dep_delayed_15min)
table(ifelse(phat>0.6,1,0), d_test$dep_delayed_15min)
table(ifelse(phat>0.5,1,0), d_test$dep_delayed_15min)

ggplot(data.frame(phat=phat, y=d_test$dep_delayed_15min)) + geom_density(aes(x=phat, color=as.character(y)))


gbm.perf(md, plot.it = TRUE)


system.time({
  md <- gbm(dep_delayed_15min ~ ., data = d_train, distribution = "bernoulli",
            n.trees = 100, interaction.depth = 10, shrinkage = 0.1,
            cv.folds = 5)
})
gbm.perf(md, plot.it = TRUE)
## ~ early stopping
n_trees_opt <- gbm.perf(md, plot.it = FALSE)
n_trees_opt

phat <- predict(md, d_test, n.trees = n_trees_opt, type="response") 

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
performance(rocr_pred, "auc")@y.values[[1]]


