%% Visualization of rates
%%
function secondaryData(PBR,solution,data)
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
rStarch_temp = solution.r(6,1:i-1);
rC_temp = solution.r(4,1:i-1);
rO2_temp = solution.r(5,1:i-1);
rN_kin_temp = solution.r(end,1:i-1);
rN_temp = solution.rN(1:i-1);

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
erx = data.rx;
erN = data.rN;
erTAG = data.rTAG;
ePI = data.globalPhotoinhibition;
esize = data.size;
eextI0 = data.extI0profile;
eintI0 = data.intI0profile;

%%
figure('Position',[100  0 1000 600])

subplot(2,3,1)
box on
plot(tspan_temp(1:end-1),rx_temp)
xlabel('Culture time, h')
ylabel('\mu, h^{-1}')

subplot(2,3,2)
box on
plot(tspan_temp(1:end-1),rN_temp,tspan_temp(1:end-1),rN_kin_temp)
xlabel('Culture time, h')
ylabel('r_N, mmol N/gDW h')
legend('Demand','Inlet')

subplot(2,3,3)
box on
plot(tspan_temp(1:end-1),rTAG_temp,tspan_temp(1:end-1),rStarch_temp)
xlabel('Culture time, h')
ylabel('r_{Storage}, g/gDW h')
legend('Lipid','Starch')

subplot(2,3,4)
box on
plot(tspan_temp(1:end-1),rC_temp)
xlabel('Culture time, h')
ylabel('r_C, mmolC/gDWh')

subplot(2,3,5)
box on
plot(tspan_temp(1:end-1),rO2_temp)
xlabel('Culture time, h')
ylabel('r_{O_2}, mmolO2/gDWh')

end

