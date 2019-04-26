%% Intensity profile from external source

function [externalI,externalU] = externalSourceProf(PBR,solution,R,R0field)
%% Temporal variables
extI0 = PBR.methods.extI0profile(solution.count);
externalLightDistModel = PBR.methods.models.externalLightDistribution;
X = solution.C(1,solution.count);

%% Calculation

r0field = R-R0field; % Distance from reactor surface
switch externalLightDistModel
    case 'naderi_2017'
        I = @(r,X) naderi2015(extI0,X,r,0);
        U = 1;
    case 'naderi_2017_test'
        I = @(r,X) naderi2015test(extI0,X,r,0);
        U = 1;
    case 'none'
        I = @(r,X) extI0+r*X+0;
        U = 0;
    otherwise
        error('External light distribution model not recognized');
end
externalI = real(I(r0field,X));


dr = 1e-6;
dI = (real(I(r0field+dr,X))-real(I(r0field,X)))/dr;
if U
    externalU = -(dI-1./r0field.*externalI)./X*3600/1e3/1e3;
else
    externalU = externalI;
end
end