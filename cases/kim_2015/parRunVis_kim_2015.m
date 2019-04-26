%% Visualization of primary data
load('kim_2015_reg848.mat')

%% 
figure
box on
% colorIDs = {'#ff7f00';'#e41a1c';'#984ea3';'#ffffb3';'#377eb8';'#4daf4a';'#a65628'};
% colors = hex2rgb(colorIDs)
colors = parula(length(solution));
markers = {'o','s','d','^','v','*'};
for i = 1:length(solution)
    C = 336;    
    cases{i}.experimental.growth = ['kim_2015_',num2str(range(i))];
    data{i} = experimentalData(cases{i});
    hold on
    tspan_temp = cases{i}.methods.tspan;
    totalX_temp = solution{i}.C(3,:);
    plot(tspan_temp,totalX_temp,'color', colors(i,:),'LineWidth',1)
    plot(data{i}.t,data{i}.totalX,markers{i},'color',colors(i,:))
    
end
hold off
xlabel('Culture time, h')
ylabel('Biomass concentration, g/L')
legendTxt = {};
for i = 1:length(range)
    legendTxt{1,end+1} = num2str(range(i));
    legendTxt{1,end+1} = ' ';
end
legend(legendTxt)

%%
figure
colors = {'c','k','b','g','r','m'};
markers = {'o','s','d','^','v','*'};
for i = 1:length(solution)
    C = 336;
    tspan_temp = solution{i}.t(1:C);
    X_temp = solution{i}.C(1,1:C);
    totalX_temp = solution{i}.C(3,1:C);
    Starch_temp = solution{i}.C(6,1:C);
    TAG_temp = solution{i}.C(2,1:C);
    
    cases{i}.experimental.growth = ['kim_2015_',num2str(range(i))];
    data{i} = experimentalData(cases{i});
    hold on
    plot(tspan_temp,TAG_temp,colors{i})
end
hold off
xlabel('Culture time, h')
ylabel('Biomass concentration, g/L')
legendTxt = {};
for i = 1:length(range)
    legendTxt{1,end+1} = num2str(range(i));
end
legend(legendTxt)
