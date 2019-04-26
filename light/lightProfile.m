function [intensityProfile,lightCondProfile] = lightProfile(tspan,initialI,finalI,strategy,lightp,varargin)
    j = 0;
    k = 0;
    intensityProfile = zeros(1,length(tspan));
    lightCondProfile = zeros(1,length(tspan));
    for i=1:length(tspan)
       lightCond = lightdarkcycle(lightp,tspan(i)+1);
       if lightCond
           lightCondProfile(i) = 1;
       end
       k = k + lightCond;
    end
    switch strategy
        case 'ramp'
            a = (finalI-initialI)/(tspan(k)-tspan(1));
            b = initialI;
            I = @(t) a*t+b;
        case 'parabolic'
            a = (finalI-initialI)/(tspan(k)^2-tspan(1)^2);
            b = initialI-a*tspan(1)^2;
            I = @(t) a*t^2+b;
        case 'exponential'
            b = (log(finalI)-log(initialI))/(tspan(k)-tspan(1));
            a = exp(log(finalI)-b*tspan(k));
            I = @(t) a*exp(b*t);
        case 'exponential2'
            b = (log10(finalI)-log10(initialI))/(log(tspan(k)-log(tspan(1))));
            a = 10^(log10(finalI)-b*log10(tspan(k)));
            I = @(t) a*t^b;
        case 'undefined'
            b = varargin{1}(1);
            a = (finalI-initialI)/(tspan(k)^b - tspan(1)^b);
            I = @(t) a*t^b + initialI;
        otherwise
            error('Light strategy not recognized \n\n')
    end
    for i=1:length(tspan)
        lightCond = lightdarkcycle(lightp,tspan(i));
        switch lightCond
            case 1
                j = j+1;
                intensityProfile(i) = I(tspan(j));
            case 0
                intensityProfile(i) = 0;
        end
    end
end