%% Initialize
data_halfSat;
%% Calculations
count = 1;
PBRgeneration;

Kc = 0.1;
PBR.methods.K = Kc;

[PBR,solution] = sFBA(PBR,'printLevel',1);


%% Experimental results
data = experimentalData(PBR);

%% Plotting
primaryData;
secondaryData;
tertiaryData;
% intensityProf(PBR,solution,1);
