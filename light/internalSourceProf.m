%% Intensity profile from internal sources

function [internalI,internalU,ri] = internalSourceProf(PBR,solution,r,x,y,r0,d)
%% Temporal variables
intI0 = PBR.methods.intI0profile(solution.count);
internalLightDistModel = PBR.methods.models.internalLightDistribution;
internalSourceNumber = PBR.sources.light.internal.number;
X = solution.C(1,solution.count);

%% Internal Light Sources
xpos = @(T) d/2*cos(T*pi()/180);
ypos = @(T) d/2*sin(T*pi()/180);

%% Preallocation
xi = zeros(1,internalSourceNumber);
yi = zeros(1,internalSourceNumber);
ri = cell(1,internalSourceNumber);
Ii = cell(1,internalSourceNumber);
Ui = cell(1,internalSourceNumber);
%% Location
for i = 1:internalSourceNumber
    xi(i) = xpos(90+(360/internalSourceNumber)*(i-1));
    yi(i) = ypos(90+(360/internalSourceNumber)*(i-1));
end

% Domain
% fprintf('\n ....... Generating mesh .......  \n \n')

for i=1:internalSourceNumber
    ri{i} = r(x,y,xi(i),yi(i));
end


%% Intensity
internalI=0;
% Model from Naderi et al. (2017) for Chlorella vulgaris
switch internalLightDistModel
    case 'naderi_2017'
        I = @(r,X) (r(i)<r0+1e-5).*0 + (r(i)>r0+1e-5).*naderi2015(intI0,X,r,r0);
        U = 1;
    case 'naderi_2017_test'
        I = @(r,X) (r(i)<r0+1e-5).*0 + (r(i)>r0+1e-5).*naderi2015test(intI0,X,r,r0);
        U = 1;
    case'none'
        I = @(r,X) intI0+r*X*0;
        U = 0;
    otherwise
        error('Internal light distribution model not recognized');
end
internalU = zeros(size(x));
dr = 1e-6;

for k=1:internalSourceNumber
    Ui{k} = zeros(size(x));
    Ii{k} = I(ri{k},X);
    dI = -(I(ri{k}+dr,X)-I(ri{k},X))/dr;
    if U
        Ui{k} = (dI+1./ri{k}.*Ii{k})./X*3600/1e3/1e3;
    else
        Ui{k} = Ii{k};
    end
    internalI = real(internalI+Ii{k}); % real() was necessary for posCorrFinal() to take a lot less time correcting
    internalU = real(internalU+Ui{k});
end
end