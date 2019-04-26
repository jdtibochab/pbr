%% Naderi et al. light distribution model

function I = naderi2015test(I0,X,r,r0)
Kamax = 104.1; % m^-1
b = 1.03; % g/L
q = -0.3128;
pk = 12.66;
Ka = @(X) Kamax/(b+X);
I = I0*exp(-(r-r0)*Ka(X)*X.*(r-r0).^q./(pk+(r-r0).^q));
end