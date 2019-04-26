function solution = sFBA(PBR,varargin)
%% Description
% Spatiotemporal Dynamic Flux Balance Analysis
%
% Updates culture variables in a bioreactor using genome-scale metabolic
% models and additional models to account for non-idealities.
%% Initialize solution
tic
solution = PBR.initial.preallocated;
solution.temporal.s = 0;
solution.temporal.d = 0;
solution.ID = PBR.ID;
solution.PBR = PBR;

reportTable = [];

if isempty(varargin)
    printLevel = 0;
else
    for v = 1:length(varargin)
        optParams(v) = ischar(varargin{v});
    end
    pos = find(optParams);
    resumePos = pos(find(ismember({varargin{find(optParams)}},'resume')));
    printPos = pos(find(ismember({varargin{find(optParams)}},'printLevel')));
    fixedTimePos = pos(find(ismember({varargin{find(optParams)}},'fixedTime')));
    if resumePos
        solution = varargin{resumePos+1};
        PBR = solution.PBR;
        solution.count = solution.count;
        reportTable = cell2mat(table2cell(solution.reportTable));
        reportTable(end,:) = [];
        disp(['Resuming from ',num2str(solution.t(solution.count)),' h...'])
    end
    if printPos
        printLevel = varargin{printPos+1};
    else
        printLevel = 0;
    end
    if fixedTimePos
        fixedTime = varargin{fixedTimePos+1};
        if varargin{fixedTimePos+1}
            warning('Using fixed time method')
        end
    else
        fixedTime = 0;
    end
end

titles = '\n|     |I (umol/m2 s) |         Biomass (g/L)         |      Compounds (mM)   |        |                      Rates (mmol/gDW h)                 |     |\n';
head   = ' Time   intI   extI      X      TAG     STA      XT      N       C       O       Qn     rx     rTAG     rSTA   rN_kin     rN       rC      rO2     AI      LR      SP\n';
variableNames = {'Time','intI','extI','X','TAG','STA','XT','N','C','O','Qn','rx','rTAG','rSTA','rN_kin','rN','rC','rO2','AI','LR','SP'};

%% Calculation

Ci = PBR.inlet.Ci;
kLa = PBR.methods.kLa;
C_sat = PBR.methods.C_sat;
maxCarbonUptake = PBR.methods.maxCarbonUptake;
data = [];
solution.temporal.relativeFreq_light = zeros(solution.numIntervals+1,1);

for i=solution.count:length(PBR.methods.tspan(1:end-1))
    
    solution.lightCondProfile(i) = lightdarkcycle(PBR.methods.lightp,solution.t(i));
    
    D = PBR.inlet.D * solution.lightCondProfile(i);
    solution.lipidRatio(i) = solution.lipidRatio(i);
    
    % FBA calculation
    solution = FBAcalc(PBR,solution);
    
    % Variable update
    solution.C(:,i+1) = solution.C(:,i) + D*(Ci-solution.C(:,i)) + ...
        solution.r(:,i).*solution.C(1,i) + kLa.*(C_sat-solution.C(:,i));
    
    if kLa(4) == 0
        solution.C(4,i+1) = PBR.initial.preallocated.C(4,i+1);
    end
    if kLa(5) == 0
        solution.C(5,i+1) = PBR.initial.preallocated.C(5,i+1);
    end
    
    solution.cellTAG(i+1) = solution.C(2,i+1)/solution.C(3,i+1); % gLip/gTotalDW
    solution.cellStarch(i+1) = solution.C(6,i+1)/solution.C(3,i+1); % gStarch/gDW
    solution.t(i+1) = solution.t(i) + PBR.methods.dt; % h
    solution.size(i+1) = PBR.experimental.minSize/(1-solution.cellTAG(i+1)-solution.cellStarch(i+1)); % pg/cell
    solution = sizePenaltyFun(PBR,solution);
    
    solution.cellNumber(i+1) = solution.C(3,i+1)/solution.size(i+1)*1e12;
    
    data = [solution.t(i),PBR.methods.intI0profile(i),PBR.methods.extI0profile(i),...
            solution.C(1,i),solution.C(2,i),solution.C(6,i),solution.C(3,i),solution.C(end,i),...
            solution.C(4,i),solution.C(5,i),solution.Qn(i),solution.r(1,i),solution.r(2,i),...
            solution.r(6,i), solution.r(end,i),solution.rN(i),solution.r(4,i),solution.r(5,i),...
            solution.temporal.a,solution.lipidRatio(i),solution.sizePenalty(solution.count)];
    
    reportTable(end+1,:) = data;
    
    % Warnings
    if solution.C(1,i+1) >= 8 % g/L
%         warning('Biomass max. concentration reached.')
    end
    metabolicCriteria = abs(solution.r(5,i)/PBR.methods.maxOxygenDemand);
    if  fixedTime == 1 && metabolicCriteria < 1e-3 && solution.lightCondProfile(i) == 1
        break;
    end
    washCriteria = solution.C(3,i+1);
    if  washCriteria < 1e-4 && solution.lightCondProfile(i) == 1
%         warning('Reactor washed');
        break;
    end
    if PBR.methods.saveEvery
        a = floor((i-1)/PBR.methods.saveEvery);
        if a >= solution.temporal.s || i == 1            
            solution.reportTable = cell2table(num2cell(reportTable),'VariableNames',variableNames);
            solution.PBR = PBR;
            
            save(['partial_',PBR.ID,'.mat'],'PBR','solution');
            solution.temporal.s = solution.temporal.s + 1;
        end
    end
    if printLevel
        b = floor((i-1)/24);
        if b >= solution.temporal.d || i == 1
           fprintf(titles);
           fprintf(head);
           solution.temporal.d = solution.temporal.d + 1;
        end
        
        fprintf('%5.1f   %5.1f   %5.1f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %5.3f   %3.0f   %5.3f   %5.3f\n',data)

    end
    
    solution.count = solution.count+1;
end
solution.processingTime = toc;
end