%% Initialize
count = 1;
dataLibrary = 'data_lv_2010.m';
PBR = PBRgeneration(dataLibrary,count);

%% Calculations
solution = sFBA(PBR,'printLevel',1);

%% Plotting
report(solution);
save('lv_2010_1N.mat')
%% For resuming
% resumeRun;