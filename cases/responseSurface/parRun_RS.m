%% Initialize
clear
data_RS;
count = 1;
PBRgeneration;
%% Calculations
range = [1,10:20:100,200:100:1000,1200:100:2000];

cases = cell(length(range),1);
for J = 1:length(range)
    cases{J} = PBR;
end

solution = cell(length(range),1);

tic
parfor K = 1:length(range)
    changeCobraSolver('gurobi','all',0)

    initialExtI0 = range(K);
    finalExtI0 = range(K);
    
    intI0profile = lightProfile(tspan,initialIntI0,finalIntI0,internalLightStrategy,lightp)*internalLightSource; % uE/m2-s;
    extI0profile = lightProfile(tspan,initialExtI0,finalExtI0,externalLightStrategy,lightp)*externalLightSource; % uE/m2s;
    
    cases{K}.methods.intI0profile = intI0profile;
    cases{K}.methods.extI0profile = extI0profile;
    cases{K}.ID = ['I=',num2str(range(K))];

    
    PBR = cases{K};
    [cases{K},solution{K}] = sFBA(PBR,'printLevel',0);
end
toc
save('parRun_RS2.mat','cases','solution','range')

%% Resuming
% parfor K = 1:length(intensityRange)
%     changeCobraSolver('gurobi','all',0)
%     
%     PBR = cases{K};
%     solCase = solution{K};
%     [cases{K},solution{K}] = sFBA(PBR,'resume',PBR,solCase);
% end

