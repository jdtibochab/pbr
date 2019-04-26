
%%
clear
logFile = 'optlog.txt';
delete(logFile)
diary(logFile)

%%
dataLibrary = 'data_opt_unal';

%%
lightp = 16;
initialIntI0 = 400;
finalIntI0 = 600;
tf = 300;
b_exp = 0.5;

P0 = [lightp;initialIntI0;finalIntI0;tf;b_exp]

%%
fitnessFun = @(P) fitnessFunction(P,dataLibrary);
[f0,solution0] = fitnessFunction(P0,dataLibrary);

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
lb = [1; 1;1;50;1e-5];
ub = [24  ;1000; 1000;500; 4];

options
delete(gcp('nocreate'))
parpool(12,'IdleTimeout',Inf)

%%
[x,fval] = fmincon(fitnessFun,P0,A,b,Aeq,beq,lb,ub,[],options);
[f,solution] = fitnessFunction(x,dataLibrary);

save('optimizationPBR.mat')
