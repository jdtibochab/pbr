function [modelLight,modelDark] = generateModelLD(model,carbonSource,starchConsumption)

%% Light
modelLight = model;

%% Dark
modelDark = changeRxnBounds(model,carbonSource,0,'b');
modelDark = changeRxnBounds(model,starchConsumption,-1000,'l');


end