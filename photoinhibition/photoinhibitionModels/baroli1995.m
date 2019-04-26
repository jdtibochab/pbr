%% Naderi et al. light distribution model

function theta = baroli1995(I,theta,dt)
kd = @(I) (I<1e-5).*0.*I + (I>1e-5).*(4.2e-4*I+0.05);% h^-1
kr = 0.7; % h^-1

dTheta = -kd(I).*theta+kr*(1-theta);
theta = theta+dTheta*dt;
theta(theta<0) = 0;
end