%% Initialize
clear
data_concas_2013;
count = 1;
PBRgeneration;
%% Calculations
nitrogenRange = [2.5,5]/101.1*1000;

cases = cell(length(nitrogenRange),1);
for J = 1:length(nitrogenRange)
    cases{J} = PBR;
end
solution = cell(length(nitrogenRange),1);

tic
parfor K = 1:length(nitrogenRange)
    changeCobraSolver('gurobi','all',0)

    N0 = nitrogenRange(K);
  
    cases{K}.initial.N0 = N0;
    cases{K}.ID = ['N0=',num2str(nitrogenRange(K))];
    
    PBR = cases{K};
    [cases{K},solution{K}] = sFBA(PBR,'printLevel',0);
end
toc
save('concas_2013.mat','cases','solution')

%% Resuming
% parfor K = 1:length(nitrogenRange)
%     changeCobraSolver('gurobi','all',0)
%     
%     PBR = cases{K};
%     solCase = solution{K};
%     [cases{K},solution{K}] = sFBA(PBR,'resume',PBR,solCase);
% end

