
%% Model
modelLocation = 'ModelsBOF_optimization.mat';
modelName = 'Chlorella_LightBOF';
load(modelLocation,modelName);


%% Experimental data to contrast with
%%
% Kim 2015 used a cylindrical reactor with external light sources.
% experimentalDataset = 'kim_2015_30';
% experimentalDataset = 'kim_2015_55';
% experimentalDataset = 'kim_2015_80';
% experimentalDataset = 'kim_2015_197';
% experimentalDataset = 'kim_2015_476';
% experimentalDataset = 'kim_2015_848';
% experimentalDataset = 'none';

%%
% Iehana 1990 used a planar reactor with one external light source.
% experimentalDataset = 'iehana_1990_0.58';
% experimentalDataset = 'iehana_1990_1.46';
% experimentalDataset = 'iehana_1990_2.63';
% experimentalDataset = 'iehana_1990_6.48';
% experimentalDataset = 'none';

%%
% Mansouri 2016 used a draft-tube air-lift reactor with external 20W fluorescent
% light sources equivalent to 1300 umol/m2s.
% experimentalDataset = 'mansouri_2016';

%%
% Concas 2013 used a cylindrical vessel (9.5 cm diameter and 21 cm height)
% with a volumetric capacity of 1.5 L. Cultures were maintained at 25 °C by
% a thermostatic bath and illuminated by a photon flux density of 84 µE m-2 s-1 
%  provided by eight 11 W white fluorescent bulbes with a light/dark photoperiod of 12 h.
experimentalDataset = 'concas_2013_1N';
% experimentalDataset = 'concas_2013_2N';

%% Cell size data
minSize = 75; % pg/cell
maxSize = 150; % pg/cell

%% Reactor Type & Geometry
reactorType = 'cylindrical';
% reactorType = 'planar';

% reactorGeometry = 'kim_2015';
% reactorGeometry = 'unalGPQB';
% reactorGeometry = 'iehana_1990';
reactorGeometry = 'concas_2013';

%% Models & Methods
NumIntervals = 28; % Number of light invervals
NumElements = 500; % Number of elements for light distribution

model = Chlorella_LightBOF{1};
[model,lipidProduction,lipidMets] = modelModLipids(model); % Model lipid accumulation.
% changeCobraSolver ('gurobi', 'all')

internalLightDistModel = 'naderi_2017';
% internalLightDistModel = 'none';

externalLightDistModel = 'naderi_2017';
% externalLightDistModel = 'none';

photoinhibitionModel = 'baroli_1995';
% photoinhibitionModel = 'none';

nitrogenUptakeModel = 'adesanya_2014';
% nitrogenUptakeModel = 'none';

sizePenaltyModel = 'simple';
% sizePenaltyModel = 'none';


%% Culture time
t0 = 0;
tf = 1000;
dt = 1;
tspan = t0:dt:tf;

saveEvery = 24;

%% Carbon source

carbonSource = 'EX_co2(e)';
% carbonSource = 'EX_glc(e)';

carbonSourceID = findRxnIDs(model,carbonSource);

%% Nitrogen source
nitrogenSource = 'EX_no3(e)';
% nitrogenSource = 'EX_no2(e)';
% nitrogenSource = 'EX_urea(e)';
% nitrogenSource = 'EX_nh4(e)';

nitrogenSourceID = findRxnIDs(model,nitrogenSource);

%% Light Source
% lightSource = 'PRISM_solar_litho';
% lightSource = 'PRISM_solar_exo';
% lightSource = 'PRISM_incandescent_60W';
lightSource = 'PRISM_fluorescent_warm_18W';
% lightSource = 'PRISM_fluorescent_cool_215W';
% lightSource = 'PRISM_metal_halide';
% lightSource = 'PRISM_high_pressure_sodium';
% lightSource = 'PRISM_growth_room';
% lightSource = 'PRISM_white_LED';
% lightSource = 'PRISM_red_LED_array_653nm';
% lightSource = 'PRISM_red_LED_674nm';
% lightSource = 'PRISM_design_growth';

lightSourceID = findRxnIDs(model,lightSource);

%% Light strategy
internalLightSource = 0;
    internalSourceNumber = 0;
externalLightSource = 1;
lightp = 12;

initialIntI0 = 0;
finalIntI0 = 0;
internalLightStrategy = 'ramp';

initialExtI0 = 84.6;
finalExtI0 = 84.6;
externalLightStrategy = 'ramp';


%% Light Reactions
PSIIreactions = {'PSIIred','PSIIblue'};
PSIIreactionID = findRxnIDs(model,PSIIreactions);


%% Initial conditions
qnm = 0.0949/14*1000; % Maximum nitrogen quota, mmolN/gDW
Qn0 = 6.5;  % Initial nitrogen quota, mmolN/gDW. Set this value by running the simulation once and looking for stabilization magnitude. 
% [Hypothesis] Most likely this stabilization occurred in previous steps of the culture.

totalX0 = 0.0119; % g/L
N0 = 2.5/101.1*1000; % mmol/L
% N0 = 5/101.1*1000;
lipidContent0 = 0; % g/gDW

%% --------------------------------------------------------------------------------
%% Model Initialization
biomassReaction = {'Biomass_Cvu_auto-'};
    biomassReactionID = findRxnIDs(model,biomassReaction);

objectiveFunction = biomassReaction;
objectiveFunction2 = lipidProduction;

model = changeObjective(model,objectiveFunction);

% Other initial values
X0 = totalX0*(1-lipidContent0);
TAG0 = lipidContent0*totalX0; % g/L
size0 = minSize/(1-lipidContent0);
lipidRatio0 = 1-Qn0/qnm;

% Preallocation
t = tspan;
X = ones(1,length(tspan))*X0;
totalX = ones(1,length(tspan))*totalX0;
N = ones(1,length(tspan))*N0;
cellTAG = ones(1,length(tspan))*lipidContent0;
TAG = ones(1,length(tspan))*TAG0;
Qn = ones(1,length(tspan))*Qn0;
rx = zeros(1,length(tspan)-1);
rN = zeros(1,length(tspan)-1);
rC = zeros(1,length(tspan)-1); 
rN_kin = zeros(1,length(tspan)-1);
rTAG = zeros(1,length(tspan)-1);
globalPhotoinhibition = zeros(1,length(tspan));
theta = ones(length(tspan),NumIntervals+1);
size = ones(1,length(tspan))*size0;
sizePenalty = zeros(1,length(tspan));
lipidRatio = ones(1,length(tspan)-1)*lipidRatio0;

% TAG
lipidProductionID = findRxnIDs(model,lipidProduction);
    lipidProductionID = lipidProductionID(end);
    lipidProduction = lipidProduction(end);
    lipidMets = lipidMets(end);

[~,avLipidMolarMass,~,Num] = calculateFormula(model,lipidMets,ones(length(lipidMets),1));
lipidMolarMass = Num*[12;1;16]/1000; % g/mmol

out = optimizeCbModel(changeObjective(model,lipidProduction(1)));
maxCarbonUptake = out.full(carbonSourceID);
carbonConstraint = model.lb(carbonSourceID);

% Nitrogen
model = changeRxnBounds(model,'EX_no3(e)',0,'b');
model = changeRxnBounds(model,'EX_no2(e)',0,'b');
model = changeRxnBounds(model,'EX_urea(e)',0,'b');
model = changeRxnBounds(model,'EX_nh4(e)',0,'b');
model = changeRxnBounds(model,nitrogenSource,-10,'l');
% Light
model.lb(1:12) = 0;
model.ub(1:12) = 0;
model.lb(PSIIreactionID) = 0;
model.ub(PSIIreactionID) = 1000;
intI0profile = lightProfile(tspan,initialIntI0,finalIntI0,internalLightStrategy,lightp)*internalLightSource; % uE/m2-s;
extI0profile = lightProfile(tspan,initialExtI0,finalExtI0,externalLightStrategy,lightp)*externalLightSource; % uE/m2s;

