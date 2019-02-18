#Generalized Linear Model

set.seed(23)
modelGlm<-train(CompressiveStrength ~ ., method="glm", data=training)

#http://topepo.github.io/caret/train-models-by-tag.html



predGlm_train <- predict(modelGlm, training)

tiff("Glm_train.tiff", width = 7, height = 7, units = 'in', res=300)
plot(training$CompressiveStrength, predGlm_train, ylim=c(0,80), xlim=c(0,80),
     main=paste("Generalized Linear Model predictions for train set \n R2 = ", 
                round(summary(lm(predGlm_train ~ training$CompressiveStrength))$r.squared, digits=3),
                "\n RMSE = ",
                round(RMSE(predGlm_train, training$CompressiveStrength),digits=3)))
abline(0,1, col="blue")
dev.off()



predGlm_test <- predict(modelGlm, testing)

tiff("Glm_test.tiff", width = 7, height = 7, units = 'in', res=300)
plot(testing$CompressiveStrength, predGlm_test, ylim=c(0,80), xlim=c(0,80),
     main=paste("Generalized Linear Model predictions for test set \n R2 = ", 
                round(summary(lm(predGlm_test~testing$CompressiveStrength))$r.squared, digits=3),
                "\n RMSE = ",
                round(RMSE(predGlm_test, testing$CompressiveStrength),digits=3)))
abline(0,1, col="blue")
dev.off()