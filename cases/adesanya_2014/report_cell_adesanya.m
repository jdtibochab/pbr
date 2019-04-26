%% Visualization of reactor variables
function report_cell_adesanya(solution)
PBR = solution.PBR;
data = experimentalData(PBR);
experimentalDataset = PBR.experimental.growth;
%%
i = solution.count;
tspan_temp = solution.t(1:i);
X_temp = solution.C(1,1:i);
TAG_temp = solution.C(2,1:i);
Starch_temp = solution.C(6,1:i);
totalX_temp = solution.C(3,1:i);
CO2_temp = solution.C(4,1:i);
O2_temp = solution.C(5,1:i);
N_temp = solution.C(end,1:i);

Qn_temp = solution.Qn(1:i);
cellTAG_temp = solution.cellTAG(1:i);
cellStarch_temp = solution.cellStarch(1:i);
rx_temp = solution.r(1,1:i-1);
rTAG_temp = solution.r(2,1:i-1);
rC_temp = solution.r(4,1:i-1);
rO2_temp = solution.r(5,1:i-1);
rN_temp = solution.r(end,1:i-1);
rN_kin_temp = solution.rN_kin(1:i-1);

globalPhotoinhibition_temp = solution.globalPhotoinhibition(1:i);
size_temp = solution.size(1:i);
extI0profile = PBR.methods.extI0profile(1:i);
intI0profile = PBR.methods.intI0profile(1:i);

%%
et = data.t;
etN = data.tN;
etotalX = data.totalX;
eN = data.N;
eTAG = data.TAG;
eStarch = data.Starch;
eQn = data.Qn;
erx = data.rx;
erN = data.rN;
erTAG = data.rTAG;
ePI = data.globalPhotoinhibition;
esize = data.size;
eextI0 = data.extI0profile;
eintI0 = data.intI0profile;

eQn = data.Qn;
ecellTAG = data.cellTAG;
ecellStarch = data.cellStarch;
eX = etotalX - eStarch - eTAG;
%%

colors = {'#2c7fb8';'#f03b20';'#d95f0e';'#756bb1';'#000000'};
colors = hex2rgb(colors);

box on
hold on
yyaxis left
plot(tspan_temp,cellStarch_temp,'-','Color',colors(2,:),'LineWidth',1)
plot(tspan_temp,cellTAG_temp,'-','Color',colors(3,:),'LineWidth',1)
ylim([0 1])

yyaxis right
plot(tspan_temp,Qn_temp,'-','Color',colors(5,:),'LineWidth',1)
ylabel('Qn, mmolN/gDW')
yyaxis left
plot(et,ecellStarch,'^','Color',colors(2,:),'LineWidth',1,'MarkerFaceColor','w')
plot(et,ecellTAG,'o','Color',colors(3,:),'LineWidth',1,'MarkerFaceColor','w')

xlabel('Culture time, h')
ylabel('Content, g/gDW')
legend({'Starch','Lipids','Nitrogen','',''},'Interpreter', 'none')
hold off


end