%% Model modification for lipid accumulation
function [modelLight,modelDark,lipidReactions,lipidMetIDs,normalizedStoich] = modelModLipids(modelLight,modelDark,biomassReactionID)
bofMetIDs = find(modelLight.S(:,biomassReactionID)<0);

bofMets = modelLight.mets(bofMetIDs);
excMets = [strmatch('atp',bofMets),strmatch('h2o',bofMets)];
bofMetIDs(excMets) = [];
bofMets(excMets) = [];

stoich = modelLight.S(bofMetIDs,biomassReactionID);

% [~,molarMass] = calculateFormula(modelLight,bofMetIDs,stoich);
% criterium = -sum(stoich.*molarMass); % Total mass

tags = strmatch('tag',bofMets);
dags = strmatch('dag',bofMets);
mags = strmatch('mag',bofMets);

lipidMetNum = [tags;dags;mags];

lipidMets = bofMets(lipidMetNum);
lipidMetIDs = findMetIDs(modelLight,lipidMets);
lipidStoichBOF = stoich(lipidMetNum);

modelLight.S(lipidMetIDs,biomassReactionID) = 0; %   TEST
modelDark.S(lipidMetIDs,biomassReactionID) = 0; %   TEST

% normalizedStoich = lipidStoichBOF/abs((sum(lipidStoichBOF)));
normalizedStoich = lipidStoichBOF;

lipidMetIDs = findMetIDs(modelLight,lipidMets);

storageTAGmet = 'storageTAG_c';
storageTAGDM = 'TAG_storage';

modelLight = addReaction(modelLight,storageTAGDM,'metaboliteList',[lipidMets;storageTAGmet],'stoichCoeffList',[normalizedStoich;1],'reversible',0,'printLevel',0);
modelLight = addDemandReaction(modelLight,storageTAGmet,0);

modelDark = addReaction(modelDark,storageTAGDM,'metaboliteList',[lipidMets;storageTAGmet],'stoichCoeffList',[normalizedStoich;1],'reversible',0,'printLevel',0);
modelDark = addDemandReaction(modelDark,storageTAGmet,0);

lipidReactions = storageTAGDM;

modelLight.metFormulas(findMetIDs(modelLight,storageTAGmet)) = modelLight.metFormulas(findMetIDs(modelLight,lipidMets(1)));
modelDark.metFormulas(findMetIDs(modelDark,storageTAGmet)) = modelDark.metFormulas(findMetIDs(modelDark,lipidMets(1)));

end
