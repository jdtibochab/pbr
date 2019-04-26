
function [relativefreq,rangeI,rangeU] = divideI(solution,I,U,plotQ)

%% Temporal variables

lightCond = solution.lightCondProfile(solution.count);
numIntervals = solution.numIntervals;
%% Calculation
switch lightCond
    case 1
        Umax = max(max(U));
        Umin = 0.01; % Not to include 0 entries in I inside the lamps.
        
        initialRange = log10(Umin);
        finalRange = log10(Umax);
        rangeU = 10.^(linspace(initialRange,finalRange,numIntervals+1));
        I = I(:);
        U = U(:);
        [ncount,ind] = histc(U,rangeU);
        Icount = [];

        for i = 1:length(rangeU)
            pos = find(ind==i);
            if ~isempty(pos)
                Icount{i} = I(pos);
                rangeI(1,i) = sum(Icount{i})/length(Icount{i});
            else
                rangeI(1,i) = 0;
            end
        end
        
        relativefreq = ncount/length(U);
        relativefreq = relativefreq/sum(relativefreq);
        
        if plotQ == 1
            bar(rangeU,relativefreq,'histc');
            title('Light intensity bar plot')
            xlabel('Intensity, {\mu}E/m2 s')
            ylabel('Relative frequency')
        end
    case 0
        relativefreq = 1;
        rangeU = 0;
        rangeI = 0;
end
end