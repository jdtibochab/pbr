%% Model modification for lipid accumulation
function [modelLight,modelDark,starchReaction,starchID] = modelModStarch(modelLight,modelDark,biomassReactionID)
bofMetIDs = find(modelLight.S(:,biomassReactionID)<0);

bofMets = modelLight.mets(bofMetIDs);
excMets = [strmatch('atp',bofMets),strmatch('h2o',bofMets)];
bofMetIDs(excMets) = [];
bofMets(excMets) = [];

stoich = modelLight.S(bofMetIDs,biomassReactionID);
starchMetNum = strmatch('starch',bofMets);
stoich(starchMetNum) = 0;

starchMet = bofMets(starchMetNum);
starchID = findMetIDs(modelLight,starchMet);

% [~,molarMass] = calculateFormula(modelLight,bofMetIDs,stoich);
% criterium2 = -sum(stoich.*molarMass);
% stoich = stoich*criterium/criterium2;

modelLight.S(bofMetIDs,biomassReactionID) = stoich; %   TEST
modelDark.S(bofMetIDs,biomassReactionID) = stoich; %   TEST


storageStarchMet = 'storageSTARCH_h';
storageStarchDM = 'starch_storage';

modelLight = addReaction(modelLight,storageStarchDM,'metaboliteList',[starchMet;storageStarchMet],'stoichCoeffList',[-1;1],'reversible',1,'printLevel',0);
modelLight = addDemandReaction(modelLight,storageStarchMet,0);

modelDark = addReaction(modelDark,storageStarchDM,'metaboliteList',[starchMet;storageStarchMet],'stoichCoeffList',[-1;1],'reversible',1,'printLevel',0);
modelDark = addDemandReaction(modelDark,storageStarchMet,0);

modelLight = changeRxnBounds(modelLight,'DM_o2D(u)',8.28,'u');
modelDark = changeRxnBounds(modelDark,'DM_o2D(u)',8.28,'u');

starchReaction = storageStarchDM;

modelLight.metFormulas(findMetIDs(modelLight,storageStarchMet)) = modelLight.metFormulas(findMetIDs(modelLight,starchMet));
modelDark.metFormulas(findMetIDs(modelDark,storageStarchMet)) = modelDark.metFormulas(findMetIDs(modelDark,starchMet));

end
