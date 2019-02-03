clear all; clc; close all;
% Group 2, Eric Chiang, Jinrui Liu, Luchao Qi, Yiyuan Zhang, Jack Wright

% README: 
% This code is the driver for the assignment. Please add the 
% PhysioToolkitCardiacOutput_MatlabCode folder to the path before running.
% This code will save read in data as .mat files in order to reduce run
% time for subsequent runs of the code.
%
% In addition, please include the following files in the SAME DIRECTORY AS
% THE DRIVER in order for the driver to run properly
% s00020-2567-03-30-17-47_ABP.txt
% s00020-2567-  03-30-17-47n.txt
% s00708-2868-08-02-12-43_ABP.txt
% s00708-2868-08-02-12-43n.txt
% s04784-3070-06-27-12-49_ABP.txt
% s04784-3070-06-27-12-49n.txt
% loadABPData.m
% drawABP.m
% importFullData.m
% drawFig4SubPlot.m
% parlikarEstimator.m
% TPREstimatorV2.m

%% Question 1
% loading in data
ABP20 = loadABPData('s00020-2567-03-30-17-47_ABP.txt', 'Patient20ABP.mat');
if isstring(ABP20)
    return
end
% ABP_20 is the ABP data of Patient 20

% setting start and end times for specific data
startTime1 = 10 * 60 * 60;
endTime1 = startTime1 + 16;
startTime2 = 11 * 60 * 60;
endTime2 = startTime2 + 16;

% indexing ABP data with times
[~, startIndex] = min(abs(ABP20(:,1)-startTime1));
[~, endIndex] = min(abs(ABP20(:,1)-endTime1));
ABP20_1 = ABP20(startIndex:endIndex,:);

[~, startIndex] = min(abs(ABP20(:,1)-startTime2));
[~, endIndex] = min(abs(ABP20(:,1)-endTime2));
ABP20_2 = ABP20(startIndex:endIndex,:);

% runnign wabp
onsettimes1 = wabp(ABP20_1(:,2));
onsettimes2 = wabp(ABP20_2(:,2));

% running abpfeature
features1 = abpfeature(ABP20_1(:,2),onsettimes1);
features2 = abpfeature(ABP20_2(:,2),onsettimes2);

% Draw figure of ABP pulses with features starting at hour 10
titleName = "20 ABP Pulses from Patient 20 Starting at Hour 10";
drawABP(ABP20_1, onsettimes1, features1, titleName)

% Draw figure of ABP pulses with features starting at hour 11
titleName = "20 ABP Pulses from Patient 20 Starting at Hour 11";
drawABP(ABP20_2, onsettimes2, features2, titleName)


%% Question 2
clearvars -except ABP20
% This first part reads in the file and saves the relevant data as a .mat
% file. If the .mat file already exists in the directory, it doesn't run.
% Please include s00708-2868-08-02-12-43_ABP.txt in current directory. Also
% include s04784-3070-06-27-12-49_ABP.txt in the current directory

ABP708 = loadABPData('s00708-2868-08-02-12-43_ABP.txt','Patient708ABP.mat');
ABP4784 = loadABPData('s04784-3070-06-27-12-49_ABP.txt','Patient4784ABP.mat');

if isstring(ABP708) || isstring(ABP4784)
    return % couldn't find file
end

% ABP708 is the ABP data of patient 708, ABP4784 is the ABP data of patient 4784

% setting start and end times for specific data
startTime = 10 * 60 * 60;
endTime = startTime + 16;

% indexing ABP data with times
[~, startIndex] = min(abs(ABP708(:,1)-startTime));
[~, endIndex] = min(abs(ABP708(:,1)-endTime));
ABP708_1 = ABP708(startIndex:endIndex,:);

[~, startIndex] = min(abs(ABP4784(:,1)-startTime));
[~, endIndex] = min(abs(ABP4784(:,1)-endTime));
ABP4784_1 = ABP4784(startIndex:endIndex,:);

% runnign wabp
onsettimes708 = wabp(ABP708_1(:,2));
onsettimes4784 = wabp(ABP4784_1(:,2));

% running abpfeature
features708 = abpfeature(ABP708_1(:,2),onsettimes708);
features4784 = abpfeature(ABP4784_1(:,2),onsettimes4784);

% Draw figure of ABP pulses for patient 708
titleName = 'ABP Pulses from Patient 708 Starting at Hour 10';
drawABP(ABP708_1, onsettimes708, features708, titleName)

% Draw figure of ABP pulses with features for Patient 4784
titleName = 'ABP Pulses from Patient 4784 Starting at Hour 10';
drawABP(ABP4784_1, onsettimes4784, features4784, titleName)


%% Question 3
clearvars -except ABP20 ABP708 ABP4784

% Reading in the full set of data for Patient 20
fullData20 = importFullData('s00020-2567-03-30-17-47n.txt','Patient20Full.mat');
if isstring(fullData20)
    return
end

% indexing ABP data to what we need (first 12 hours)
starttime = 0;
endtime = starttime + (12*60*60);
[~, startIndex] = min(abs(ABP20(:,1)-starttime));
[~, endIndex] = min(abs(ABP20(:,1)-endtime));
ABP20_focus = ABP20(startIndex:endIndex,:);
ABP20_focus = ABP20_focus(:,2);

% runnign wabp
onsettimes = wabp(ABP20_focus);
% running abpfeature
features = abpfeature(ABP20_focus,onsettimes);
% running jSQI
[beatQ, ~] = jSQI(features, onsettimes, ABP20_focus);

% running estimateCO_v3
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,5,0);

time = fullData20.Elapsedtime;
[~, endIndex] = min(abs(time-endtime));
co_measured = fullData20.CO(1:endIndex); % segmenting data that we need (first 12 hours) from full patient data

% calibrating CO found from CO estimator
co_indices = find(co_measured); % represents indices of full data set where CO was measured
r = co_measured(co_indices(1)); % represents the first measured CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time in order to find CO estimate that corresponds to this
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient20.Liljestrand = co_calibrated;

% plotting everything to be like Figure 4 of paper
titleName = 'Output of Liljestrand Algo for Patient 20';
drawFig4SubPlot(to,co_calibrated,co_indices,fullData20,onsettimes,features,titleName)
hold off

% Data Analysis
Patient20Error.RawCOTrue = [];
Patient20Error.RawCOLiljestrand = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient20Error.RawCOTrue = [Patient20Error.RawCOTrue, co_measured(co_indices(i))];
    Patient20Error.RawCOLiljestrand = [Patient20Error.RawCOLiljestrand, CO_focus];
end
Patient20Error.Liljestrand = CO_Error;

%% Question 4/5/6, Patient 20 Herd, Windkessel, Parlikar Algorithm w/ TPR
% We now compare algorithms for Patient 20
% We use the Herd estimator and the Windkessel 1st order LTI RC circuit model

windowSize = 5; % TUNE THIS VARIABLE

% running estimateCO_v3 and calibrating CO using Herd Estimator
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,6,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient20.Herd = co_calibrated;

% Data Analysis
Patient20Error.RawCOHerd = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient20Error.RawCOHerd = [Patient20Error.RawCOHerd, CO_focus];
end
Patient20Error.Herd = CO_Error;

% running estimateCO_v3 and calibrating CO using Windkessel Estimator
[co, to, told, fea] = estimateCO_v3(onsettimes,features,beatQ,2,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;

Patient20.Windkessel = co_calibrated;

% Data Analysis
CO_Error = zeros(numel(co_indices), 1);
Patient20Error.RawCOWindkessel = [];
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient20Error.RawCOWindkessel = [Patient20Error.RawCOWindkessel, CO_focus];
end
Patient20Error.Windkessel = CO_Error;

% Parlikar Algorithm
[co, to, ~, ~] = parlikarEstimator(onsettimes,ABP20_focus,features,beatQ,windowSize,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient20.Parlikar = co_calibrated;

% Data Analysis
CO_Error = zeros(numel(co_indices), 1);
Patient20Error.RawCOParlikar = [];
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient20Error.RawCOParlikar = [Patient20Error.RawCOParlikar, CO_focus];
end
Patient20Error.Parlikar = CO_Error;

% plotting everything to be like Figure 4 of paper
titleName = 'Output of Parlikar Algo for Patient 20';
drawFig4SubPlot(to,co_calibrated,co_indices,fullData20,onsettimes,features,titleName)
hold off

% Finding TPR of patient 20 and plotting
% [TPR, to, ~, ~] = TPREstimator(onsettimes,ABP20_focus,features,beatQ,k,windowSize,0);
[TPR, to, ~,~] = TPREstimatorV2(onsettimes, features, ABP20_focus, beatQ, k, co_calibrated, 0);
figure
TPR = TPR * (60/1000);
plot(TPR);
ylabel('TPR (mmHg/(mm/sec))')
title('TPR vs. Time (Patient 20)')

%% Question 4/5, Patient 708 Liljestrand, Herd, Windkessel, Parlikar, TPR
% Reading in the full set of data for Patient 708
fullData708 = importFullData('s00708-2868-08-02-12-43n.txt','Patient708Full.mat');
if isstring(fullData708)
    return
end

% indexing ABP data to what we need (first 12 hours)
starttime = 0;
endtime = starttime + (12*60*60);
[~, startIndex] = min(abs(ABP708(:,1)-starttime));
[~, endIndex] = min(abs(ABP708(:,1)-endtime));
ABP708_focus = ABP708(startIndex:endIndex,:);
ABP708_focus = ABP708_focus(:,2);

% runnign wabp
onsettimes = wabp(ABP708_focus);
% running abpfeature
features = abpfeature(ABP708_focus,onsettimes);
% running jSQI
[beatQ, ~] = jSQI(features, onsettimes, ABP708_focus);

% running estimateCO_v3
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,5,0);

time = fullData708.Elapsedtime;
[~, endIndex] = min(abs(time-endtime));
co_measured = fullData708.CO(1:endIndex); % segmenting data that we need (first 12 hours) from full patient data

% calibrating CO found from CO estimator
co_indices = find(co_measured); % represents indices of full data set where CO was measured
r = co_measured(co_indices(1)); % represents the first measured CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time in order to find CO estimate that corresponds to this
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient708.Liljestrand = co_calibrated;

% Data Analysis
Patient708Error.RawCOTrue = [];
Patient708Error.RawCOLiljestrand = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient708Error.RawCOTrue = [Patient708Error.RawCOTrue, co_measured(co_indices(i))];
    Patient708Error.RawCOLiljestrand = [Patient708Error.RawCOLiljestrand, CO_focus];
end
Patient708Error.Liljestrand = CO_Error;

% running estimateCO_v3 and calibrating CO using Herd Estimator
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,6,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient708.Herd = co_calibrated;

% Data Analysis
Patient708Error.RawCOHerd = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient708Error.RawCOHerd = [Patient708Error.RawCOHerd,CO_focus];
end
Patient708Error.Herd = CO_Error;

% running estimateCO_v3 and calibrating CO using Windkessel Estimator
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,2,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient708.Windkessel = co_calibrated;

% Data Analysis
Patient708Error.RawCOWindkessel = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient708Error.RawCOWindkessel = [Patient708Error.RawCOWindkessel, CO_focus];
end
Patient708Error.Windkessel = CO_Error;

% Parlikar Algorithm
[co, to, ~, ~] = parlikarEstimator(onsettimes,ABP708_focus,features,beatQ,windowSize,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient708.Parlikar = co_calibrated;

% Data Analysis
Patient708Error.RawCOParlikar = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient708Error.RawCOParlikar = [Patient708Error.RawCOParlikar, CO_focus];
end
Patient708Error.Parlikar = CO_Error;

% Finding TPR of patient 708 and plotting
[TPR, to, ~,~] = TPREstimatorV2(onsettimes, features, ABP708_focus, beatQ, k, co_calibrated, 0);
figure
TPR = TPR * (60/1000);
plot(TPR);
ylabel('TPR (mmHg/(mm/sec))')
title('TPR vs. Time (Patient 708)')


%% Question 4/5, Patient 4784 Liljestrand, Herd, Windkessel, Parlikar
% Reading in the full set of data for Patient 4784
fullData4784 = importFullData('s04784-3070-06-27-12-49n.txt','Patient4784Full.mat');
if isstring(fullData4784)
    return
end

% indexing ABP data to what we need (first 12 hours)
starttime = 0;
endtime = starttime + (12*60*60);
[~, startIndex] = min(abs(ABP4784(:,1)-starttime));
[~, endIndex] = min(abs(ABP4784(:,1)-endtime));
ABP4784_focus = ABP4784(startIndex:endIndex,:);
ABP4784_focus = ABP4784_focus(:,2);

% runnign wabp
onsettimes = wabp(ABP4784_focus);
% running abpfeature
features = abpfeature(ABP4784_focus,onsettimes);
% running jSQI
[beatQ, ~] = jSQI(features, onsettimes, ABP4784_focus);

% running estimateCO_v3
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,5,0);

time = fullData4784.Elapsedtime;
[~, endIndex] = min(abs(time-endtime));
co_measured = fullData4784.CO(1:endIndex); % segmenting data that we need (first 12 hours) from full patient data

% calibrating CO found from CO estimator
co_indices = find(co_measured); % represents indices of full data set where CO was measured
r = co_measured(co_indices(1)); % represents the first measured CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time in order to find CO estimate that corresponds to this
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient4784.Liljestrand = co_calibrated;

% Data Analysis
Patient4784Error.RawCOTrue = [];
Patient4784Error.RawCOLiljestrand = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient4784Error.RawCOTrue = [Patient4784Error.RawCOTrue, co_measured(co_indices(i))];
    Patient4784Error.RawCOLiljestrand = [Patient4784Error.RawCOLiljestrand, CO_focus];    
end
Patient4784Error.Liljestrand = CO_Error;

% running estimateCO_v3 and calibrating CO using Herd Estimator
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,6,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient4784.Herd = co_calibrated;

% Data Analysis
Patient4784Error.RawCOHerd = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient4784Error.RawCOHerd = [Patient4784Error.RawCOHerd, CO_focus];
end
Patient4784Error.Herd = CO_Error;

% running estimateCO_v3 and calibrating CO using Windkessel Estimator
[co, to, ~, ~] = estimateCO_v3(onsettimes,features,beatQ,2,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient4784.Windkessel = co_calibrated;

% Data Analysis
Patient4784Error.RawCOWindkessel = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient4784Error.RawCOWindkessel = [Patient4784Error.RawCOWindkessel, CO_focus];
end
Patient4784Error.Windkessel = CO_Error;

% Parlikar Algorithm
[co, to, ~, ~] = parlikarEstimator(onsettimes,ABP4784_focus,features,beatQ,windowSize,0);

% calibrating CO
time_focus = (time(co_indices(1)))/60; % need to find index of TO that corresponds to this time
[~, coIndex] = min(abs(to-time_focus));
x = co(coIndex);
k = r/x;
co_calibrated = k*co;
Patient4784.Parlikar = co_calibrated;

% Data Analysis
Patient4784Error.RawCOParlikar = [];
CO_Error = zeros(numel(co_indices), 1);
for i = 1:numel(co_indices)
    time_focus = (time(co_indices(i)))/60;
    [~, coIndex] = min(abs(to-time_focus));
    CO_focus = co_calibrated(coIndex);
    
    CO_Error(i) = co_measured(co_indices(i)) - CO_focus;
    Patient4784Error.RawCOParlikar = [Patient4784Error.RawCOParlikar, CO_focus];
end
Patient4784Error.Parlikar = CO_Error;

% Finding TPR of patient 4784 and plotting
[TPR, to, ~,~] = TPREstimatorV2(onsettimes, features, ABP4784_focus, beatQ, k, co_calibrated, 0);
figure
TPR = TPR * (60/1000);
plot(TPR);
ylabel('TPR (mmHg/(mm/sec))')
title('TPR vs. Time (Patient 4784)')

%% Formatting Errors
LiljestrandError = [Patient20Error.Liljestrand(2:end); Patient708Error.Liljestrand(2:end); Patient4784Error.Liljestrand(2:end)];
HerdError = [Patient20Error.Herd(2:end); Patient708Error.Herd(2:end); Patient4784Error.Herd(2:end)];
WindkesselError = [Patient20Error.Windkessel(2:end); Patient708Error.Windkessel(2:end); Patient4784Error.Windkessel(2:end)];
ParlikarError = [Patient20Error.Parlikar(2:end); Patient708Error.Parlikar(2:end); Patient4784Error.Parlikar(2:end)];