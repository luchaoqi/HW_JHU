% Eric Chiang, Jinriu Liu, Luchao Qi, Jack Wright, Yiyuan Zhang

clear all
%import clinical data - this is the basis of the simple mode

clinical_data = load('clinical_data_training.mat');

%generate simple glm

%define Y = observations which should be loaded from clinical table
Y = clinical_data.num(:,2);

%define X = covariate matrix by taking features from clinical table and
%waveform table. This currently only uses Gender as a covariate.
X = clinical_data.num(:,[3 4 5]);


%compute glm
[B,dev,stats] = glmfit(X,Y,'binomial');
save('GLM_1.mat','B');

%construct phat from parameters and X 
Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat

%plot phat versus patient along with its confidence bounds (1.96*stats.se);
Phat_UB = 1./(1+exp(-[ones(size(X,1),1) X]*(B+1.96*stats.se)));
Phat_LB = 1./(1+exp(-[ones(size(X,1),1) X]*(B-1.96*stats.se)));
 
figure
plot(Phat)
hold on
plot(Phat_LB,'b-')
hold on
plot(Phat_UB,'b-')
hold on
plot(Y,'r*')    
title('Models for Each Patient')

SSE = sum((Y - Phat).^2)/numel(Y);

% %plot error bar
% [PhatPred,dlo,dhi] = glmval(B,X,'logit',stats,.90);
% 
% figure
% Xplot = 1:numel(Phat);
% scatter(Xplot,Phat);
% hold on
% errorbar(Xplot,PhatPred, dlo, dhi, 'LineStyle','none');
% plot(Y,'r*')
% hold off
% xlabel('Patients')
% ylabel('Errors')
% title('Training: Models for Each Patient')


%test performance of models
[threshold] = test_performance(Phat, Y);
xlim([0,1]);
%CI
CI_Phat = [Phat-Phat_LB, Phat+Phat_UB];
CI_ai = [B-1.71.*stats.se, B+1.71*stats.se];