
% Eric Chiang, Jinriu Liu, Luchao Qi, Jack Wright, Yiyuan Zhang

%This code creates and tests a model of septic risk
clear all; close all;

clinical_data = load('clinical_data_training.mat');

Y = clinical_data.num(1:(end),2);

X = clinical_data.num(1:(end),[3 4 5]);

[B,dev,stats] = glmfit(X,Y,'binomial');

Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat
[threshold] = test_performance(Phat, Y);
xlim([0,1]);
SSE = sum((Y - Phat).^2)/numel(Y);

%%
clinical_data = load('clinical_data_testing.mat');

Y_test = clinical_data.num(1:(end-1),2);
X_test = clinical_data.num(1:(end-1),[3 4 5]);

Phat_test = 1./(1+exp(-[ones(size(X_test,1),1) X_test]*B)); %equivalent way to compute Phat
Phat_UB_test = 1./(1+exp(-[ones(size(X_test,1),1) X_test]*(B+1.96*stats.se)));
Phat_LB_test = 1./(1+exp(-[ones(size(X_test,1),1) X_test]*(B-1.96*stats.se)));
CIadd = Phat_UB_test-Phat_LB_test;

figure
plot(Phat_test)
hold on
plot(Phat_LB_test,'b-')
hold on
plot(Phat_UB_test,'b-')
hold on
plot(Y_test,'r*')    
title('Test:Models for Each Patient')

% [PhatPred,dlo,dhi] = glmval(B,X_test,'logit',stats,.90);
% scatter(Xplot,Phat_test);
% errorbar(Xplot,PhatPred, dlo, dhi, 'LineStyle','none');

%test performance of models
[threshold_test] = test_performance(Phat_test, Y_test);
xlim([0,1]);

Y_test_bestguess = (Phat_test >= 0.79);
PercentCorrect = (1 - sum(abs(Y_test-Y_test_bestguess))/length(Y_test))*100
