
function report(solution)
%% Experimental results
PBR = solution.PBR;
data = experimentalData(PBR);

%% Plotting
primaryData(PBR,solution,data);
secondaryData(PBR,solution,data);
tertiaryData(PBR,solution,data);
end