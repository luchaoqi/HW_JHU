#Perform 10-fold cross-validation on one of the SVM predictions
library(kernlab)
library(e1071)
library(ROCR)
library(rpart)

data(spam)
#Split spam data into 10 equally sized part
folds <- rep(1:10,len=nrow(spam))
testScore1 <- list()
testLabel1 <- list()
testScore2 <- list()
testLabel2 <- list()
testScore3 <- list()
testLabel3 <- list()

for (j in 1:10){
  testidx1 <- which(folds == j)
  testGroup1 <- spam[testidx1,]
  trainGroup1 <- spam[-testidx1,]
  model1 <- svm(type~.,data=testGroup1, kernel = "radial", probability = TRUE) 
  predictions1 <- predict(model1,testGroup1, decision.values = TRUE, probability=TRUE)
  pred_scores1 <- attr(predictions1, "probabilities")[,1]
  testLabel1[j] <- list(testGroup1[,"type"])
  testScore1[j] <- list(pred_scores1)
}

for (j in 1:10){
  testidx2 <- which(folds == j)
  testGroup2 <- spam[testidx2,]
  trainGroup2 <- spam[-testidx2,]
  model2 <- svm(type~.,data=testGroup2, kernel = "linear", probability = TRUE) 
  predictions2 <- predict(model2,testGroup2, decision.values = TRUE, probability=TRUE)
  pred_scores2 <- attr(predictions2, "probabilities")[,1]
  testLabel2[j] <- list(testGroup2[,"type"])
  testScore2[j] <- list(pred_scores2)
}


for (j in 1:10){
  testidx3 <- which(folds == j)
  testGroup3 <- spam[testidx3,]
  trainGroup3 <- spam[-testidx3,]
  model3 <- rpart(type~.,data=testGroup3)
  predictions3 <- predict(model3, type = "prob")
  pred_scores3 <- predictions3[,2]
  testLabel3[j] <- list(testGroup3[,"type"])
  testScore3[j] <- list(pred_scores3)
}


#Plot ROC curves for each cross-validation fold and corresponding predictions
#With average ROC curve and box plot
pdf('Figure2.pdf')

#radial
pred1 <- prediction(testScore1, testLabel1)
perf1 <- performance(pred1,"tpr","fpr")
perf.auc1 <- performance(pred1,"auc")
auc1 <- perf.auc1@y.values
plot(perf1,col="grey82",lty=3)
plot(perf1, lwd=3,avg="vertical",spread.estimate="boxplot",add=T)
title("ROC for 10-fold cross-validation on radial kernal SVM prediction")
legend('center',legend=parse(text=sprintf("AUC==%s",auc1)))

#linear
pred2 <- prediction(testScore2, testLabel2)
perf2 <- performance(pred2,"tpr","fpr")
perf.auc2 <- performance(pred2,"auc")
auc2 <- perf.auc2@y.values
plot(perf2,col="grey82",lty=3)
plot(perf2, lwd=3,avg="vertical",spread.estimate="boxplot",add=T)
title("ROC for 10-fold cross-validation on linear kernal SVM prediction")
legend('center',legend=parse(text=sprintf("AUC==%s",auc2)))

#Decision Tree

pred3<- prediction(testScore3, testLabel3)
perf3 <- performance(pred3,"tpr","fpr")
perf.auc3 <- performance(pred3,"auc")
auc3 <- perf.auc3@y.values
plot(perf3,col="grey82",lty=3)
plot(perf3, lwd=3,avg="vertical",spread.estimate="boxplot",add=T)
title("ROC for 10-fold cross-validation on decision tree prediction")
legend('center',legend=parse(text=sprintf("AUC==%s",auc3)))

dev.off()

