%% Part 2

% QUESTION
% Implement the TPM in Matlab using the parameter values noted in the
% legend of Fig. 4 of Bock et al. To demonstrate your model code is
% correct, use your model to reproduce both panels of Fig. 4. Your figures
% should be clearly labeled with legends. You must turn in your code and it
% should generate this plot when the script is run.

% What are the units of all state variables and model parameters?

% What did you use for your state variable initial conditions?

% What are the units of time that are appropriate based on you answer
% above?

% Explain exactly how you implemented an insulin bolus and a meal in your
% simulations (i.e. how did you choose the amplitude and duration of each)?

% The top panel of Fig. 4 is meant to show that it is difficult to identify
% the insulin parameters when a meal and an insulin bolus are taken
% together. Explain why this is the case. Use your model code to show
% example simulations where insulin is taken after a meal, and where
% insulin is taken before a meal. Are the effects of insulin boluses and
% meals on blood glucose simply additive? Explain why this behavior is or
% is not expected. You should provide the output plots from your Matlab
% code as well as your answers to the above questions in a single pdf
% document. Add this document and your Matlab code into your zip file.

% PARAMETERS
% a_x = 0.04
% a_g = 0.03
% K_g/K_x (= I2C) = 0.1
% K_x chosen according to legend (Plot 1: B-20, R-10; Plot 2: B-20, R-10)
% Plots show BG Conc. (mg/dl) vs. Time of day
% Insulin Bolus = 2U
% Meal = 20g

%% Initial Setup
clear all; close all; clc;
U_CHO = 20;
U_I = 2;

% time from model pertubation to end is 6:00 - 19:00
tspan = [0, (19-6)*60]; % time span used for ODE
t_interp = 0:(19-6)*60; % time steps used for interpolation (every minute)
t_init = 0:(3*60)-1; % initial time before perturbation is 3 hours, -1 bc of weird array issue

% Setting Up Initial States
G_init = ones(1,numel(t_init)) * 90;

%% Insulin and Carbohydrates Taken Simultaneously @ 6 AM
% solving models
y0 = [90, 0, 0, 0, 0,U_CHO, U_I];
[t_20,y_20] = ode45(@TPM_20, tspan, y0); % Model with K_x = 20
[t_10,y_10] = ode45(@TPM_10, tspan, y0); % Model with K_x = 20

% interpolation for plotting
G_20 = interp1(t_20,y_20(:,1),t_interp); % interpolated per minute
G_10 = interp1(t_10,y_10(:,1),t_interp); % interpolated per minute

% concatenating and plotting models
t = 0:(19-3)*60;
G_20_fin = [G_init, G_20];
G_10_fin = [G_init, G_10];

figure
plot(t,G_20_fin);
hold on
grid on
plot(t,G_10_fin);
hold off
legend('K_x = 20','K_x = 10','Location','southeast');
ylim([45,95])
xlim([0,t(end)])
xlabel('Time of Day')
ylabel('BG Concentration (mg/dl)')
title('BG Concentration with Simultaneous Meal and Bolus')

% changing xtick numbers to times
pos = 180:180:900;
names = {'6:00'; '9:00'; '12:00'; '15:00'; '18:00'};
set(gca,'xtick',pos,'xticklabel',names)

%% Only Insulin @ 6 AM
% solving models
y0 = [90, 0, 0, 0, 0, 0, U_I];
[t_20,y_20] = ode45(@TPM_20, tspan, y0); % Model with K_x = 20
[t_10,y_10] = ode45(@TPM_10, tspan, y0); % Model with K_x = 20

% interpolation for plotting
G_20 = interp1(t_20,y_20(:,1),t_interp); % interpolated per minute
G_10 = interp1(t_10,y_10(:,1),t_interp); % interpolated per minute

% concatenating and plotting models
G_20_fin = [G_init, G_20];
G_10_fin = [G_init, G_10];

figure
plot(t,G_20_fin);
hold on
grid on
plot(t,G_10_fin);
hold off
legend('K_x = 20','K_x = 10','Location','northeast');
ylim([45,95])
xlim([0,t(end)])
xlabel('Time of Day')
ylabel('BG Concentration (mg/dl)')
title('BG Concentration with Only Insulin Bolus')

% changing xtick numbers to times
pos = 180:180:900;
names = {'6:00'; '9:00'; '12:00'; '15:00'; '18:00'};
set(gca,'xtick',pos,'xticklabel',names)

%% Insulin Time Delay Before Meal
timeDelay = 180;

tspan_before = [0,timeDelay];
tspan_after = [0, (19-6)*60-timeDelay];
t_interp_before = 0:timeDelay;
t_interp_after = 0:(19-6)*60-timeDelay;

% solving models after insulin
y0 = [90, 0, 0, 0, 0, 0, U_I];
[t_20_before,y_20_before] = ode45(@TPM_20, tspan_before, y0); % Model with K_x = 20
[t_10_before,y_10_before] = ode45(@TPM_10, tspan_before, y0); % Model with K_x = 20

% interpolation for plotting
G_20_before = interp1(t_20_before,y_20_before(:,1),t_interp_before); % interpolated per minute
G_10_before = interp1(t_10_before,y_10_before(:,1),t_interp_before); % interpolated per minute

%solving models after meal
y_20_0 = y_20_before(end,:); y_20_0(6) = U_CHO;
y_10_0 = y_10_before(end,:); y_10_0(6) = U_CHO;
[t_20_after,y_20_after] = ode45(@TPM_20, tspan_after, y_20_0); % Model with K_x = 20
[t_10_after,y_10_after] = ode45(@TPM_10, tspan_after, y_10_0); % Model with K_x = 20

% interpolation for plotting
G_20_after = interp1(t_20_after,y_20_after(:,1),t_interp_after); % interpolated per minute
G_10_after = interp1(t_10_after,y_10_after(:,1),t_interp_after); % interpolated per minute

G_20 = [G_20_before(1:end-1), G_20_after];
G_10 = [G_10_before(1:end-1), G_10_after];

% concatenating and plotting models
G_20_fin = [G_init, G_20];
G_10_fin = [G_init, G_10];

figure
plot(t,G_20_fin);
hold on
grid on
plot(t,G_10_fin);
hold off
legend('K_x = 20','K_x = 10','Location','southeast');
ylim([45,95])
xlim([0,t(end)])
xlabel('Time of Day')
ylabel('BG Concentration (mg/dl)')
title(sprintf('BG Concentration with Meal %d Minutes after Insulin Bolus',timeDelay))

% changing xtick numbers to times
pos = 180:180:900;
names = {'6:00'; '9:00'; '12:00'; '15:00'; '18:00'};
set(gca,'xtick',pos,'xticklabel',names)

%% Insulin Time Delay After Meal
tspan_before = [0,timeDelay];
tspan_after = [0, (19-6)*60-timeDelay];
t_interp_before = 0:timeDelay;
t_interp_after = 0:(19-6)*60-timeDelay;

% solving models after meal
y0 = [90, 0, 0, 0, 0, U_CHO, 0];
[t_20_before,y_20_before] = ode45(@TPM_20, tspan_before, y0); % Model with K_x = 20
[t_10_before,y_10_before] = ode45(@TPM_10, tspan_before, y0); % Model with K_x = 20

% interpolation for plotting
G_20_before = interp1(t_20_before,y_20_before(:,1),t_interp_before); % interpolated per minute
G_10_before = interp1(t_10_before,y_10_before(:,1),t_interp_before); % interpolated per minute

%solving models after insulin
y_20_0 = y_20_before(end,:); y_20_0(7) = U_I;
y_10_0 = y_10_before(end,:); y_10_0(7) = U_I;
[t_20_after,y_20_after] = ode45(@TPM_20, tspan_after, y_20_0); % Model with K_x = 20
[t_10_after,y_10_after] = ode45(@TPM_10, tspan_after, y_10_0); % Model with K_x = 20

% interpolation for plotting
G_20_after = interp1(t_20_after,y_20_after(:,1),t_interp_after); % interpolated per minute
G_10_after = interp1(t_10_after,y_10_after(:,1),t_interp_after); % interpolated per minute

G_20 = [G_20_before(1:end-1), G_20_after];
G_10 = [G_10_before(1:end-1), G_10_after];

% concatenating and plotting models
G_20_fin = [G_init, G_20];
G_10_fin = [G_init, G_10];

figure
plot(t,G_20_fin);
hold on
grid on
plot(t,G_10_fin);
hold off
legend('K_x = 20','K_x = 10','Location','northeast');
ylim([45,140])
xlim([0,t(end)])
xlabel('Time of Day')
ylabel('BG Concentration (mg/dl)')
title(sprintf('BG Concentration with Meal %d Minutes Before Insulin Bolus',timeDelay))

% changing xtick numbers to times
pos = 180:180:900;
names = {'6:00'; '9:00'; '12:00'; '15:00'; '18:00'};
set(gca,'xtick',pos,'xticklabel',names)



%% Functions
function dy = TPM_20(t,y) % Model with K_x = 20
    % dy = [dG, dU_g, dU_g', dX, dX_1, dU_CHO, dU_I]
    % y  = [ G,  U_g,  U_g',  X,  X_1,  U_CHO,  U_I]
    % setting up parameters of model
    a_x = 0.04;
    a_g = 0.03;
    I2C = 0.1;
    K_x = 20;
    K_g = K_x * I2C;
    
    % setting up model
    dy = zeros(7,1);
    dy(1) = -y(4) + y(2);                                           % (14)
    dy(2) = y(3);                                                   % (15)
    dy(3) = -(2*a_g*y(3)) - ((a_g^2)*y(2)) + (K_g*(a_g^2)*y(6));    % (16)
    dy(4) = -(a_x*y(4)) + (a_x*y(5));                               % (17)
    dy(5) = -(a_x*y(5)) + (K_x*a_x*y(7));                           % (18)
    dy(6) = -y(6);
    dy(7) = -y(7);
end

function dy = TPM_10(t,y) % Model with K_x = 10
    % dy = [dG, dU_g, dU_g', dX, dX_1, dU_CHO, dU_I]
    % y  = [ G,  U_g,  U_g',  X,  X_1,  U_CHO,  U_I]
    % setting up parameters of model
    a_x = 0.04;
    a_g = 0.03;
    I2C = 0.1;
    K_x = 10;
    K_g = K_x * I2C;
    
    % setting up model
    dy = zeros(7,1);
    dy(1) = -y(4) + y(2);                                           % (14)
    dy(2) = y(3);                                                   % (15)
    dy(3) = -(2*a_g*y(3)) - ((a_g^2)*y(2)) + (K_g*(a_g^2)*y(6));    % (16)
    dy(4) = -(a_x*y(4)) + (a_x*y(5));                               % (17)
    dy(5) = -(a_x*y(5)) + (K_x*a_x*y(7));                           % (18)
    dy(6) = -y(6);
    dy(7) = -y(7);
end