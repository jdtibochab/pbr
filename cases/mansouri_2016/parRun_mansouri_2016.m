%% Initialize
clear
data_mansouri_2016;
count = 1;
PBRgeneration;
%% Calculations
intensityRange = [30,55,80,197,476,848];

cases = cell(length(intensityRange),1);
for J = 1:length(intensityRange)
    cases{J} = PBR;
end

solution = cell(length(intensityRange),1);

tic
parfor K = 1:length(intensityRange)
    changeCobraSolver('gurobi','all',0)

    initialExtI0 = intensityRange(K);
    finalExtI0 = intensityRange(K);
    
    intI0profile = lightProfile(tspan,initialIntI0,finalIntI0,internalLightStrategy,lightp)*internalLightSource; % uE/m2-s;
    extI0profile = lightProfile(tspan,initialExtI0,finalExtI0,externalLightStrategy,lightp)*externalLightSource; % uE/m2s;
    
    cases{K}.methods.intI0profile = intI0profile;
    cases{K}.methods.extI0profile = extI0profile;
    cases{K}.ID = ['I=',num2str(intensityRange(K))];

    
    PBR = cases{K};
    [cases{K},solution{K}] = sFBA(PBR,'printLevel',0);
end
toc
save('kim_2015.mat','cases','solution')

%% Resuming
% parfor K = 1:length(intensityRange)
%     changeCobraSolver('gurobi','all',0)
%     
%     PBR = cases{K};
%     solCase = solution{K};
%     [cases{K},solution{K}] = sFBA(PBR,'resume',PBR,solCase);
% end

