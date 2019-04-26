%% Initialize
clear
data_D;
count = 1;
PBRgeneration;
%% Calculations
range = [0:0.005:0.055];

cases = cell(length(range),1);
for J = 1:length(range)
    cases{J} = PBR;
end

solution = cell(length(range),1);

tic
% parpool(length(range))
parfor K = 1:length(range)
    changeCobraSolver('gurobi','all',0);

    D = range(K);
    cases{K}.inlet.D = D;
    cases{K}.ID = ['D=',num2str(range(K))];

    
    PBR = cases{K};
    [cases{K},solution{K}] = sFBA(PBR,'printLevel',0);
end
toc
save('responseSurface_D.mat','cases','solution','range')

%% Resuming
% parfor K = 1:length(intensityRange)
%     changeCobraSolver('gurobi','all',0)
%     
%     PBR = cases{K};
%     solCase = solution{K};
%     [cases{K},solution{K}] = sFBA(PBR,'resume',PBR,solCase);
% end

