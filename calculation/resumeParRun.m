
%% Resuming
parfor K = 1:length(range)
    changeCobraSolver('gurobi','all',0)
    
    PBR = cases{K};
    solCase = solution{K};
    [cases{K},solution{K}] = sFBA(PBR,'resume',PBR,solCase,'printLevel',0);
end
