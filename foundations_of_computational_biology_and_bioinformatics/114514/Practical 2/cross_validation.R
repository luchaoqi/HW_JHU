#Perform 10-fold cross-validation on one of the SVM predictions
library(kernlab)
library(e1071)
library(ROCR)

data(spam)
#Split spam data into 10 equally sized part
folds <- rep(1:10,len=nrow(spam))
testScore <- list()
testLabel <- list()
for (j in 1:10){
  testidx <- which(folds == j)
  testGroup <- spam[testidx,]
  trainGroup <- spam[-testidx,]
  model1 <- svm(type~.,data=testGroup, kernel = "radial", probability = TRUE) #use the radial kernel model
  predictions <- predict(model1,testGroup, decision.values = TRUE, probability=TRUE)
  pred_scores <- attr(predictions, "probabilities")[,1]
  testLabel[j] <- list(testGroup[,"type"])
  testScore[j] <- list(pred_scores)
}

#Plot ROC curves for each cross-validation fold and corresponding predictions
#With average ROC curve and box plot
pdf('Figure2.pdf')
pred <- prediction(testScore, testLabel)
perf <- performance(pred,"tpr","fpr")
perf.auc <- performance(pred,"auc")
auc <- perf.auc@y.values
plot(perf,col="grey82",lty=3)
plot(perf, lwd=3,avg="vertical",spread.estimate="boxplot",add=T)
title("ROC for 10-fold cross-validation on radial kernal SVM prediction")
legend('center',legend=parse(text=sprintf("AUC==%s",auc)))

dev.off()
