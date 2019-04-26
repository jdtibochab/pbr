%% Visualization of reactor variables
function summaryData(solution)
PBR = solution.PBR;
experimentalDataset = PBR.experimental.growth;
data = experimentalData(PBR);

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
lipidRatio_temp = solution.lipidRatio(1:i-1);
size_temp = solution.size(1:i);

globalPhotoinhibition_temp = solution.globalPhotoinhibition(1:i);
size_temp = solution.size(1:i);
extI0profile = PBR.methods.extI0profile(1:i);
intI0profile = PBR.methods.intI0profile(1:i);

%%
et = data.t;
etN = data.tN;
eX = data.X;
etotalX = data.totalX;
eN = data.N;
eTAG = data.TAG;
eStarch = data.Starch;
eQn = data.Qn;
ecellTAG = data.cellTAG;
ecellStarch = data.cellStarch;
ecellTAG = data.cellTAG;
erx = data.rx;
erN = data.rN;
erTAG = data.rTAG;
ePI = data.globalPhotoinhibition;
esize = data.size;
eextI0 = data.extI0profile;
eintI0 = data.intI0profile;

%%

colors = {'#2c7fb8';'#f03b20';'#d95f0e';'#756bb1';'#000000'};
colors = hex2rgb(colors);

figure('Position',[100  0 900 800])

%%
subplot(2,2,1)
yyaxis left
box on
hold on

plot(tspan_temp,X_temp,'-','Color',colors(1,:),'LineWidth',1)
plot(tspan_temp,Starch_temp,'-','Color',colors(2,:),'LineWidth',1)
plot(tspan_temp,TAG_temp,'-','Color',colors(3,:),'LineWidth',1)
plot(tspan_temp,totalX_temp,'-','Color',colors(4,:),'LineWidth',1)

e = 0;
if ~all(etotalX == 0)
    e = e+1;
    plot(et,etotalX,'o','Color',colors(4,:),'LineWidth',1,'MarkerFaceColor','w')
end
if ~all(eStarch == 0)
    e = e+1;
    plot(et,eStarch,'^','Color',colors(2,:),'LineWidth',1,'MarkerFaceColor','w')
end
if ~all(eTAG == 0)
    e = e+1;
    plot(et,eTAG,'v','Color',colors(3,:),'LineWidth',1,'MarkerFaceColor','w')
end
if e == 3
    eX = etotalX - eStarch - eTAG;
    plot(et,eX,'s','Color',colors(1,:),'LineWidth',1,'MarkerFaceColor','w');
end
ylabel('Concentration, g L^{-1}')
hold off

yyaxis right
plot(tspan_temp,N_temp,'-','Color',colors(5,:),'LineWidth',1)
if ~all(eN == 0)
    if  all(etN == 0)
        etN = et;
    end
    plot(etN,eN,'o','Color',colors(5,:),'LineWidth',1,'MarkerFaceColor','w')
end
xlabel('Culture time, h')
ylabel('N concentration, mmol L^{-1}')
legend({'Non-storage','Starch','Lipids','Total',experimentalDataset},'Interpreter', 'none')
xlim([0 tspan_temp(end)+5])


%%
subplot(2,2,2)
box on
hold on
yyaxis left
ylabel('Content, g gDW^{-1}')
xlabel('Culture time, h')
if ecellStarch ~=0 
    plot(et,ecellStarch,'o','Color',colors(2,:),'MarkerFaceColor','w')
end
if ecellTAG ~= 0
    plot(et,ecellTAG,'^','Color',colors(3,:),'MarkerFaceColor','w')
end
plot(tspan_temp,cellStarch_temp,'-','Color',colors(2,:),'LineWidth',1);
plot(tspan_temp,cellTAG_temp,'-','Color',colors(3,:),'LineWidth',1)
yyaxis right
plot(tspan_temp,Qn_temp,'-k','LineWidth',1)
ylabel('Qn, mmolN gDW^{-1}')
legend('Starch content','Lipid content','Nitrogen quota')
xlim([0 tspan_temp(end)+5])
%%
subplot(2,2,3)
box on
hold on
yyaxis left
plot(tspan_temp(1:end-1),rTAG_temp.*X_temp(1:end-1),'Color',colors(1,:),'LineWidth',1)
xlabel('Culture time, h')
ylabel('Lipid productivity, g L^{-1}h^{-1}')

yyaxis right
ylabel('Lipid yield')
plot(tspan_temp(1:end-1),lipidRatio_temp,'-k','LineWidth',1);
xlim([0 tspan_temp(end)+5])
legend('Lipid productivity','Lipid yield')

%%
subplot(2,2,4)
box on
plot(tspan_temp,size_temp/size_temp(1),'LineWidth',1)
xlabel('Culture time, h')
ylabel('Relative size')
xlim([0 tspan_temp(end)+5])

% plot(tspan_temp,extI0profile(1:length(tspan_temp)),tspan_temp,intI0profile(1:length(tspan_temp)),'LineWidth',1)
% xlabel('Culture time, h')
% ylabel('Intensity, uE/m2s')
% legend('External Source','Internal Source')

end