%% Visualization of primary data

%%
figure

for i = 1:length(solution)
    C = 300;
    tspan_temp = solution{i}.t(1:C);
    X_temp = solution{i}.X(1:C);
    totalX_temp = solution{i}.totalX(1:C);
    TAG_temp = solution{i}.TAG(1:C);
    
    Z(:,i) = totalX_temp;
end

[Xplot,Yplot] = meshgrid(range,tspan_temp);

surf(Xplot,Yplot,Z)

xlabel('Range')
ylabel('Time, h')
zlabel('Biomass, g/L')
