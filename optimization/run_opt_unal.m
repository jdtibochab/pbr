%% Initialize
count = 1;
dataLibrary = 'data_unal.m';
PBR = PBRgeneration(dataLibrary,count);

%% Calculations
solution = sFBA(PBR,'printLevel',1,'fixedTime',1);

%% Plotting
report(solution);
% save('adesanya_2014_0.5N.mat')
%% For resuming
% resumeRun;