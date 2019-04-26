%%
function solution = evaluateModel_opt(P,dataLibrary)
P = [P;0]; % Dummy element to indicate optimization

PBR = PBRgeneration(dataLibrary,1,P);
solution = sFBA(PBR,'printLevel',0,'fixedTime',0);

end