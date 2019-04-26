%% Reator geometry data (subroutine)

function PBR = reactorData(PBR)
reactorGeometry = PBR.reactor.geometry;

%% Data

switch reactorGeometry
    case 'kim_2015'
        PBR.reactor.R = 0.11/2; % m, Radius
        PBR.reactor.L = 0.21; % m, Height
        PBR.reactor.V = 2; % L, Volume
    case 'unalGPQB'
        PBR.reactor.d = (5.5)*2.54/100; % m, Source distribution diameter
        PBR.reactor.r0 = (1+3/8)*2.54/100/2; % m, Light source radius
        PBR.reactor.R = (11+5/16)*2.54/100/2; % m, Reactor radius
    case 'iehana_1990'
        PBR.reactor.V = 1085; % mL
        PBR.reactor.L = 0.2; % m
        PBR.reactor.W = 0.05; % m
    case 'mansouri_2016'
        PBR.reactor.R = 15/100; % m
    case 'concas_2013'
        PBR.reactor.R = 9.5/100; % m
    case 'adesanya_2014'
        % Conical reactor approximated to cylindrical
        PBR.reactor.R = 8.9/100; % m
    case 'lv_2010'
        PBR.reactor.r0 = 0;
        PBR.reactor.d = 14/100; % m
        PBR.reactor.R = 14/2/100; % m
        PBR.reactor.L = 70/100; % m
    otherwise
        error('\n Reactor geometry data not recognized \n \n');
end
end
