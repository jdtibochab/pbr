
function starchConsumptionConstraint = starchConsumptionFun(localFBA,PBR,sizePenalty,solution)

starchConsumptionConstraint = localFBA.full(PBR.methods.starchConsumptionID)*(sizePenalty)*solution.cellStarch(solution.count)/(PBR.methods.K+solution.cellStarch(solution.count))*(solution.cellStarch(solution.count)>0)*(sizePenalty>0);

end