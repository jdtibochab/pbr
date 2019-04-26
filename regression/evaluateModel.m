%%
function [solution,data] = evaluateModel(P,dataLibrary)
P(4:5) = exp(P(4:5));
PBR = PBRgeneration(dataLibrary,1,P);
solution = sFBA(PBR,'printLevel',0);
data = experimentalData(PBR);

end