%%
function [f,solution] = fitnessFunction(P,dataLibrary)
changeCobraSolver('gurobi','all',0);

solution = evaluateModel_opt(P,dataLibrary);
TAG = solution.C(2,1:solution.count);
tf = solution.t(solution.count);

f = TAG(end)/tf; % Global average lipid accumulation rate
f = f^-1;
end
