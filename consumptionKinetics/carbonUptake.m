function kinCarbonConstraint = carbonUptake(PBR,solution)

carbonUptakeModel = PBR.methods.models.carbonUptake;
maxCarbonConstraint = PBR.methods.maxCarbonUptake;
C = solution.C(4,solution.count); % mmol/L
X = solution.cellNumber(solution.count)*1e-9; % 10^9 cell/L

switch carbonUptakeModel
    case 'filali_2011'
        Kc = 1.28e-5; %mol/10^9 cell
            Kc = Kc*1000; %mmol/10^9 cell
        kinCarbonConstraint = maxCarbonConstraint * C/(Kc*X+C); % mol/L
    case 'none'
        kinCarbonConstraint = PBR.methods.carbonConstraint;
    otherwise
        error('Carbon uptake model not recognized')

end

