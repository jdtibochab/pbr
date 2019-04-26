
function PBR = PBRgeneration(dataLibrary,count,varargin)
if ~isempty(varargin) && numel(varargin{1}) == 5
    sizeIncrease = varargin{1}(1);
    maxOxygenDemand = varargin{1}(2);
    maxCarbonUptake = varargin{1}(3);
    K = varargin{1}(4); % Half saturation coefficient for starch consumption
    qh = varargin{1}(5);
elseif ~isempty(varargin) && numel(varargin{1}) == 6
    lightp = varargin{1}(1);
    initialIntI0 = varargin{1}(2);
    finalIntI0 = varargin{1}(3);
    tf = varargin{1}(4);
    b = varargin{1}(5);
end
run(dataLibrary);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PBR generation

PBR.ID = 'PBR';

PBR.experimental.growth = experimentalDataset;
PBR.experimental.minSize = minSize;
PBR.experimental.maxSize = maxSize;

PBR.reactor.type = reactorType;
PBR.reactor.geometry = reactorGeometry;

% PBR.methods.numIntervals = NumIntervals;
PBR.methods.numElements = NumElements;
PBR.methods.models.light = modelLight;
PBR.methods.models.dark = modelDark;
PBR.methods.models.externalLightDistribution = internalLightDistModel;
PBR.methods.models.internalLightDistribution = externalLightDistModel;
PBR.methods.models.photoinhibition = photoinhibitionModel;
PBR.methods.models.nitrogenUptake = nitrogenUptakeModel;
PBR.methods.models.carbonUptake = carbonUptakeModel;
PBR.methods.models.sizePenalty = sizePenaltyModel;
PBR.methods.models.lipidYield = lipidYieldModel;
PBR.methods.biomassReaction = biomassReaction;
PBR.methods.biomassReactionID = biomassReactionID;
PBR.methods.oxygenDemandID = oxygenDemandID;
PBR.methods.oxygenConsumptionID = oxygenConsumptionID;
PBR.methods.objectiveFunction = objectiveFunction;
PBR.methods.objectiveFunctionLipid = objectiveFunctionLipid;
PBR.methods.objectiveFunctionStarch = objectiveFunctionStarch;
PBR.methods.lipidProduction = lipidProduction;
PBR.methods.lipidProductionID = lipidProductionID;
PBR.methods.lipidMolarMass = lipidMolarMass;
PBR.methods.starchProduction = starchProduction;
PBR.methods.starchProductionID = starchProductionID;
PBR.methods.starchConsumption = starchConsumption;
PBR.methods.starchConsumptionID = starchConsumptionID;
PBR.methods.starchMolarMass = starchMolarMass;
PBR.methods.intervalControl = intervalControl;

PBR.methods.maxCarbonUptake = maxCarbonUptake;
PBR.methods.maxOxygenDemand = maxOxygenDemand;
PBR.methods.carbonConstraint = carbonConstraint;
PBR.methods.intI0profile = intI0profile;
PBR.methods.extI0profile = extI0profile;
PBR.methods.tspan = tspan;
PBR.methods.dt = dt;
PBR.methods.K = K;
PBR.methods.qh = qh;
PBR.methods.kLa = [0;0;0;kLa_CO2;kLa_O2;0;0];
PBR.methods.C_sat = [0;0;0;CO2_sat;O2_sat;0;0];
PBR.methods.lightp = lightp;
PBR.methods.saveEvery = saveEvery;
PBR.methods.lipidAccumulation = lipidAccumulation;
PBR.methods.starchAccumulation = starchAccumulation;

PBR.sources.carbon.name = carbonSource;
PBR.sources.carbon.ID = carbonSourceID;
PBR.sources.nitrogen.name = nitrogenSource;
PBR.sources.nitrogen.ID = nitrogenSourceID;
PBR.sources.light.name = lightSource;
PBR.sources.light.ID = lightSourceID;
PBR.sources.light.internal.on = internalLightSource;
PBR.sources.light.internal.number = internalSourceNumber;
PBR.sources.light.external.on = externalLightSource;

PBR.initial.Qn0 = Qn0;
PBR.initial.totalX0 = totalX0;
PBR.initial.N0 = N0;
PBR.initial.lipidContent0 = lipidContent0;
PBR.initial.lipidRatio0 = lipidRatio0;

%% Inlet
PBR = reactorData(PBR);
PBR.inlet.Ci = [0;0;0;CO2i;O2i;0;Ni];
PBR.inlet.D = D;

% Preallocation
PBR.initial.preallocated.t = t;
PBR.initial.preallocated.C = [X;TAG;totalX;CO2;O2;Starch;N];
PBR.initial.preallocated.r = [rx;rTAG;rx;rC;rO2;rStarch;rN];
PBR.initial.preallocated.Qn = Qn;
PBR.initial.preallocated.rC = rC; 
PBR.initial.preallocated.rN_kin = rN_kin;
PBR.initial.preallocated.rO2 = rO2;
PBR.initial.preallocated.globalPhotoinhibition = globalPhotoinhibition;
PBR.initial.preallocated.theta = theta;
PBR.initial.preallocated.size = cellSize;
PBR.initial.preallocated.sizePenalty = sizePenalty;
PBR.initial.preallocated.cellNumber = cellNumber;
PBR.initial.preallocated.cellTAG = cellTAG;
PBR.initial.preallocated.cellStarch = cellStarch;
PBR.initial.preallocated.lipidRatio = lipidRatio;
PBR.initial.preallocated.count = count;
PBR.initial.preallocated.numIntervals = NumIntervals;
PBR.initial.preallocated.lightCondProfile = lightCondProfile;
PBR.status = '';

end