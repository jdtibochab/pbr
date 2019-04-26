%%
%
clear
logFile = 'reglog.txt';
delete(logFile)
diary(logFile)
%%
dataLibrary = 'data_reg_lv_2010';

%%
sizeIncrease = 2;
maxOxygenDemand = 10;
maxCarbonUptake = -10;
K = 0.01; % Half saturation coefficient for starch consumption
qh = 0.05; % Half saturation coefficient for lipid ratio (m-m model only);

P0 = [sizeIncrease;maxOxygenDemand;maxCarbonUptake;log(K);log(qh)]

%%
[e0,solution0] = errorFunction(P0,dataLibrary);

%%
options = optimoptions('fmincon','Display','iter','UseParallel',true);

% Central differences
options = optimoptions(options,'FiniteDifferenceType','central');

% Tolerance
% options = optimoptions(options,'StepTolerance',1e-6);
% options = optimoptions(options,'OptimalityTolerance',0.001);
options = optimoptions(options,'FunctionTolerance',1);

% Algorithm
options = optimoptions(options,'Algorithm','active-set');

%
A = [];
b = [];
Aeq = [];
beq = [];
lb = [1.1; 1;-50;log(0.01);log(0.01)];
ub = [5  ;50; -1; log(0.5);log(0.5)];
% lb = [1.1; 1;-10;0.01;0.01];
% ub = [5  ;10; -1; 0.5;0.5];

options
delete(gcp('nocreate'))
parpool(12,'IdleTimeout',Inf)

%%
fun = @(P) errorFunction(P,dataLibrary);
[x,fval] = fmincon(fun,P0,A,b,Aeq,beq,lb,ub,[],options);
%%

save('reglog_lv_2010.mat')
delete(gcp('nocreate'))

[e,solution] = errorFunction(x,dataLibrary);
report(solution);

xf = x;
xf(4:5) = exp(xf(4:5))
save('reglog_lv_2010.mat')

