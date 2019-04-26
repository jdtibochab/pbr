function [totalMolarMass,molarMass] = calculateFormula(model,metIDs,weight)
formulas = model.metFormulas(metIDs);
for m = 1:length(formulas)
    Cnum(m,1) = numAtomsOfElementInFormula(formulas{m},'C');
    Hnum(m,1) = numAtomsOfElementInFormula(formulas{m},'H');
    Onum(m,1) = numAtomsOfElementInFormula(formulas{m},'O');
    Nnum(m,1) = numAtomsOfElementInFormula(formulas{m},'N');
    Pnum(m,1) = numAtomsOfElementInFormula(formulas{m},'P');
    Snum(m,1) = numAtomsOfElementInFormula(formulas{m},'S');
    molarMass(m,1) = (Cnum(m)*12+Hnum(m)+Onum(m)*16+Nnum(m)*14+Snum(m)*32+Pnum(m)*31)/1000; % g/mmol
end
%% Average
totalMolarMass = abs(sum(molarMass.*weight))/1; % All mass in 1 mmol.

end