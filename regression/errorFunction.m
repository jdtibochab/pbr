%%
function [e,solution] = errorFunction(P,dataLibrary)
changeCobraSolver('gurobi','all',0);

[solution,data] = evaluateModel(P,dataLibrary);
eTAG = data.TAG;
eStarch = data.Starch;
eX = data.totalX;
et = data.t;

X = solution.C(3,1:solution.count);
TAG = solution.C(2,1:solution.count);
Starch = solution.C(6,1:solution.count);
t = solution.t(1:solution.count);

pos = find(ismember(t,et));
X = X(pos);
TAG = TAG(pos);
Starch = Starch(pos);


if ~all(eTAG == 0) && ~all(eStarch == 0)
    e = sum((X-eX).^2)/max(eX) + sum((TAG-eTAG).^2)/max(eTAG) + sum((Starch - eStarch).^2)/max(eStarch);
else
    e = sum((X-eX).^2);
end

end
