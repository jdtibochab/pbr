%%
clear
logFile = 'reglog.txt';
delete(logFile)
diary(logFile)

%%
dataLibrary = 'data_reg_kim_2015';

%%
sizeIncrease = 1.7;
maxOxygenDemand = 8.8;
maxCarbonUptake = -5.18;
K = 0.049; % Half saturation coefficient for starch consumption
qh = 0.12; % Half saturation coefficient for lipid ratio (m-m model only);

% sizeIncrease = 2;
% maxOxygenDemand = 20;
% maxCarbonUptake = -15.79;
% K = 0.04; % Half saturation coefficient for starch consumption
% qh = 0.5; % Half saturation coefficient for lipid ratio (m-m model only);

%%
[e0,solution0] = errorFunction(P0,dataLibrary);

%%
options = optimoptions('fmincon','Display','iter','UseParallel',true);

% Central differences
options = optimoptions(options,'FiniteDifferenceType','central');

% Tolerance
% options = optimoptions(options,'StepTolerance',1e-6);
% options = optimoptions(options,'OptimalityTolerance',0.001);

% Algorithm
options = optimoptions(options,'Algorithm','active-set');

%
A = [];
b = [];
Aeq = [];
beq = [];
lb = [1.1; 1;-10;-4.6;-4.6];
ub = [5  ;10; -1; -0.6931;-0.6931];
% lb = [1.1; 1;-10;0.01;0.01];
% ub = [5  ;10; -1; 0.5;0.5];

options
delete(gcp('nocreate'))
parpool(12,'IdleTimeout',Inf)

%%
fun = @(P) errorFunction(P,dataLibrary);
[x,fval] = fmincon(fun,P0,A,b,Aeq,beq,lb,ub,[],options);
%%

save('reglog_kim_2015_848.mat')
delete(gcp('nocreate'))

[e,solution] = errorFunction(x,dataLibrary);
report(solution);

xf = x;
xf(4:5) = exp(xf(4:5))
save('reglog_kim_2015_848.mat')

