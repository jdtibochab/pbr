%%
%
clear
logFile = 'reglog.txt';
delete(logFile)
diary(logFile)

sizeIncrease = 1.7;
maxOxygenDemand = 8.8;
maxCarbonUptake = -5.18;
K = log(0.049); % Half saturation coefficient for starch consumption
qh = log(0.12); % Half saturation coefficient for lipid ratio (m-m model only);

% sizeIncrease = 2;
% maxOxygenDemand = 20;
% maxCarbonUptake = -15.79;
% K = 0.04; % Half saturation coefficient for starch consumption
% qh = 0.5; % Half saturation coefficient for lipid ratio (m-m model only);


P0 = [sizeIncrease;maxOxygenDemand;maxCarbonUptake;K;qh];

%
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
[x,fval] = fmincon(@errorFunction,P0,A,b,Aeq,beq,lb,ub,[],options);

save('reglog.mat')
delete(gcp('nocreate'))

solution = evaluateModel(x);
report(solution);
save('reglog.mat')
% Kim_2015
% x =
% 
%     1.7429
%     8.8380
%    -5.1802
%     0.0493
%     0.1235
% 

%%
function [solution,data] = evaluateModel(P)
sizeIncrease = P(1);
maxOxygenDemand = P(2);
maxCarbonUptake = P(3);
K = exp(P(4)); % Half saturation coefficient for starch consumption
qh = exp(P(5));

PBR = PBRgeneration('data_reg',1,sizeIncrease,maxOxygenDemand,maxCarbonUptake,K,qh);
solution = sFBA(PBR,'printLevel',0);
data = experimentalData(PBR);
end

function e = errorFunction(P)
changeCobraSolver('gurobi','all',0);

[solution,data] = evaluateModel(P);
eX = data.totalX;
et = data.t;

X = solution.C(3,1:solution.count);
t = solution.t(1:solution.count);

pos = find(ismember(t,et));
X = X(pos);

e = sum((X-eX).^2);
end



