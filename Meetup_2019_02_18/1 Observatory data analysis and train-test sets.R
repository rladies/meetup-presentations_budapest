rm(list=ls())

library(caret)
library(randomForest)
library(AppliedPredictiveModeling)

data(concrete)

#ftp://cran.r-project.org/pub/R/web/packages/AppliedPredictiveModeling/AppliedPredictiveModeling.pdf



##Observatory data analysis

tiff("boxplot_1.tiff", width = 7, height = 7, units = 'in', res=300)
boxplot(mixtures[,1:7],  horizontal = F, las=2, main = "Materials in concretes", ylab = "Proportions [-]")
dev.off()

tiff("boxplot_2.tiff", width = 7, height = 7, units = 'in', res=300)
boxplot(mixtures[,8],  horizontal = F, main = "Age of concretes", ylab = "Age [days]")
dev.off()

tiff("boxplot_3.tiff", width = 7, height = 7, units = 'in', res=300)
boxplot(mixtures[,9],  horizontal = F, main = "Compressive strength of concretes", ylab = "Compressive strength [MPa]")
dev.off()



png("CSvsCement.png")
plot(mixtures$Cement, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Cement [-]")
dev.off()
png("CSvsBlastFurnaceSlag.png")
plot(mixtures$BlastFurnaceSlag, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Blast furnace slag [-]")
dev.off()
png("CSvsFlyAsh.png")
plot(mixtures$FlyAsh, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Fly ash [-]")
dev.off()
png("CSvsWater.png")
plot(mixtures$Water, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Water [-]")
dev.off()
png("CSvsSuperplasticizer.png")
plot(mixtures$Superplasticizer, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Superplasticizer [-]")
dev.off()
png("CSvsCoarseAggregate.png")
plot(mixtures$CoarseAggregate, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Coarse aggregate [-]")
dev.off()
png("CSvsFineAggregate.png")
plot(mixtures$FineAggregate, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Fine aggregate [-]")
dev.off()
png("CSvsAge.png")
plot(mixtures$Age, mixtures$CompressiveStrength, ylab = "Compressive strength [MPa]", xlab="Age [-]")
dev.off()



summary(mixtures)



##Machine learning - train and test set

set.seed(2000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 4/5)[[1]]
training = mixtures[inTrain,]
testing = mixtures[-inTrain,]