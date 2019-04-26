
function solution = sizePenaltyFun(PBR,solution)

sizePenaltyModel = PBR.methods.models.sizePenalty;
minSize = PBR.experimental.minSize;
maxSize = PBR.experimental.maxSize;
size = solution.size(solution.count);

switch sizePenaltyModel
    case 'simple'
        sizePenalty=(size-minSize)/(maxSize-minSize);
    case 'none'
        sizePenalty=0;
end

if sizePenalty > 1
    sizePenalty = 1;
elseif sizePenalty < 0
    sizePenalty = 0;
end

solution.sizePenalty(solution.count+1) = sizePenalty;

end