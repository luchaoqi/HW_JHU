%This code creates and tests a model of septic risk
clear all

%%%%%
%initialize variables that will change in size
%memory inefficent but convenient
X_s = [];
X_n = [];

%import both clinical data and waveform data to construct TRAINING MODEL
clinical_data = load('clinical_data_training.mat');
waveform_data = load('waveform_data_training.mat');

%extract variables for data structures
Fn = waveform_data.Fn;%non-septic waveform data
IDn = waveform_data.IDn;%non-septic pateint ID for each waveform time point
IDn_unique = unique(IDn); %list of non-septic patient ID numbers

Fs = waveform_data.Fs;%septic waveform data
IDs = waveform_data.IDs;%septic pateint ID for each waveform time point
IDs_unique = unique(IDs); %list of septic patient ID numbers
%%%%

%%%%
%generate covariates for model
Ybasic = clinical_data.num(:,2);%patient's septic/non-septic status
Xbasic = clinical_data.num(:, 3);%grabs some demographic data for model
IDbasic = clinical_data.num(:,1);%patient's ID numbers

%preparing a septic/non-septic vector for glmfit
%note all septic data will be first, followed by all non-septic data
Y_s = ones(length(IDs),1);
Y_n = zeros(length(IDn),1);

%create covariate matrix including both demographic info and waveform data
for k = 1:length(IDs_unique)%for septic data
    %tile demographic data to length of patients waveform data
    X_s_demo_add = repmat(Xbasic(IDbasic==IDs_unique(k) & Ybasic,:),sum(IDs == IDs_unique(k)),1);
    %grab some waveform data
    %make sure the rows grabbed here match equivalent line in next for loop
    X_s_wave_add = Fs([1:3],IDs==IDs_unique(k))';
    X_s_wave_add(:,[1:3]) = exp(X_s_wave_add(:,[1:3]));
    X_s_add = [X_s_demo_add X_s_wave_add];%combine demographic and wave data
    X_s = [X_s;X_s_add];%add current patient to growing covariate matrix 
end

for k = 1:length(IDn_unique)%for non-septic data
    X_n_demo_add = repmat(Xbasic(IDbasic==IDn_unique(k)& ~Ybasic,:) ,sum(IDn == IDn_unique(k)),1);
    X_n_wave_add = Fn([1:3],IDn==IDn_unique(k))';
    X_n_wave_add(:,[1:3]) = exp(X_n_wave_add(:,[1:3]));
    X_n_add = [X_n_demo_add X_n_wave_add];
    X_n = [X_n;X_n_add]; 
end

%creates final matrix for glmfit
Y = [Y_s;Y_n];
X = [X_s;X_n];
% Xcoeff = pca(X);
%%%%
[B,dev,stats] = glmfit(X,Y,'binomial');%find model parameters 
Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat
[thresh] = test_performance(Phat, Y);

%bring in testing data
clinical_data_t = load('clinical_data_testing.mat');
waveform_data_t = load('waveform_data_testing.mat');

%extract variables for data structures
Fn_t = waveform_data_t.Fn;%non-septic waveform data
IDn_t = waveform_data_t.IDn;%non-septic pateint ID for each waveform time point
IDn_unique_t = unique(IDn_t); %list of non-septic patient ID numbers

Fs_t = waveform_data_t.Fs;%septic waveform data
IDs_t = waveform_data_t.IDs;%septic pateint ID for each waveform time point
IDs_unique_t = unique(IDs_t); %list of septic patient ID numbers

%generate covariates for complex model
Ybasic_t = clinical_data_t.num(:,2);%patient's septic/non-septic status
Xbasic_t = clinical_data_t.num(:,3);%grabs some demographic data for model
IDbasic_t = clinical_data_t.num(:,1);%patient's ID numbers

%preparing a septic/non-septic vector for glmfit
%note all septic data will be first, followed by all non-septic data
Y_s_t = ones(length(IDs_t),1);
Y_n_t = zeros(length(IDn_t),1);

%initialize variables that will change in size
%memory inefficent but convenient
X_s_t = [];
X_n_t = [];

%create covariate matrix including both demographic info and waveform data
%for test data
for k = 1:length(IDs_unique_t)
    X_s_demo_add_t = repmat(Xbasic_t(IDbasic_t==IDs_unique_t(k) & Ybasic_t,:),sum(IDs_t == IDs_unique_t(k)),1);
     
    X_s_wave_add_t = Fs_t([1:3],IDs_t==IDs_unique_t(k))';
    X_s_wave_add_t(:,[1:3]) = exp(X_s_wave_add_t(:,[1:3]));
 
    X_s_add_t = [X_s_demo_add_t X_s_wave_add_t];%combine demographic and wave data
    X_s_t = [X_s_t;X_s_add_t];%add current patient to growing covariate matrix 
end

for k = 1:length(IDn_unique_t)
    X_n_demo_add_t = repmat(Xbasic_t(IDbasic_t==IDn_unique_t(k)& ~Ybasic_t,:) ,sum(IDn_t == IDn_unique_t(k)),1);
   
    X_n_wave_add_t = Fn_t([1:3],IDn_t==IDn_unique_t(k))';
    X_n_wave_add_t(:,[1:3]) = exp(X_n_wave_add_t(:,[1:3]));
     
    X_n_add_t = [X_n_demo_add_t X_n_wave_add_t];
    X_n_t = [X_n_t;X_n_add_t]; 
end

%creates final matrices FOR TEST MODEL
Y_test = [Y_s_t;Y_n_t];
X_test = [X_s_t;X_n_t];

%%%%%%%%COMPUTE TEST MODEL USING B FROM TRAINING MODEL
Phat_test = 1./(1+exp(-[ones(size(X_test,1),1) X_test]*B));

%YOU ADD YOUR CLASSIFIER HERE!!!! 
Y_test_bestguess = ????????????????

PercentCorrect = (1 - sum(abs(Y_test-Y_test_bestguess))/length(Y_test))*100


