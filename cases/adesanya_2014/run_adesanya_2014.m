%% Initialize
count = 1;
dataLibrary = 'data_adesanya_2014.m';
PBR = PBRgeneration(dataLibrary,count);

%% Calculations
solution = sFBA(PBR,'printLevel',1);

%% Plotting
report(solution);
save('adesanya_2014_3N.mat')
%% For resuming
% resumeRun;