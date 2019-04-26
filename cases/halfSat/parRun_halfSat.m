%% Initialize
clear
data_halfSat;
count = 1;
PBRgeneration;

%% Calculations
range = [0:0.04:0.4];

cases = cell(length(range),1);
for J = 1:length(range)
    cases{J} = PBR;
end

solution = cell(length(range),1);


tic
% parpool(length(range))
parfor K = 1:length(range)
    changeCobraSolver('gurobi','all',0);

    Kc = range(K);
    cases{K}.methods.K = Kc;
    
    cases{K}.ID = ['K=',num2str(range(K))];
    
    PBR = cases{K};
    [cases{K},solution{K}] = sFBA(PBR,'printLevel',0);
end
toc
save('kim_2015.mat','cases','solution','range')
% delete(gcp('nocreate'))
