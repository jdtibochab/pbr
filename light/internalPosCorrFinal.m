%% Correction of Itotal

function [Icorr,Ucorr] = internalPosCorrFinal(PBR,I,U,ri,r0)
internalSourceNumber = PBR.sources.light.internal.number;

Icorr = I;
Ucorr = U;

for i=1:internalSourceNumber
    outPos = find(ri{i} <= r0);
    Icorr(outPos) = 0;
    Ucorr(outPos) = 0;
end

end