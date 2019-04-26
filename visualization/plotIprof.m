%% Plot intensity profile

function plotIprof(PBR,I,x,y,X,width,height,v,name)
internalSourceNumber = PBR.sources.light.internal.number;

newpoints = 200;

Xlim = [min(min(x,[],2)),max(max(x,[],2))];
Ylim = [min(min(y,[],1)),max(max(y,[],1))];

[xq,yq] = meshgrid(...
    linspace(Xlim(1),Xlim(2),newpoints),...
    linspace(Ylim(1),Ylim(2),newpoints));

Iq = interp2(x,y,I,xq,yq,'linear');
% Iq(Iq>Ilim) = Ilim;

[C,h]=contourf(xq,yq,Iq,v,'ShowText','off','LineColor','none');
colorbar

title([name,' at X = ',num2str(X),'g/L'])
xlabel('X-position, m')
ylabel('Y-position, m')

x0=10;
y0=10;

set(gcf,'units','points','position',[x0,y0,width,height])


hold off
end