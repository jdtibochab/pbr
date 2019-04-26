%% Visualization of reactor variables
function primaryData(PBR,solution,data)
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
eX = data.X;
etotalX = data.totalX;
eN = data.N;
eTAG = data.TAG;
eStarch = data.Starch;
eQn = data.Qn;
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

figure('Position',[100  0 1000 600])

subplot(2,3,1)
box on
hold on

plot(tspan_temp,X_temp,'Color',colors(1,:),'LineWidth',1)
plot(tspan_temp,Starch_temp,'Color',colors(2,:),'LineWidth',1)
plot(tspan_temp,TAG_temp,'Color',colors(3,:),'LineWidth',1)
plot(tspan_temp,totalX_temp,'Color',colors(4,:),'LineWidth',1)

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

xlabel('Culture time, h')
ylabel('Biomass concentration, g/L')
legend({'Non-storage','Starch','Lipids','Total',experimentalDataset},'Interpreter', 'none')
hold off

subplot(2,3,2)
hold on
box on
plot(tspan_temp,N_temp,'Color',colors(5,:),'LineWidth',1)
if ~all(eN == 0)
    if  all(etN == 0)
        etN = et;
    end
    plot(etN,eN,'o','Color',colors(5,:),'LineWidth',1,'MarkerFaceColor','w')
end
xlabel('Culture time, h')
ylabel('Nitrate concentration, mmol/L')
legend({'Predicted',experimentalDataset},'Interpreter', 'none')
hold off

subplot(2,3,3)
box on
plot(tspan_temp(1:end),globalPhotoinhibition_temp,'LineWidth',1)
xlabel('Culture time, h')
ylabel('Global photoinhibition')

subplot(2,3,4)
box on
plot(tspan_temp,extI0profile(1:length(tspan_temp)),tspan_temp,intI0profile(1:length(tspan_temp)),'LineWidth',1)
xlabel('Culture time, h')
ylabel('Intensity, uE/m2s')
legend('External Source','Internal Source')

subplot(2,3,5)
box on
plot(tspan_temp(1:end-1),rTAG_temp.*X_temp(1:end-1),'LineWidth',1)
xlabel('Culture time, h')
ylabel('Lipid productivity, gLipids/L h')

subplot(2,3,6)
box on
plot(tspan_temp,CO2_temp,'LineWidth',1)
xlabel('Culture time, h')
ylabel('CO2, mmol/L')

end