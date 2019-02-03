%This code creates and tests all possible models of septic risk
clear all; close all


%%%%%
%initialize variables that will change in size
%memory inefficent but convenient
X_s = [];
X_n = [];

%import both clinical data and waveform data
clinical_data = load('clinical_data_training.mat');
waveform_data = load('waveform_data_training.mat');

%extract variables for data structures
Fn = waveform_data.Fn;%non-septic waveform data
IDn = waveform_data.IDn;%non-septic patient ID for each waveform time point
IDn_unique = unique(IDn); %list of non-septic patient ID numbers

Fs = waveform_data.Fs;%septic waveform data
IDs = waveform_data.IDs;%septic patient ID for each waveform time point
IDs_unique = unique(IDs); %list of septic patient ID numbers
%%%%

%%%%
%generate covariates for complex model
Ybasic = clinical_data.num(:,2);%patient's septic/non-septic status
Xbasic = clinical_data.num(:,3:5);%grabs some demographic data for model, Gender, Age, Respitory Comordities
IDbasic = clinical_data.num(:,1);%patient's ID numbers

%preparing a septic/non-septic vector for glmfit
%note all septic data will be first, followed by all non-septic data
Y_s = ones(length(IDs),1);
Y_n = zeros(length(IDn),1);

%create covariate matrix including both demographic info and waveform data
for k = 1:length(IDs_unique)%for septic data, looping through each patient
    %tile demographic data to length of patients waveform data
    X_s_demo_add = repmat(Xbasic(IDbasic==IDs_unique(k) & Ybasic,:),sum(IDs == IDs_unique(k)),1);
    %grab some waveform data
    %make sure the rows grabbed here match equivalent line in next for loop
    X_s_wave_add = Fs(:,IDs==IDs_unique(k))';
    X_s_add = [X_s_demo_add X_s_wave_add];%combine demographic and wave data
    X_s = [X_s;X_s_add];%add current patient to growing covariate matrix 
end

for k = 1:length(IDn_unique)%for non-septic data
    X_n_demo_add = repmat(Xbasic(IDbasic==IDn_unique(k)& ~Ybasic,:) ,sum(IDn == IDn_unique(k)),1);
    X_n_wave_add = Fn(:,IDn==IDn_unique(k))';
    X_n_add = [X_n_demo_add X_n_wave_add];
    X_n = [X_n;X_n_add]; 
end

% Making box plots of each feature (4:11)
label = {'HR','HRV','Resp','SPO2_mu','SPO2_var','PPGlow','PPGmid','PPghigh'};
% Sepsis
figure
boxplot(X_s(:,4:11),'Labels',label,'LabelOrientation','inline')
title('Boxplot of Sepsis Distributions')
ylabel('Values')

figure
boxplot(X_n(:,4:11),'Labels',label,'LabelOrientation','inline')
title('Boxplot of Non-Sepsis Distributions')
ylabel('Values')
%creates final matrix for glmfit
Y = [Y_s;Y_n];
X = [X_s;X_n];

% making matrix to store misclassification rate for each combination of
% coefficients
totalSSE = {};
%%
% running through all possible combination for best fit
numStaticPred = 3;
numPredictors = size(X,2);
numDynPred = numPredictors - numStaticPred;
indices = crossvalind('Kfold',Y,10);
for i = 1:numDynPred
    i
    combos = nchoosek((1:numDynPred)+numStaticPred,i);
    numCombos = size(combos,1);
    for j = 1:numCombos % selecting subset of predictor variables
        comboFocus = combos(j,:);
        Xfocus = X(:,[1:3,comboFocus]);
        
        SSE = 0;
        for k = 1:10
            test = (indices == i);
            train = ~test;
            Xtrain = Xfocus(train,:);
            Xtest = Xfocus(test,:);
            Ytrain = Y(train,:);
            Ytest = Y(test,:);
            
            [B,dev,stats] = glmfit(Xtrain,Ytrain,'binomial');
            Phat = 1./(1+exp(-[ones(size(Xtest,1),1) Xtest]*B));
            
            SSE = SSE + sum((Ytest - Phat).^2);
        end
        totalSSE = [totalSSE;{[1:3,comboFocus], SSE}];
    end
end

%%%%
% [B,dev,stats] = glmfit(X,Y,'binomial');%find model parameters 
% Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat
% [thresh] = test_performance(Phat, Y);
% xlim([0,1])

