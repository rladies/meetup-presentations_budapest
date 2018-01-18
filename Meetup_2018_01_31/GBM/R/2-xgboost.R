
library(xgboost)
library(data.table)
library(ROCR)
library(ggplot2)


d <- fread("../data/airline100K.csv") 
head(d)


set.seed(123)
N <- nrow(d)
idx <- sample(1:N, 0.9*N)  
d_train <- d[idx,]
d_test <- d[-idx,]

X <- Matrix::sparse.model.matrix(dep_delayed_15min ~ . - 1, data = d)   
## 1-hot encoding + sparse 
## needs to be done *together* (train+test) for alignment (otherwise error for new cats at scoring)
## still problem in live scoring scenarios
X[1:10,1:10]
X_train <- X[idx,]
X_test <- X[-idx,]

dxgb_train <- xgb.DMatrix(data = X_train, label = ifelse(d_train$dep_delayed_15min=='Y',1,0))
## special optimized data structure


## TRAIN
system.time({
  md <- xgb.train(data = dxgb_train, objective = "binary:logistic", 
           nround = 100, max_depth = 10, eta = 0.1)
})

?xgb.train  


## SCORE
phat <- predict(md, newdata = X_test)
hist(phat)

table(ifelse(phat>0.5,1,0), d_test$dep_delayed_15min)

rocr_pred <- prediction(phat, d_test$dep_delayed_15min)
plot(performance(rocr_pred, measure = "tpr", x.measure = "fpr"), colorize = TRUE)
performance(rocr_pred, "auc")@y.values[[1]]

table(ifelse(phat>0.7,1,0), d_test$dep_delayed_15min)
table(ifelse(phat>0.6,1,0), d_test$dep_delayed_15min)
table(ifelse(phat>0.5,1,0), d_test$dep_delayed_15min)

ggplot(data.frame(phat=phat, y=d_test$dep_delayed_15min)) + geom_density(aes(x=phat, color=as.character(y)))

