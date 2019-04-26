%% Initialize
count = 1;
dataLibrary = 'data_kim_2015.m';
PBR = PBRgeneration(dataLibrary,count);

%% Calculations
solution = sFBA(PBR,'printLevel',1,'fixedTime',0);

%% Plotting
report(solution);
% save('kim_2015_848')
%% For resuming
% resumeRun;