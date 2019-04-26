%% Visualization of primary data

%%
figure
colors = {'c','--c','k','--k','b','--b','g','--g','r','--r','m','--m'};
markers = {'o','s','d','^','v','*'};
legendTxt = {};
figure;
for i = 1:length(solution)
    C = solution{i}.count;
    tspan_temp = solution{i}.t(1:C);
    totalLP_temp = cases{i}.inlet.D * solution{i}.C(2,1:C);
    
    hold on
    plot(tspan_temp,totalLP_temp,colors{i})
    legendTxt{1,end+1} = num2str(range(i));
    
end

xlabel('Culture time, h')
ylabel('Lipid productivity, g/Lh')
legend(legendTxt)
%%
figure
for i = 1:length(solution)
    C = solution{i}.count;
    tspan_temp = solution{i}.t(1:C);
    TAG_temp = solution{i}.C(2,1:C);
    
    hold on
    plot(tspan_temp,TAG_temp,colors{i})    
end
xlabel('Culture time, h')
ylabel('Lipid concentration, g/L')
legend(legendTxt)

%%

figure
for i = 1:length(solution)
    C = solution{i}.count;
    tspan_temp = solution{i}.t(1:C);
    cellTAG_temp = solution{i}.cellTAG(1:C);
    
    hold on
    plot(tspan_temp,cellTAG_temp,colors{i})    
end
xlabel('Culture time, h')
ylabel('Lipid content, g/gDW')
legend(legendTxt)

%%
figure
for i = 1:length(solution)
    C = solution{i}.count;
    tspan_temp = solution{i}.t(1:C);
    cellStarch_temp = solution{i}.cellTAG(1:C);
    
    hold on
    plot(tspan_temp,cellStarch_temp,colors{i})    
end
xlabel('Culture time, h')
ylabel('Starch content, g/gDW')
legend(legendTxt)

%%
figure
for i = 1:length(solution)
    C = solution{i}.count;
    tspan_temp = solution{i}.t(1:C);
    N_temp = solution{i}.C(end,1:C);
    
    hold on
    plot(tspan_temp,N_temp,colors{i})    
end
xlabel('Culture time, h')
ylabel('Nitrogen concentration, g/L')
legend(legendTxt)
