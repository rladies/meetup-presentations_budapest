#Random Forest

set.seed(23)
modelRf<-train(CompressiveStrength ~ ., method="rf", data=training, importance=TRUE)



predRf_train <- predict(modelRf, training)

tiff("Rf_train.tiff", width = 7, height = 7, units = 'in', res=300)
plot(training$CompressiveStrength, predRf_train, ylim=c(0,80), xlim=c(0,80),
     main=paste("Random Forest results - Train set \n R2 = ",
                round(summary(lm(predRf_train ~ training$CompressiveStrength))$r.squared,digits=3),
                "\n RMSE = ",
                round(RMSE(predRf_train, training$CompressiveStrength),digits=3)))
abline(0,1, col="blue")
dev.off()



predRf_test <- predict(modelRf, testing)

tiff("Rf_test.tiff", width = 7, height = 7, units = 'in', res=300)
plot(testing$CompressiveStrength, predRf_test, ylim=c(0,80), xlim=c(0,80),
     main=paste("Random Forest results - Test set \n R2 = ",
                round(summary(lm(predRf_test ~ testing$CompressiveStrength))$r.squared,digits=3),
                "\n RMSE = ",
                round(RMSE(predRf_test, testing$CompressiveStrength),digits=3)))
abline(0,1, col="blue")
dev.off()



tiff("Rf Importance of comp.tiff", width = 7, height = 7, units = 'in', res=300)
varImpPlot(modelRf$finalModel, sort = TRUE, type = 1, pch = 19, col = 1, main = "Importance of the individual principal components")
dev.off()

tiff("mtry.tiff", width = 7, height = 7, units = 'in', res=300)
plot(modelRf,main="Accuracy of Random Forest model by number of predictors",
     xlab = "Number of randomly selected predictors",
     ylab = "RMSE")
dev.off()