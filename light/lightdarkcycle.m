%% Light/Dark cycles

function lightCond = lightdarkcycle(lightp,t)
    
    c0 = lightp/24;

    a = floor(t/24);
    b = t - 24*a;
    c = b/24;
    
    for i = 1:length(t)
        if c(i)<c0
            lightCond(i) = 1;
        else
            lightCond(i) = 0;
        end
    end
end