%% Initialize
data_D;
%% Calculations
count = 1;
PBRgeneration;

[PBR,solution] = sFBA(PBR,'printLevel',1);


%% Experimental results
data = experimentalData(PBR);

%% Plotting
primaryData;
secondaryData;
tertiaryData;
% intensityProf(C0(1),1);

%% For resuming
% Load workspace with PBR and solution and run:
% [PBR,solution] = sFBA(PBR,'resume',PBR,solution,'printLevel',1);