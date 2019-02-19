% Eric Chiang, Jinriu Liu, Luchao Qi, Jack Wright, Yiyuan Zhang

%This code creates and tests a model of septic risk
clear all

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
    X_s_wave_add = Fs([1,3,6,7],IDs==IDs_unique(k))';
    X_s_add = [X_s_demo_add X_s_wave_add];%combine demographic and wave data
    X_s = [X_s;X_s_add];%add current patient to growing covariate matrix 
end

for k = 1:length(IDn_unique)%for non-septic data
    X_n_demo_add = repmat(Xbasic(IDbasic==IDn_unique(k)& ~Ybasic,:) ,sum(IDn == IDn_unique(k)),1);
    X_n_wave_add = Fn([1,3,6,7],IDn==IDn_unique(k))';
    X_n_add = [X_n_demo_add X_n_wave_add];
    X_n = [X_n;X_n_add]; 
end

%creates final matrix for glmfit
Y = [Y_s;Y_n];
X = [X_s;X_n];
%%%%
[B,dev,stats] = glmfit(X,Y,'binomial');%find model parameters 
Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat
[thresh] = test_performance(Phat, Y);
xlim([0,1])

% Finding confidence intervals for parameters
df = stats.dfe;
SE = stats.se;
CI.add = tinv(0.95,df) * SE;
CI.lower = B - CI.add;
CI.upper = B + CI.add;

