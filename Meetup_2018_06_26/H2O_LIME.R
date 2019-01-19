################################################################################
# Elso pelda: Diabetes
################################################################################

# Csomagok
  library(h2o) # ML
  library(lime) # interpretacio
  library(mlbench) # adatok


# Adatok
  data("PimaIndiansDiabetes")
  dim(PimaIndiansDiabetes)
  head(PimaIndiansDiabetes)


# Celvaltozo es magyarazovaltozok definialasa
  target <- "diabetes" 
  features <- setdiff(colnames(PimaIndiansDiabetes), target)
  print(features)


# H2O cluster 
  h2o.init() 
  #?h2o.init()  max_mem_size, nthreads, ...

# H2O dataframe
  h_diabetes <- as.h2o(PimaIndiansDiabetes)


# Tanito- es teszthalmaz letrehozasa
  n_seed=1234
  h_split <- h2o.splitFrame(h_diabetes, ratios = 0.75, seed = n_seed)
  h_train <- h_split[[1]] # 75% a tanulashoz
  h_test <- h_split[[2]] # 25% a kiertekeleshez


# H2O modell epitese - GBM
  model_gbm <- h2o.gbm(x = features,
                       y = target,
                       training_frame = h_train,
                       model_id = "my_gbm",
                       seed = n_seed)
  print(model_gbm)

# Kiertekelese
  h2o.performance(model_gbm, newdata = h_test)


# H2O modellek az AutoML segitsegevel
  model_automl <- h2o.automl(x = features,
                             y = target,
                             training_frame = h_train,
                             nfolds = 5,               # Keresztvalidacio
                             max_runtime_secs = 120,   # Max ido
                             max_models = 100,         # Max modell
                             stopping_metric = "AUC",  # Mire optimalizaljon
                             project_name = "my_automl_d",
                             exclude_algos = NULL,     # Ha ki akarsz zarni valamilyen algoritmust
                             seed = n_seed)




# AutoML ranglista es legjobb modell 
  head(model_automl@leaderboard,10)
  model_automl@leader


# Kiertekeles: GBM + legjobb AutoML
  h2o.auc(h2o.performance(model_gbm, newdata = h_test))
  h2o.auc(h2o.performance(model_automl@leader, newdata = h_test)) 


# Predikcio
  yhat_test <- h2o.predict(model_automl@leader, h_test)
  h2o.cbind(h_test, yhat_test)


# Modell mentese
  h2o.saveModel(object = model_automl@leader, 
                path = "./models/",
                force = TRUE)


# LIME - Magyarazo letrehozas
  explainer <- lime::lime(x = as.data.frame(h_train[, features]),
                          model = model_automl@leader)
  
  d_samp <- as.data.frame(h_test[3, features])
  # egy mintat veszunk (a 3-es kicserelheto barmelyik sorra)


# LIME - Magyarazat
  row.names(d_samp) <- "Minta 3"  # Nevadas a vizualizaciohoz
  explanations <- lime::explain(x = d_samp,
                                explainer = explainer,
                                feature_select = "auto",
                                n_labels = 1,    # binaris klasszifikacio - egy osztaly magyarazat
                                n_features = 8) # Top x tulajdonsag
  
  explanations <- 
    explanations[order(explanations$feature_weight, decreasing = TRUE),]
  
  print(explanations)
  
  
# Diagram
  lime::plot_features(explanations, ncol = 1)


# Masik pelda
  d_samp <- as.data.frame(h_test[1, features])
  row.names(d_samp) <- "Minta 1"  
  explanations <- lime::explain(x = d_samp,
                                explainer = explainer,
                                feature_select = "auto",
                                n_labels = 1,    # binaris klasszifikacio
                                n_features = 8) # Top x tulajdonsag
  explanations <- 
    explanations[order(explanations$feature_weight, decreasing = TRUE),]
  print(explanations)
  lime::plot_features(explanations, ncol = 1)


  
#Hoterkep
  d_samp <- as.data.frame(h_test[c(1,3), features])
  explanations <- lime::explain(x = d_samp,
                                explainer = explainer,
                                feature_select = "auto",
                                n_labels = 1,    
                                n_features = 8) 
  
  explanations <- 
    explanations[order(explanations$feature_weight, decreasing = TRUE),]
  plot_explanations(explanations)

  
#################################################################################
# Masodik pelda: Boston Housing
#################################################################################

# Csomagok
  library(h2o) # ML
  library(lime) # interpretacio
  library(mlbench) # adatok


# Adatok
  data("BostonHousing")
  dim(BostonHousing)
  head(BostonHousing)


# Celvaltozo es magyarazovaltozok definialasa
  target <- "medv" # median lakasar
  features <- setdiff(colnames(BostonHousing), target) 
  print(features)


#  H2O cluster
  h2o.init()
  #?h2o.init()  max_mem_size, nthreads, ...


# H2O dataframe
  h_boston <- as.h2o(BostonHousing)


# Tanito es teszthalmaz letrehozasa
  n_seed=1234
  h_split <- h2o.splitFrame(h_boston, ratios = 0.75, seed = n_seed)
  h_train <- h_split[[1]] # 75% a tanulashoz
  h_test <- h_split[[2]] # 25% a kiertekeleshez


# H2O modell epitese - GBM
  model_gbm <- h2o.gbm(x = features,
                     y = target,
                     training_frame = h_train,
                     model_id = "my_gbm",
                     seed = n_seed)

  
# Kiertekeles
  h2o.performance(model_gbm, newdata = h_test)


# H2O modellek az AutoML segitsegevel
  model_automl <- h2o.automl(x = features,
                           y = target,
                           training_frame = h_train,
                           nfolds = 5,               # Keresztvalidacio
                           max_runtime_secs = 120,   # Max ido
                           max_models = 100,         # Max modell
                           stopping_metric = "RMSE", # Mire optimalizaljon
                           project_name = "my_automl",
                           exclude_algos = NULL,     # Ha ki akarsz zarni valamilyen algoritmust 
                           seed = n_seed)


# AutoML ranglista es legjobb modell
  head(model_automl@leaderboard,10)
  model_automl@leader

  
# Kiertekeles: GBM + legjobb AutoML
  h2o.performance(model_gbm, newdata = h_test)
  h2o.performance(model_automl@leader, newdata = h_test) 
  # alacsonyabb RMSE = jobb


# Predikcio
  yhat_test <- h2o.predict(model_automl@leader, h_test)
  h2o.cbind(h_test, yhat_test)

# Modell mentese
  h2o.saveModel(object = model_automl@leader, 
              path = "./models/",
              force = TRUE)
  #h2o.loadModel()



# LIME - Magyarazo letrehozas
  explainer <- lime::lime(x = as.data.frame(h_train[, features]),
                        model = model_automl@leader)
  
  d_samp <- as.data.frame(h_test[27, features])
  # egy mintat veszunk (a 27-es kicserelheto barmelyik sorra)


# LIME - Magyarazat
  row.names(d_samp) <- "Minta 27"  # Nevadas a vizualizaciohoz
  explanations <- lime::explain(x = d_samp,
                              explainer = explainer,
                              feature_select = "auto",
                              n_features = 8) # Top x tulajdonsag
  
  explanations <- 
    explanations[order(explanations$feature_weight, decreasing = TRUE),]

  print(explanations)


# Diagram
  lime::plot_features(explanations, ncol = 1)


# Masik pelda
  d_samp <- as.data.frame(h_test[87, features])
  row.names(d_samp) <- "Minta 87"  
  explanations <- lime::explain(x = d_samp,
                                explainer = explainer,
                                feature_select = "auto",
                                n_features = 8) # Top x tulajdonsag
  explanations <- 
    explanations[order(explanations$feature_weight, decreasing = TRUE),]
  print(explanations)
  lime::plot_features(explanations, ncol = 1)
  
  
  
#Hoterkep
  d_samp <- as.data.frame(h_test[c(27,87), features])
  explanations <- lime::explain(x = d_samp,
                                explainer = explainer,
                                feature_select = "auto",
                                n_features = 8) 
  
  plot_explanations(explanations)
  

