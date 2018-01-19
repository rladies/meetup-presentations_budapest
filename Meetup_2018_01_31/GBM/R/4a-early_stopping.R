
library(lightgbm)
library(data.table)
library(ROCR)
library(ggplot2)


d <- as.data.frame(fread("../data/airline100K.csv"))

set.seed(123)
N <- nrow(d)
idx <- sample(1:N, 0.9*N)
d_train <- d[idx,]
d_test <- d[-idx,]
p <- ncol(d)-1


X <- Matrix::sparse.model.matrix(dep_delayed_15min ~ . - 1, data = d)
X_train <- X[idx,]
X_test <- X[-idx,]


p_subtrain <- 0.8    ## split for early stopping hold-out set
idx_subtrain   <- sample(1:nrow(d_train), nrow(d_train)*p_subtrain)
idx_earlystop  <- setdiff(1:nrow(d_train),idx_subtrain)

d_subtrain <- d_train[idx_subtrain,]
d_earlystop <- d_train[idx_earlystop,]

X_subtrain <- X_train[idx_subtrain,]
X_earlystop <- X_train[idx_earlystop,]

dlgb_subtrain  <- lgb.Dataset(data = X_subtrain,  label = ifelse(d_subtrain[,p+1]=="Y",1,0))
dlgb_earlystop <- lgb.Dataset(data = X_earlystop, label = ifelse(d_earlystop[,p+1]=="Y",1,0))


## early stopping:

system.time({
  md <- lgb.train(data = dlgb_subtrain, objective = "binary",
                  num_leaves = 512, learning_rate = 0.1,
                  nrounds = 10000, early_stopping_rounds = 10, valid = list(valid = dlgb_earlystop))
})

md$best_iter


phat <- predict(md, data = X_test)

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
performance(rocr_pred, "auc")@y.values[[1]]



## overfitting:

system.time({
  md <- lgb.train(data = dlgb_subtrain, objective = "binary",
                  num_leaves = 512, learning_rate = 0.1,
                  nrounds = 1000, valid = list(valid = dlgb_earlystop), metric = "auc",
                  record = TRUE, verbose = 0)
  
})

ggplot(data.frame(k=1:1000, auc=unlist(md$record_evals$valid$auc$eval))) +
  geom_line(aes(x=k, y=auc))


phat <- predict(md, data = X_test)

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
performance(rocr_pred, "auc")@y.values[[1]]
