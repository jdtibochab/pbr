%% Visualization of primary data

%%
figure
colors = {'c','k','b','g','r','m'};
markers = {'o','s','d','^','v','*'};
for i = 1:length(solution)
    C = 1000;
    tspan_temp = solution{i}.t(1:C);
    X_temp = solution{i}.C(1,1:C);
    totalX_temp = solution{i}.C(3,1:C);
    TAG_temp = solution{i}.C(2,1:C);
    Starch_temp = solution{i}.C(6,1:C);
    
    hold on
    plot(tspan_temp,Starch_temp)
    hold off
    
end
xlabel('Culture time, h')
ylabel('Biomass concentration, g/L')
 