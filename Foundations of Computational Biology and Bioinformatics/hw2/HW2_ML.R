

## Setting up

library(klaR)
library(ROCR)
library(kernlab)
library(e1071)
library(rpart)

library(caret)
library(randomForest)


## Prediction functions
treepredict <- function(treemodel,dattrain){
    
    treeprediction <- predict(treemodel,dattrain[,-dim(dattrain)[2]],type='prob')
    score <- treeprediction[,'spam']
    #actual_class <- (dattrain$type=='spam')
    #pred <- prediction(score,actual_class)
    return(score)
}
    

nbpredict <- function(nbmodel,dattrain){
    
    nbprediction <- predict(nbmodel,dattrain[,-dim(dattrain)[2]],type='raw')
    score <- nbprediction[,'spam']
    #score <- nbprediction$posterior[,'spam']
    #actual_class <- (dattrain$type=='spam')
    #pred <- prediction(score,actual_class)
    return(score)
}

svmpredict <- function(svmmodel,dattrain){
    svmpredictroc <- predict(svmmodel,dattrain[,-dim(dattrain)[2]],
                             probability=TRUE)
    score <-attr(svmpredictroc, "probabilities")[,'spam']
    #actual_class <- (dattrain$type=='spam')
    #pred <- prediction(score,actual_class)
    return(score)
}

## Plot function

plotroc <- function(score,dattrain,modelname){
    actual_class <- (dattrain$type=='spam')
    pred <- prediction(score,actual_class)
    perf <- performance(pred,'tpr','fpr')
    auc <- performance(pred,'auc')
    auc <- unlist(slot(auc,'y.values'))
    plot(perf,colorize=TRUE)
    plottitle = paste('ROC for ',modelname,sep='')
    title(main = plottitle)
    legend(0.6,0.3,paste('AUC is', round(auc,6)),border="white",cex=1.0, box.col = "white")
}

## Combine function

ROCdirect <- function(spam,figurename){
    ## Data statistics
    totaldat <- dim(spam)[1]
    testindex <- sample(totaldat, size=floor(0.2*totaldat),replace = FALSE)
    
    ## Split dataset
    dattest <- spam[testindex,]
    dattrain <- spam[-testindex,]
    
    ## ML model training
    ## Decision tree
    treemodel <- rpart(type~., data=dattrain)
    plot(treemodel)
    text(treemodel, use.n=TRUE)
    ## Naive Bayes
    nbmodel <- e1071::naiveBayes(type~.,data = dattrain)
    ## SVM
    SVM_rad_model <- svm(type~., data=dattrain,probability=TRUE)
    SVM_sig_model <- svm(type~., data=dattrain,kernel='sigmoid',probability=TRUE)
    
    ## ML model testing
    treescore <- treepredict(treemodel,dattest)
    nbscore <- nbpredict(nbmodel,dattest)
    svmradscore <- svmpredict(svmmodel=SVM_rad_model,dattest)
    svmsigscore <- svmpredict(svmmodel=SVM_sig_model,dattest)
    
    ## ROC plot
    pdf(figurename)
    plotroc(treescore, dattest,'Decision Tree')
    plotroc(nbscore, dattest,'Naive Bayes')
    plotroc(svmradscore, dattest,'SVM-radial')
    plotroc(svmsigscore, dattest,'SVM-sigmoid')
    dev.off()
    
}

## Load dataset
set.seed(3)
data(spam)
## ML
ROCdirect(spam,'Figure1.pdf')



## 10-folds validation
crossval <- function(spam,foldsnumber,modelname){
    
    set.seed(7)
    pertubindex <- sample(dim(spam)[1])
    testnumber <- floor(length(pertubindex)/foldsnumber)
    
    for (i in 1:foldsnumber){
        testindex <- pertubindex[(testnumber*(i-1)+1):(testnumber*i)]
        dattest <- spam[testindex,]
        dattrain <- spam[-testindex,]
        
        testlabel <- (spam[testindex,'type']=='spam')
        
        if (modelname=='Decision Tree'){
            treemodel <- rpart(type~., data=dattrain)
            score <- treepredict(treemodel,dattest)
        }
        else if (modelname=='Naive Bayes'){
            nbmodel <- e1071::naiveBayes(type~.,data = dattrain)
            score <- nbpredict(nbmodel,dattest)
        }
        else if (modelname=='SVM-radial'){
            SVM_rad_model <- svm(type~., data=dattrain,probability=TRUE)
            score <- svmpredict(SVM_rad_model,dattest)
        }
        else if (modelname=='SVM-sigmoid'){
            SVM_sig_model <- svm(type~., data=dattrain,kernel='sigmoid',probability=TRUE)
            score <- svmpredict(SVM_sig_model,dattest)
        }
        
        if (i == 1){
            cvlabels <- list(testlabel)
            cvpredictions <- list(as.numeric(score))
        }
        else{
            cvlabels <- c(cvlabels,list(testlabel))
            cvpredictions <- c(cvpredictions,list(as.numeric(score)))
        }
        
    }
   
    xval <- c(list(cvlabels),list(cvpredictions))
    
    return(xval)
}

xvalroc <- function(xval,modelname){
    pred <- prediction(xval[[2]], xval[[1]])
    perf <- performance(pred,"tpr","fpr")
    auc <- performance(pred,'auc')
    auc <- mean(unlist(slot(auc,'y.values')))
    
    plot(perf,col="grey82",lty=3)
    plot(perf, lwd=3,avg="vertical",spread.estimate="boxplot",add=T)
    plottitle <- paste('ROC for ',modelname)
    title(main = plottitle)
    legend(0.4,0.3,paste('AUC is', round(auc,6)),border="white",cex=1.0, box.col = "white")
    
}


ROCcv <- function(spam,figurename){
    modellist <- c('Decision Tree','Naive Bayes','SVM-radial','SVM-sigmoid')
    pdf(figurename)
    for (modelname in modellist){
        xval <- crossval(spam,foldsnumber=10,modelname)
        xvalroc(xval,modelname)
    }
    dev.off()
}

set.seed(7)
data(spam)
ROCcv(spam,'Figure2.pdf')


## Feature selection
spam_cor <- cor(spam[,-dim(spam)[2]])
spam_cor_filter <- (abs(spam_cor)>=0.75)&(upper.tri(spam_cor))
filterindex <- which(spam_cor_filter)
highcorpair <- sapply(filterindex,function(indexsum){
    pair1index <- indexsum%/%dim(spam_cor)[2] + 1
    pair2index <- indexsum%%dim(spam_cor)[2]
    
    return(c(pair1index,pair2index))
})

selectindex <- sample(2,size = dim(highcorpair)[2],replace = TRUE)
dropindex <- sapply(1:dim(highcorpair)[2],function(colindex,highcorpair,selectindex){
    rowindex <- selectindex[colindex]
    dropindex <- highcorpair[rowindex,colindex]
},highcorpair=highcorpair,selectindex=selectindex)
dropindex <- dropindex[!duplicated(dropindex)]

spam_select <- spam[,-dropindex]
ROCdirect(spam_select,'Figure3.pdf')
ROCcv(spam_select,'Figure4.pdf')


## Feature selection 2
data(spam)
## Data statistics
totaldat <- dim(spam)[1]
testindex <- sample(totaldat, size=floor(0.2*totaldat),replace = FALSE)

## Split dataset
# dattest <- spam[testindex,]
# dattrain <- spam[-testindex,]
# 
# control <- rfeControl(functions = rfFuncs,
#                       method = "repeatedcv",
#                       repeats = 3,
#                       verbose = FALSE)
# outcomeName<-'type'
# predictors<-names(dattrain)[!names(dattrain) %in% outcomeName]
# spam_feature <- rfe(dattrain[,predictors],dattrain[,outcomeName],
#                     rfeControl = control)

#spam_feature 

selected_feature <- c('charExclamation', 'remove', 'free', 'capitalAve', 'hp')
spam_select <- spam[,c(selected_feature,'type')]
ROCdirect(spam_select,'Figure5.pdf')
ROCcv(spam_select,'Figure6.pdf')



