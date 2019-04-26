%% Correction of Itotal

function [Icorr,Ucorr] = externalPosCorrFinal(I,U,R0field,R)
Icorr = I;
Ucorr = U;

outPos = find((R0field >= R) | (R0field <= 0));
Icorr(outPos) = 0;
Ucorr(outPos) = 0;

end