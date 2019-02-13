#Get	the	spam	database	into	R	(install package kernlab)
library(kernlab)

#Split	into	a	training/test	set	of	80%	to	20%
data(spam) # spam dataset has 4601 email samples, 57 features, 2 types (SPAM and NONSPAM)
testidx <- which(1:length(spam[,1])%%5 == 0) 
spamtrain <- spam[-testidx,] #3680 samples (80% for training set)
spamtest <- spam[testidx,] #920 samples (20% for test set)

#Decision Tree
library(rpart)
model0 <- rpart(type~., data=spamtrain)
prediction0 <- predict(model0,spamtest, decision.values = TRUE, probability=TRUE)

#Use SVM	with	2	kernels	of your	choice
library(e1071)
model1 <- svm(type~.,data=spamtrain, kernel = "radial", probability = TRUE) #use radial kernel, untuned
prediction1 <- predict(model1,spamtest, decision.values = TRUE, probability=TRUE)

model2 <- svm(type~.,data=spamtrain, kernel = "linear", probability = TRUE) #use linear kernet, untuned
prediction2 <- predict(model2,spamtest, decision.values = TRUE, probability=TRUE)

#Naive Bayes
library(klaR)
model3 <- NaiveBayes(type~., data=spamtrain)
prediction3 <- predict(model3, spamtest[,-58], type= 'raw')

#Plot	ROC	curve	for	both	SVM	predictions	(Figure1.pdf)
#Report AUC for each on legend
library(ROCR)
pdf('Figure1.pdf')

# pred_scores0 <- predict(model0, type = "prob")[, 2]
pred_scores0 <- prediction0[,1]
pred0 <- prediction(pred_scores0, spamtest$type)
perf0 <- performance(pred0, "tpr", "fpr") 
perf0.auc <- performance(pred0,'auc')
auc0 <- perf0.auc@y.values
plot(perf0,  colorize=TRUE)
title("ROC for Tree Dicision prediction")
legend('center',legend=parse(text=sprintf('AUC == %s',auc0)))

pred_scores1 <- attr(prediction1, "probabilities")[,1]
pred1 <- prediction(pred_scores1, spamtest[,"type"])
perf1 <- performance(pred1, "tpr", "fpr") #plots TP rate on y-axis, FP rate on x-axis
perf1.auc <- performance(pred1,'auc')
auc1 <- perf1.auc@y.values
plot(perf1,  colorize=TRUE)
title("ROC for SVM prediction w/ Radial Kernel")
legend('center',legend=parse(text=sprintf('AUC == %s',auc1)))

pred_scores2 <- attr(prediction2, "probabilities")[,1]
pred2 <- prediction(pred_scores2, spamtest[,"type"])
perf2 <- performance(pred2, "tpr", "fpr")
perf2.auc <- performance(pred2,'auc')
auc2 <- perf2.auc@y.values
plot(perf2, colorize=TRUE)
title("ROC for SVM prediction w/ Linear Kernel")
legend('center',legend=parse(text=sprintf('AUC == %s',auc2)))

pred_scores3 <- prediction3$posterior[, c("spam")]
pred3 <- prediction(pred_scores3, spamtest[,"type"])
perf3 <- performance(pred3, "tpr", "fpr")
auc3 <- performance(pred3, "auc")
auc3 <- unlist(slot(auc3, "y.values"))
plot(perf3, colorize=TRUE)
title("ROC for Naive Bayes prediction ")
legend('center',legend=parse(text=sprintf('AUC == %s',auc3)))

dev.off()

