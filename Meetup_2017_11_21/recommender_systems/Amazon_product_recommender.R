setwd("...")  ## set your working directory

#for data munging
library(data.table)
library(plyr)
library(reshape2)
library(magrittr)
#for visualization
library(ggplot2)
#for recommendations
library(recommenderlab)

############################################################################################################################################
########                                               EXPLORING THE DATA                                                      #############
############################################################################################################################################

ratings  <- fread("ratings_5u_5i_8463.csv")  ## dataset of ratings users gave for amazon products
metadata <- fread("metadata.csv")            ## metadata for itemID

ratings<- merge(x = ratings, y = metadata, by = "itemID", all.x = T )

## total number of users:
ratings$userID %>%
  unique() %>%
  length()

## total number of items
ratings$itemID %>%
  unique() %>%
  length()

## how many items each user rated

ratings<- ratings[, user_freq:= .N, by = "userID"]
qplot(ratings$user_freq) + ggtitle("Distribution of the frequency of ratings per user")

## how many times each item was rated

ratings<- ratings[, item_freq:= .N, by = "itemID"]
qplot(ratings$item_freq) + ggtitle("Distribution of ratings per item")

## check distribution of the ratings
qplot(ratings$rating) + ggtitle("Distribution of the ratings")


## check 10 most popular items

## here I define popularity score as number of ratings >3 for each item
ratings<- ratings[, item_popularity:=sum(rating>=3), by = "itemID"]

setorder(ratings, -item_popularity)
most_popular_items<- unique(ratings, by = 'itemID')[1:10, c("item_popularity", "title", "brand", "imUrl")]

## browse url for each of the most_popular_items
for (i in 1:nrow(most_popular_items)){
  browseURL(most_popular_items$imUrl[i])
}


#changing a user name to a proper name

ratings[userID == "A3MBDM1YTB0VDI", userID:= "Alice"]

############################################################################################################################################
########                                               PREPARING THE DATASET                                                   #############
############################################################################################################################################

## reshaping the data to usesr-item format using dcast() from "reshape2" package
df<- reshape2::dcast(ratings, userID~itemID, value.var = "rating")
rownames(df) <- df[,1]
df2 <- df[,-1]

## convert to matrix format
ratingMatrix<- as.matrix(df2)

## convert matrix to realRatingMatrix format required by recommenderlab, using as() to convert it to desired Class
product_ratings <- as(object = ratingMatrix, Class = "realRatingMatrix")

## check availbale methods for class
methods(class = class(product_ratings))

dim(product_ratings)
slotNames(product_ratings)
## In order to perform custom data exploration, we might need to access these slots.
## ## !!! to access the slots of S4 objects use @

## let's check the rating values
vector_ratings <- as.vector(product_ratings@data)
unique(vector_ratings) ## zeroes are automatically assigned to missing values

## Visualizing the matrix
p <- ggplot(ratings, aes(x=itemID,  y=userID)) + 
  geom_tile(aes(fill=as.factor(rating))) + 
  scale_fill_brewer(type = "seq", palette=2, guide_legend(title = "rating")) +
  theme_bw(base_size = 20) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
p

image(product_ratings[1:50, 1:50], main = "Heatmap of the raw rating matrix")

##############################################################################
## Transformation of the rating matrix: Normalize, Binarize        
##############################################################################

## You can normalize the ratings matrix using normalize()
product_ratings_normalized <- normalize(product_ratings, method = "center")

hist(getRatings(product_ratings_normalized))
## vs. the original
hist(getRatings(product_ratings))

## Can also turn the matrix into a 0-1 binary matrix
## setting all ratings larger or equal to the argument minRating as 1 and all others to 0.
product_ratings_binary <- binarize(product_ratings, minRating=1)  


############################################################################################################################################
########                                          ITEM-BASED COLLABORATIVE FILTERING                                           #############
############################################################################################################################################

############################################################################################################################################
## The core algorithm is based on these steps:
##  1)  For each two items, measure how similar they are in terms of having received similar ratings by similar users
##  2)  For each item, identify the k-most similar items
##  3)  For each user, identify the items that are most similar to the user's purchases
############################################################################################################################################

###################################################################################
## The function to build models is Recommender() and it takes the following inputs:
##   Data: This is the training set
##   Method: This is the name of the technique
##   Parameters: These are some optional parameters of the technique
###################################################################################

## Recommender uses the registry mechanism from package registry to manage methods.
## to see available methods use get_entry_names()
recommenderRegistry$get_entry_names() 

## to see methods for "realRatingMatrix" and their parameters
recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")    

## to see parameters for a given method:
recommender_models$IBCF_realRatingMatrix$parameters
###################################################################################
## Parameters for IBCF model: 
##   k - number of most similar items for algorithm to identify and store
##   method -  the similarity function (cosine, pearson, )
###################################################################################

set.seed(100)  ## for reproductible results

## build the model using Recommender()

recc_ibcf_model <- Recommender(data = product_ratings,
                               method = "IBCF", 
                               parameter = list(k = 20, method = "pearson"))



## use getModel() to get the details of the model
model_details <- getModel(recc_ibcf_model)  ## same as recc_ibcf_model@model
model_details$description

## dimension of the item-item similarity matrix. This matrix contains top k (here k = 20) similar items for each item
dim(model_details$sim) ##sparse matrix



##############################################################################
## use the model to make recommendations for a user using predict()       
##############################################################################

## A3MBDM1YTB0VDI - Alice

## actual products Alice bought
items_Alice_rated<- ratings[userID == "Alice", c("rating","title", "brand", "imUrl")]
items_Alice_rated
## images of those products
for (i in 1:nrow(items_Alice_rated)){
  browseURL(items_Alice_rated$imUrl[i])
}


## recommended top 10 items for Alice
recommended_items_Alice <- predict(recc_ibcf_model, product_ratings["Alice",], type = "topNList", n=10)
## convert topNList into list using as() to convert it to desired Class
items_Alice<- as(object = recommended_items_Alice, Class ="list")

## get metadata for items we recommended
items_Alice_recc<- metadata[itemID %in% items_Alice[[1]]  , c("title", "brand", "imUrl")]
items_Alice_recc

## show them in browser
for (i in 1:nrow(items_Alice_recc)){
  browseURL(items_Alice_recc$imUrl[i])
}


############################################################################################################################################
########                                        EVALUATING RECOMMENDER'S PERFORMANCE                                           #############
############################################################################################################################################


##############################################################################
## create Evaluation Scheme     
##############################################################################

## Parameters for evaluationScheme:
##  method    : evaluation method to use (e.g.  cross-validation, split)
##  k         : number of folds/times to run the evaluation
##  goodRating: threshold at which ratings are considered good for evaluation
##  given     : for each user x randomly chosen items are given to the recommender algorithm to generate recommendations. 
##              The remaining items will be used to test the model accuracy.
##              It's better that this parameter is lower than the minimum number of items purchased by any user 
##              so that we don't have users without items to test the models:

min(rowCounts(product_ratings))
items_to_keep <- 4 ## value for given

n_fold <- 4 ## number of folds for cross-validation

## create an evaluation scheme
eval_sets     <- evaluationScheme(data = product_ratings, method = "cross-validation", k = n_fold, goodRating = 3, given = items_to_keep)

##  create of recommender model based on ibcf method using Recommender()
recc_ibcf <- Recommender(data = getData(eval_sets, "train"), method = "IBCF", parameter = list(k = 20, method = "pearson"))



##############################################################################
## evaluating the ratings using calcPredictionAccuracy()      
##############################################################################

## making prediction using the model
items_to_recommend <- 5
eval_prediction    <- predict(object = recc_ibcf, newdata = getData(eval_sets, "known"), n = items_to_recommend, type = "ratings") 

## use calcPredictionAccuracy() to evaluate the ratings

eval_accuracy <- calcPredictionAccuracy(x = eval_prediction, data = getData(eval_sets, "unknown"), byUser = FALSE)
eval_accuracy


##############################################################################
## evaluating the recommendation using evaluate()      
##############################################################################

## use evaluate() to evaluate the results when trying to recommend different number of items (3 to 15) 
results <- evaluate(x = eval_sets, method = "IBCF", n = seq(2, 10, 2))

## to get confusion matrix
head(getConfusionMatrix(results)[[1]])

## to get the same ConfusionMatrix
avg(results)

######################################################################################################
## True Positives (TP):  These are recommended items that have been purchased
## False Positives (FP): These are recommended items that haven't been purchased
## False Negatives(FN):  These are not recommended items that have been purchased
## True Negatives (TN):  These are not recommended items that haven't been purchased
######################################################################################################


plot(results, annotate = TRUE, main = "ROC curve")



############################################################################################################################################
########                                          CHOOSING BETWEEN DIFFERENT MODELS                                            #############
############################################################################################################################################

## evaluate between IBCF and UBCF and a random model

models_to_evaluate <- list(IBCF_cos = list(name = "IBCF", param = list(method = "cosine")),
                           IBCF_pearson = list(name = "IBCF", param = list(method = "pearson")),
                           UBCF_cos = list(name = "UBCF", param = list(method = "cosine")),
                           random = list(name = "RANDOM", param=NULL))

## setting names of the models
n_recommendations <- c(1, seq(2, 20, 2))

## Evaluate the above models
list_results <- evaluate(x = eval_sets, method = models_to_evaluate, n = n_recommendations)

avg_matrices <- lapply(list_results, avg)

plot(list_results, annotate = 1, legend = "topleft") 
title("ROC curve")

######################################################################################################
## Evaluate which k (number of most similar items kept in similarity matrix) 
## gives the highest accuracy
######################################################################################################

## vector of k to choose from
vector_k <- c(5, 10, 15, 20)

## build the model using each k
models_to_evaluate <- lapply(vector_k, function(k){
                      list(name = "IBCF", param = list(method = "pearson", k = k))
                      })
## setting names of the models
names(models_to_evaluate) <- paste0("IBCF_k_", vector_k
                                    )
## Evaluate the above models
n_recommendations <- c(1, seq(2, 20, 2))
list_results <- evaluate(x = eval_sets, method = models_to_evaluate, n = n_recommendations)


plot(list_results, annotate = 1,      legend = "topleft") 
title("ROC curve")
