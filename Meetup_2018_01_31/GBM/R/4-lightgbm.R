
library(lightgbm)
library(data.table)
library(ROCR)


d <- fread("../data/airline100K.csv")

set.seed(123)
N <- nrow(d)
idx <- sample(1:N, 0.9*N)
d_train <- d[idx,]
d_test <- d[-idx,]


X <- Matrix::sparse.model.matrix(dep_delayed_15min ~ . - 1, data = d)
X_train <- X[idx,]
X_test <- X[-idx,]

## alternative/"better" encoding (vs 1-hot encoding) using `lgb.prepare_rules`
## see e.g here: https://github.com/szilard/GBM-perf/blob/master/run/3-lightgbm2.R

dlgb_train <- lgb.Dataset(data = X_train, label = ifelse(d_train$dep_delayed_15min=='Y',1,0))


## TRAIN
system.time({
  md <- lgb.train(data = dlgb_train, objective = "binary", 
                  nrounds = 100, num_leaves = 512, learning_rate = 0.1)
})
  
?lgb.train


## SCORE
phat <- predict(md, data = X_test)

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
performance(rocr_pred, "auc")@y.values[[1]]

