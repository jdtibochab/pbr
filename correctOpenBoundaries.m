function model = correctOpenBoundaries(model)

for i = 1:length(model.rxns)
LB = model.lb(i);
UB = model.ub(i);

if LB <= -1000
    model.lb(i) = -1e6;
elseif UB >= 1000
    model.ub(i) = 1e6;
end

end