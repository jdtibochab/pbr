function solution = FBAcalc(PBR,solution)
%% Description
% Calculates uptake and consumption rates at a certain timepoint.

%% Temporal variables
rx = 0;
rN = 0;
rC = 0;
rTAG = 0;
rStarch = 0;
rO2 = 0;
avFluxes = 0;

modelLight = PBR.methods.models.light;
modelDark = PBR.methods.models.dark;

numIntervals = solution.numIntervals;

lightCond = solution.lightCondProfile(solution.count);
theta = ones(1,numIntervals+1)*(1-solution.globalPhotoinhibition(solution.count)); % Intervals change through time. PI is equally divided in the PBR (mixing).

relativeFreq_light = solution.temporal.relativeFreq_light;
sizePenalty = solution.sizePenalty(solution.count);
lipidRatio = solution.lipidRatio(solution.count);
lipidAccumulation = PBR.methods.lipidAccumulation;
starchAccumulation = PBR.methods.starchAccumulation;
intervalControl = PBR.methods.intervalControl;

a = 0;

%% Intensity Analysis
[I,U,PBR] = intensityProf(PBR,solution,0); %
[relativeFreq(1,:),rangeI,rangeU] = divideI(solution,I,U,0);
%% Photoinhibition
theta = photoinhibitionFun(PBR,rangeI,theta);

if lightCond
    globalPhotoinhibition = 1 - sum(theta.*relativeFreq);
    relativeFreq_light = relativeFreq;
else
    globalPhotoinhibition = 1 - sum(theta.*relativeFreq_light);
end

%% Carbon uptake kinetics
kinCarbonConstraint = carbonUptake(PBR,solution);

%% FBA
for i = 1:length(rangeU)
    if lightCond
        localFBA.stat = 0;
        if relativeFreq(i) > 1e-4
            model = modelLight;
%             substrate = PBR.sources.carbon.name;
            a = a+1;
            localI = rangeU(i);
            model = changeRxnBounds(model,PBR.sources.light.name,localI,'u');
            model = changeRxnBounds(model,PBR.sources.carbon.name,kinCarbonConstraint,'l');
            
            localFBA = optimizeCbModel(changeObjective(model,PBR.methods.objectiveFunctionStarch));
            if localFBA.stat == 1
                % Photoinhibition
                newLightConstraint = localFBA.full(PBR.sources.light.ID)*theta(i);
                model.ub(PBR.sources.light.ID) = newLightConstraint;
                
                % Carbon allocation
                newCarbonConstraint = localFBA.full(PBR.sources.carbon.ID)*(1-sizePenalty);
                model.lb(PBR.sources.carbon.ID) = newCarbonConstraint;
                
                if lipidAccumulation
                    lipidFBA = optimizeCbModel(changeObjective(model,PBR.methods.objectiveFunctionLipid));
                    if lipidFBA.stat
                        lipidCapacity = lipidFBA.full(PBR.methods.lipidProductionID);
                    else
                        lipidCapacity = 0;
                    end
                end

                % When the cell is too fat with starch, it shouldn't be
                % accumulating it anymore. It should rather be producing
                % proteins.
                biomassFBA = optimizeCbModel(changeObjective(model,PBR.methods.biomassReaction));
                
                if biomassFBA.stat
                    biomassCapacity = biomassFBA.full(PBR.methods.biomassReactionID);
                else
                    biomassCapacity = 0;
                end
                
                model = changeRxnBounds(model,PBR.methods.lipidProduction,lipidCapacity*lipidRatio,'b');
                model = changeRxnBounds(model,PBR.methods.objectiveFunction,biomassCapacity*(sizePenalty)*(1-lipidRatio),'b');
                localFBA = optimizeCbModel(changeObjective(model,PBR.methods.objectiveFunctionStarch));
            else
                rx = 0;
                rN = 0;
                rTAG = 0;
                rC = 0;
                rO2 = 0;
                rStarch = 0;
            end
        end
    else
        model = modelDark;
%         substrate = model.rxns(PBR.methods.starchConsumptionID);
        localFBA = optimizeCbModel(changeObjective(model,PBR.methods.objectiveFunction));
        if localFBA.stat == 1
            % When the cell is consuming starch, its size should decrease.
            % At small sizes it should stop consuming starch (starch depletion).
            starchConsumptionConstraint = starchConsumptionFun(localFBA,PBR,sizePenalty,solution);
            
            model = changeRxnBounds(model,PBR.methods.starchConsumption,starchConsumptionConstraint,'l');

            if lipidAccumulation
                lipidFBA = optimizeCbModel(changeObjective(model,PBR.methods.objectiveFunctionLipid));
                if lipidFBA.stat
                    lipidCapacity = lipidFBA.full(PBR.methods.lipidProductionID);
                else
                    lipidCapacity = 0;
                end
            end
            
            model = changeRxnBounds(model,PBR.methods.lipidProduction,lipidCapacity*lipidRatio,'b');
            
            model = changeObjective(model,PBR.methods.objectiveFunction);
            localFBA = optimizeCbModel(model);
            
        else
            rx = 0;
            rN = 0;
            rTAG = 0;
            rC = 0;
            rO2 = 0;
            rStarch = 0;
        end
    end
    if localFBA.stat == 1
        
        rx = rx + localFBA.full(PBR.methods.biomassReactionID)*relativeFreq(i); % gX/gX h
        rN = rN + localFBA.full(PBR.sources.nitrogen.ID)*relativeFreq(i); % mmolN/gX h
        rTAG = rTAG + localFBA.full(PBR.methods.lipidProductionID).*PBR.methods.lipidMolarMass*relativeFreq(i); %gLipids/gX h
        rC = rC + localFBA.full(PBR.sources.carbon.ID)*relativeFreq(i);
        rO2 = rO2 + (localFBA.full(PBR.methods.oxygenDemandID)+localFBA.full(PBR.methods.oxygenConsumptionID))*relativeFreq(i);
        
        rStarch = rStarch + (localFBA.full(PBR.methods.starchProductionID)+localFBA.full(PBR.methods.starchConsumptionID))*PBR.methods.starchMolarMass*relativeFreq(i);
    end
end
%% Return
solution.globalPhotoinhibition(solution.count+1) = globalPhotoinhibition;
solution.r(1:end-1,solution.count) = [rx;rTAG;rx+rTAG+rStarch;rC;rO2;rStarch];
solution.rN(solution.count) = rN;

solution = nitrogenUptake(PBR,solution);

solution.lightCondProfile(solution.count) = lightCond;
solution.temporal.relativeFreq_light = relativeFreq_light;
solution.temporal.a = a*lightCond;

%% Interval control

if intervalControl && solution.count > 1 && all(solution.lightCondProfile(solution.count:solution.count+1))
    if solution.temporal.a < 10
        solution.numIntervals = solution.numIntervals + 5;
%         warning('Increasing active intervals')
    elseif solution.temporal.a > 13
        solution.numIntervals = solution.numIntervals - 5;
%         warning('Decreasing active intervals')
    end
end
end