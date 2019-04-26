%% Initialize
count = 1;
dataLibrary = 'data.m';
PBR = PBRgeneration(dataLibrary,count);

%% Calculations
solution = sFBA(PBR,'printLevel',1);

%% Plotting
report(solution);

%% For resuming
% resumeRun;