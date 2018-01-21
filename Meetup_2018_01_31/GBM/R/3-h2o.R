
library(h2o)

h2o.init()    ## starts h2o "server" (java) and connects to it from R


dx <- h2o.importFile("../data/airline100K.csv")     ## the data is on the server, not in R

dx_split <- h2o.splitFrame(dx, ratios = 0.9, seed = 123)   ## Warning: not same split as in gbm/xgboost
dx_train <- dx_split[[1]]
dx_test <- dx_split[[2]]

## no need e.g. for 1-hot encoding, h2o deals with it :)


## TRAIN
system.time({
  md <- h2o.gbm(x = 1:(ncol(dx)-1), y = "dep_delayed_15min", training_frame = dx_train, distribution = "bernoulli", 
                ntrees = 100, max_depth = 10, learn_rate = 0.1, 
                nbins = 100, seed = 123)    
})

?h2o.gbm   ## tons of params, early stopping etc.


## SCORE
## phat <- h2o.predict(md, dx_test)

h2o.auc(h2o.performance(md, dx_test))

md

## inspect in web UI (Flow):  http://localhost:54321

## can export model in POJO/MOJO for fast scoring from Java
## with "steam" one can build a real-time scoring web service (REST API)




