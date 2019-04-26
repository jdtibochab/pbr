%% Visualization of cell properties
%%
function tertiaryData(PBR,solution,data)
i = solution.count;
tspan_temp = solution.t(1:i);
X_temp = solution.C(1,1:i);
TAG_temp = solution.C(2,1:i);
totalX_temp = solution.C(3,1:i);
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
lipidRatio_temp = solution.lipidRatio(1:i);
globalPhotoinhibition_temp = solution.globalPhotoinhibition(1:i);
size_temp = solution.size(1:i);
extI0profile = PBR.methods.extI0profile(1:i);
intI0profile = PBR.methods.intI0profile(1:i);

%%
et = data.t;
eX = data.X;
etotalX = data.totalX;
eN = data.N;
eTAG = data.TAG;
eStarch = data.Starch;
eQn = data.Qn;
ecellTAG = data.cellTAG;
ecellStarch = data.cellStarch;
erx = data.rx;
erN = data.rN;
erTAG = data.rTAG;
ePI = data.globalPhotoinhibition;
esize = data.size;
eextI0 = data.extI0profile;
eintI0 = data.intI0profile;

%%

colors = hsv(5);

figure('Position',[100  0 1000 600])

subplot(2,3,1)
box on
plot(tspan_temp(1:end),lipidRatio_temp)
xlabel('Culture time, h')
ylabel('Lipid yield')

subplot(2,3,2)
box on
hold on
plot(tspan_temp,cellTAG_temp,'Color',colors(3,:))
plot(tspan_temp,cellStarch_temp,'Color',colors(2,:))
if ecellStarch ~=0 
    plot(et,ecellStarch,'o','Color',colors(2,:),'MarkerFaceColor','w')
end
if ecellTAG ~= 0
    plot(et,ecellTAG,'^','Color',colors(3,:),'MarkerFaceColor','w')
end
xlabel('Culture time, h')
ylabel('Content, g/gDW')
legend('Lipid','Starch')

subplot(2,3,3)
box on
plot(tspan_temp,Qn_temp)
xlabel('Culture time, h')
ylabel('Qn, gN source/gDW')

subplot(2,3,4)
box on
plot(tspan_temp,size_temp)
xlabel('Culture time, h')
ylabel('Cell weight, pg/cell')

end