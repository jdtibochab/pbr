%% Initialize
count = 1;
dataLibrary = 'data_kim_2015.m';
PBR = PBRgeneration(dataLibrary,count);

%%
internalLightSource = false;
    internalSourceNumber = 0;
externalLightSource = true;
internalLightStrategy = 'ramp';
externalLightStrategy = 'ramp';

%% Calculations
range = [30,55,80,197,476,848];

cases = cell(length(range),1);
for J = 1:length(range)
    cases{J} = PBR;
end

solution = cell(length(range),1);

tic
parfor K = 1:length(range)
    changeCobraSolver('gurobi','all',0);

    initialExtI0 = range(K);
    finalExtI0 = range(K);
    initialIntI0 = 0;
    finalIntI0 = 0;
    lightp = cases{K}.methods.lightp;
    
    
    tspan = cases{K}.methods.tspan;
    
    
    intI0profile = lightProfile(tspan,initialIntI0,finalIntI0,internalLightStrategy,lightp)*internalLightSource; % uE/m2-s;
    extI0profile = lightProfile(tspan,initialExtI0,finalExtI0,externalLightStrategy,lightp)*externalLightSource; % uE/m2s;
    
    cases{K}.methods.intI0profile = intI0profile;
    cases{K}.methods.extI0profile = extI0profile;
    cases{K}.ID = ['I=',num2str(range(K))];
    
    solution{K} = sFBA(cases{K},'printLevel',0);
end
toc
save('kim_2015.mat','cases','solution','range')

