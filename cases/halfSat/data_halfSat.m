
%% Model

load('modelHT.mat')
load('modelPA.mat')

modelLight = model_starch;
modelDark = modelHT;
% model = Chlorella_LightBOF{1};

%% Experimental data to contrast with
%%
% Kim 2015 used a cylindrical reactor with external light sources.
% experimentalDataset = 'kim_2015_30';
% experimentalDataset = 'kim_2015_55';
% experimentalDataset = 'kim_2015_80';
% experimentalDataset = 'kim_2015_197';
% experimentalDataset = 'kim_2015_476';
experimentalDataset = 'kim_2015_848';
% experimentalDataset = 'none';

%%
% Iehana 1990 used a planar reactor with one external light source.
% experimentalDataset = 'iehana_1990_0.58';
% experimentalDataset = 'iehana_1990_1.46';
% experimentalDataset = 'iehana_1990_2.63';
% experimentalDataset = 'iehana_1990_6.48';
% experimentalDataset = 'none';


%% Cell size data
minSize = 75; % pg/cell
maxSize = 150; % pg/cell

%% Reactor Type & Geometry
reactorType = 'cylindrical';
% reactorType = 'planar';

reactorGeometry = 'kim_2015';
% reactorGeometry = 'unalGPQB';
% reactorGeometry = 'iehana_1990';

%% Models & Methods
NumIntervals = 50; % Number of light invervals (>10 active recommended)
NumElements = 200; % Number of elements for light distribution


% changeCobraSolver ('gurobi', 'all')

internalLightDistModel = 'naderi_2017';
% internalLightDistModel = 'none';

externalLightDistModel = 'naderi_2017';
% externalLightDistModel = 'none';

photoinhibitionModel = 'baroli_1995';
% photoinhibitionModel = 'none';

nitrogenUptakeModel = 'adesanya_2014';
% nitrogenUptakeModel = 'none';

carbonUptakeModel = 'filali_2011';
% carbonUptakeModel = 'none';

lipidAccumulation = 1;
% lipidAccumulation = 0;

starchAccumulation = 1;
% starchAccumulation = 0;


lipidYieldModel = 'sin';
% lipidYieldModel = 'linear';
% lipidYieldModel = 'none';

sizePenaltyModel = 'simple';
% sizePenaltyModel = 'none';


%% Culture time
t0 = 0;
tf = 500;
dt = 1;
tspan = t0:dt:tf;

saveEvery = 24;

%% Carbon source

carbonSource = 'EX_co2(e)';
% carbonSource = 'EX_glc(e)';
% carbonSource = 'EX_hco3(e)';

carbonSourceID = findRxnIDs(modelLight,carbonSource);

%% Nitrogen source
nitrogenSources = {'EX_no3(e)';'EX_no2(e)';'EX_urea(e)';'EX_nh4(e)'};
nitrogenSource = nitrogenSources{4};

nitrogenSourceID = findRxnIDs(modelLight,nitrogenSource);

%% Light Source
lightSources = modelLight.rxns(strmatch('PRISM_',modelLight.rxns));
lightSource = lightSources{4};

% lightSource = 'PRISM_solar_litho';
% lightSource = 'PRISM_solar_exo';
% lightSource = 'PRISM_incandescent_60W';
% lightSource = 'PRISM_fluorescent_warm_18W';
% lightSource = 'PRISM_fluorescent_cool_215W';
% lightSource = 'PRISM_metal_halide';
% lightSource = 'PRISM_high_pressure_sodium';
% lightSource = 'PRISM_growth_room';
% lightSource = 'PRISM_white_LED';
% lightSource = 'PRISM_red_LED_array_653nm';
% lightSource = 'PRISM_red_LED_674nm';
% lightSource = 'PRISM_design_growth';

lightSourceID = findRxnIDs(modelLight,lightSource);

%% Light strategy
internalLightSource = 0;
    internalSourceNumber = 0;
externalLightSource = 1;
lightp = 16;

initialIntI0 = 0;
finalIntI0 = 0;
internalLightStrategy = 'ramp';

initialExtI0 = 848;
finalExtI0 = 848;
externalLightStrategy = 'ramp';


%% Initial and inlet conditions
qnm = 0.0949/14*1000; % Maximum nitrogen quota, mmolN/gDW
Qn0 = 6.5;  % Initial nitrogen quota, mmolN/gDW. Set this value by running the simulation once and looking for stabilization magnitude. 
% [Hypothesis] Most likely this stabilization occurred in previous steps of the culture.

% Liquid phase
totalX0 = 0.1; % g/L
N0 = 200/132.14; % mmol/L
lipidContent0 = 0.15; % g/gDW
starchContent0 = 0.15; % g/gDW

% Bubble - liquid bulk transport of CO2
PCO2 = 0.05; % atm
kLa_CO2 = 1.36; % h^-1. Zero value turns off CO2 concentration update.
    H_CO2 = 29/1000; % atm L/mmol
    CO2_sat = PCO2/H_CO2; % mmol/L
CO20 = CO2_sat; % mmol/L

% Cell - liquid bulk transport of O2
PO2 = 0;
kLa_O2 = 0; % h^-1. Zero value turns off O2 concentration update.
H_O2 = 29/1000; % atm L/mmol
O2_sat = PCO2/H_O2; % mmol/L
O20 = O2_sat; % mmol/L

% Liquid flow inlet
D = 0; % L/h
Ni = N0; % mmol/L
CO2i = CO20; % mmol/L
O2i = O20; % mmol/L

%% --------------------------------------------------------------------------------
%% Model Initialization
oxygenDemand = {'DM_o2D(u)'};
    oxygenDemandID = findRxnIDs(modelLight,oxygenDemand);
oxygenConsumption = {'EX_o2(e)'};
    oxygenConsumptionID = findRxnIDs(modelLight,oxygenConsumption);
biomassReaction = {'Biomass_Cvu_auto-'};
    biomassReactionID = findRxnIDs(modelLight,biomassReaction);
starchConsumption = {'EX_starch(h)'};
    starchConsumptionID = findRxnIDs(modelLight,starchConsumption);
    
[modelLight,modelDark,lipidProduction,lipidMets,weight] = modelModLipids(modelLight,modelDark,biomassReactionID); % Model lipid accumulation.
[modelLight,modelDark,starchProduction,starchMet] = modelModStarch(modelLight,modelDark,biomassReactionID);

objectiveFunction = biomassReaction;
objectiveFunctionLipid = lipidProduction;
objectiveFunctionStarch = starchProduction;

modelLight = changeObjective(modelLight,objectiveFunction);
modelDark = changeObjective(modelDark,objectiveFunction);
modelDark = changeRxnBounds(modelDark,objectiveFunction,1000,'u');


% Other initial values
X0 = totalX0*(1-lipidContent0-starchContent0); % g/L
TAG0 = lipidContent0*totalX0; % g/L
Starch0 = starchContent0*totalX0; % g/L
size0 = minSize/(1-lipidContent0-starchContent0); % pg/cell
lipidRatio0 = 1-Qn0/qnm;
cellNumber0 = totalX0/size0*1e12; % cell/L

% Preallocation
t = tspan;
X = ones(1,length(tspan))*X0;
totalX = ones(1,length(tspan))*totalX0;
N = ones(1,length(tspan))*N0;
CO2 = ones(1,length(tspan))*CO20;
O2 = ones(1,length(tspan))*O20;
cellTAG = ones(1,length(tspan))*lipidContent0;
cellStarch = ones(1,length(tspan))*starchContent0;
TAG = ones(1,length(tspan))*TAG0;
Starch = ones(1,length(tspan))*Starch0;
Qn = ones(1,length(tspan))*Qn0;
rx = zeros(1,length(tspan)-1);
rN = zeros(1,length(tspan)-1);
rC = zeros(1,length(tspan)-1); 
rN_kin = zeros(1,length(tspan)-1);
rTAG = zeros(1,length(tspan)-1);
rStarch = zeros(1,length(tspan)-1);
rO2 = zeros(1,length(tspan)-1);
globalPhotoinhibition = zeros(1,length(tspan));
theta = ones(length(tspan),NumIntervals+1);
size = ones(1,length(tspan))*size0;
sizePenalty = zeros(1,length(tspan));
cellNumber = ones(1,length(tspan))*cellNumber0;
lipidRatio = ones(1,length(tspan)-1)*lipidRatio0*lipidAccumulation;

% TAG
lipidProductionID = findRxnIDs(modelLight,lipidProduction);
starchProductionID = findRxnIDs(modelLight,starchProduction);

lipidMolarMass = calculateFormula(modelLight,lipidMets,weight);
starchMolarMass = calculateFormula(modelLight,starchMet,1);

out = optimizeCbModel(changeObjective(modelLight,objectiveFunction));
maxCarbonUptake = out.full(carbonSourceID);
carbonConstraint = modelLight.lb(carbonSourceID);

% Nitrogen
modelLight = changeRxnBounds(modelLight,nitrogenSources,0,'b');
modelDark = changeRxnBounds(modelDark,nitrogenSources,0,'b');
modelLight = changeRxnBounds(modelLight,nitrogenSource,-10,'l');
modelDark = changeRxnBounds(modelDark,nitrogenSource,-10,'l');

modelLight = changeRxnBounds(modelLight,'DM_no(h)',0,'b'); % Chlorella exhibited a secondary steady state with increased nitrogen uptake only to send it back to the medium as NO.

outD = optimizeCbModel(modelDark);

% Light
modelLight = changeRxnBounds(modelLight,lightSources,0,'b');
modelDark = changeRxnBounds(modelDark,lightSources,0,'b');

intI0profile = lightProfile(tspan,initialIntI0,finalIntI0,internalLightStrategy,lightp)*internalLightSource; % uE/m2-s;
extI0profile = lightProfile(tspan,initialExtI0,finalExtI0,externalLightStrategy,lightp)*externalLightSource; % uE/m2s;

%%
K = 0.1;