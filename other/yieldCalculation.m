function [T,Tc,fullT,fullTc] = yieldCalculation(model,fluxes,substrate)

bofID = find(model.c==1);
metIDs = find(model.S(:,bofID)<0);
mets = model.mets(metIDs);
Stoich = model.S(metIDs,bofID);

notBiomassMet = {'atp_c','adp_c','h2o_c','h_c','pi_c'};
notBiomassPos = [];
for i = 1:length(notBiomassMet)
    notBiomassPos = [notBiomassPos;strmatch(notBiomassMet{i},mets)];
end
biomassMet = mets;
biomassMet(notBiomassPos) = [];
biomassStoich = Stoich;
biomassStoich(notBiomassPos,:) = [];
biomassMetIDs = findMetIDs(model,biomassMet);

Stoich = biomassStoich;
mets = biomassMet;
metIDs = biomassMetIDs;

%%
exchangeRxnIDs = find(findExcRxns(model));
exchangeRxns = model.rxns(exchangeRxnIDs);

for e = 1:length(exchangeRxnIDs)
    exchangeMets(e,1) = findMetsFromRxns(model,exchangeRxns{e});
    exchangeMetIDs(e,1) = findMetIDs(model,exchangeMets{e});
    convFac(e,1) = numAtomsOfElementInFormula(char(model.metFormulas(exchangeMetIDs(e))),'C');
end

carbonYields = find(convFac>0);
convFac(convFac==0) = 1;

%%
substrateRxnID = findRxnIDs(model,substrate);
substrateMetID = find(model.S(:,substrateRxnID)~=0);
convFacSubs = numAtomsOfElementInFormula(char(model.metFormulas(substrateMetID)),'C');

%%
% out = optimizeCbModel(model,'max','one');

[molarX,compMolarMass,av] = calculateFormula(model,metIDs,abs(Stoich));
testX = abs(sum(Stoich.*compMolarMass));

if abs(testX-1) > 0.1
    warning('Mass balance not met')
end

rS = abs(fluxes(strmatch(substrate,model.rxns))*convFacSubs);
rX = fluxes(model.c==1)/molarX*av(1);
Ysx = rX/rS;

for j = 1:length(exchangeMets)
    r(j,1) = fluxes(exchangeRxnIDs(j))*convFac(j);
    Y(j,1) = r(j,1)/rS;
end

%%
Mc = ['X';exchangeMets(carbonYields)];
Yc = [Ysx;Y(carbonYields,:)];
fullTc(:,1) = Mc;
fullTc(:,2:length(Stoich(1,:))+1) = num2cell(Yc);

M = ['X';exchangeMets];
Y = [Ysx;Y];
fullT(:,1) = M;
fullT(:,2:length(Stoich(1,:))+1) = num2cell(Y);

M = M(find(~all(Y==0,2)));
Mc = Mc(find(~all(Yc==0,2)));

Y = Y(find(~all(Y==0,2)),:);
Yc = Yc(find(~all(Yc==0,2)),:);

T(:,1) = M;
T(:,2:length(Stoich(1,:))+1) = num2cell(Y);

Tc(:,1) = Mc;
Tc(:,2:length(Stoich(1,:))+1) = num2cell(Yc);

function [avMolarMass,molarMass,av,Num,formula] = calculateFormula(model,metIDs,weight)

formulas = model.metFormulas(metIDs);
for m = 1:length(formulas)
    Rnum(m,1) = numAtomsOfElementInFormula(formulas{m},'R');
    
    Cnum(m,1) = numAtomsOfElementInFormula(formulas{m},'C') + 16*Rnum(m,1);
    Hnum(m,1) = numAtomsOfElementInFormula(formulas{m},'H') + 32*Rnum(m,1);
    Onum(m,1) = numAtomsOfElementInFormula(formulas{m},'O') + 2*Rnum(m,1);
    Nnum(m,1)= numAtomsOfElementInFormula(formulas{m},'N');
    Pnum(m,1) = numAtomsOfElementInFormula(formulas{m},'P');
    Snum(m,1) = numAtomsOfElementInFormula(formulas{m},'S');
    
    molarMass(m,1) = (Cnum(m)*12+Hnum(m)+Onum(m)*16+Nnum(m)*14+Snum(m)*32+Pnum(m)*31)/1000;
end
%% Average

avC = sum(Cnum.*weight)/sum(weight);
avH = sum(Hnum.*weight)/sum(weight);
avO = sum(Onum.*weight)/sum(weight);
avN = sum(Nnum.*weight)/sum(weight);
avP = sum(Pnum.*weight)/sum(weight);
avS = sum(Snum.*weight)/sum(weight);


av = [avC;avH;avO;avN;avP;avS];
Num = [Cnum,Hnum,Onum,Nnum,Pnum,Snum];

formula = ['C ','  H ',num2str(avH/avC),'  O ',num2str(avO/avC),'  N ',num2str(avN/avC),'  S ',num2str(avS/avC),'  P ',num2str(avP/avC)];
% disp(formula)
avMolarMass = (avC*12+avH+avO*16+avN*14+avS*32+avP*31)/1000; % g/mmol


