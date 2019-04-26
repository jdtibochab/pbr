%% Initialize
clear
dataLibrary = 'data_adesanya_2014';
count = 1;
PBR = PBRgeneration(dataLibrary,count);

%% Calculations
range = 0.022*1000/62 * [6];

cases = cell(length(range),1);
for J = 1:length(range)
    cases{J} = PBR;
end

solution = cell(length(range),1);

tic
parfor K = 1:length(range)
    changeCobraSolver('gurobi','all',0);

    N0 = range(K);
        
    cases{K}.initial.N0 = N0;
    cases{K}.ID = [num2str(range(K))];
    cases{K}.initial.preallocated.C(end,:) = N0;

    PBR = cases{K};
    
    solution{K} = sFBA(PBR,'printLevel',0);
end
toc
save('adesanya_2014.mat','cases','solution','range')


%% Resuming
% parfor K = 1:length(intensityRange)
%     changeCobraSolver('gurobi','all',0)
%     
%     PBR = cases{K};
%     solCase = solution{K};
%     [cases{K},solution{K}] = sFBA(PBR,'resume',PBR,solCase);
% end

