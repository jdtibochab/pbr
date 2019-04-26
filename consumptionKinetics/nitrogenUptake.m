
% function [Qn,rN_kin,lipidRatio] = nitrogenUptake(Qn,rN,N)
function solution = nitrogenUptake(PBR,solution)
nitrogenUptakeModel = PBR.methods.models.nitrogenUptake;
lipidYieldModel = PBR.methods.models.lipidYield;
lipidAccumulation = PBR.methods.lipidAccumulation;

Qn = solution.Qn(solution.count);
rN = solution.rN(solution.count);
N = solution.C(end,solution.count);

switch nitrogenUptakeModel
    case 'adesanya_2014'
        vnm = 0.68; % gN/gDW d
        vnm = vnm/14/24*1000; % mmolN/gDW h
        
        vnh = 0.06; % gN/m3 = mg/L. Looking at the paper, it should be g/L (x1000).
        vnh = vnh/14*1000; % mmolN/L
        
        qnm = 0.0949; % gN/gDW
        qnm = qnm/14*1000; % mmolN/gDW
        
        qn = 0.032; % gN/gDW
        qn = qn/14*1000; % mmolN/gDW
        
        rN_kin = -(qnm-Qn)/(qnm-qn)*(vnm*N)/(N+vnh)*(N>0); % mmol N/ gDW h
        dQn = (abs(rN_kin)-abs(rN));
        Qn = Qn+dQn;
        q = Qn/qnm;

        switch lipidYieldModel
            case 'linear'
                lipidRatio = 1-q;
            case 'sin'
                lipidRatio = 1-sin(pi()/2*q);
            case 'sin2'
                lipidRatio = 1-(sin(pi()/2*q))^2;
            case 'm-m'
                lipidRatio = 1-q/(q+PBR.methods.qh);
            case 'circle'
                lipidRatio = 1-sqrt(1-(1-q)^2);
            otherwise
                error('Lipid yield model not recognized')
        end
    case 'none'
        rN_kin = rN;
        lipidRatio = 0;
        return;
    otherwise
        error('Nitrogen uptake model not recognized')
end

solution.Qn(solution.count+1) = Qn;
solution.lipidRatio(solution.count+1) = lipidRatio*lipidAccumulation;
solution.r(end,solution.count) = rN_kin;


end