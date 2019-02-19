#Gradient Boosting Machine

set.seed(23)
modelGbm<-train(CompressiveStrength ~ ., method="gbm", data=training)



predGbm_train <- predict(modelGbm, training)

tiff("Gbm_train.tiff", width = 7, height = 7, units = 'in', res=300)
plot(training$CompressiveStrength, predGbm_train, ylim=c(0,80), xlim=c(0,80),
     main=paste("Gradient Boosting Machine predictions for train set \n R2 = ", 
                round(summary(lm(predGbm_train ~ training$CompressiveStrength))$r.squared, digits=3),
                "\n RMSE = ",
                round(RMSE(predGbm_train, training$CompressiveStrength),digits=3)))
abline(0,1, col="blue")
dev.off()



predGbm_test <- predict(modelGbm, testing)

tiff("Gbm_test.tiff", width = 7, height = 7, units = 'in', res=300)
plot(testing$CompressiveStrength, predGbm_test, ylim=c(0,80), xlim=c(0,80),
     main=paste("Gradient Boosting Machine predictions for test set \n R2 = ", 
                round(summary(lm(predGbm_test ~ testing$CompressiveStrength))$r.squared, digits=3),
                "\n RMSE = ",
                round(RMSE(predGbm_test, testing$CompressiveStrength),digits=3)))
abline(0,1, col="blue")
dev.off()