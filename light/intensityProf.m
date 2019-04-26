%% Light distribution with several sources

function [Itotal,Utotal,PBR] = intensityProf(PBR,solution,plotQ)

    %% Temporal variables
    reactorType = PBR.reactor.type;
    internalLightSource = PBR.sources.light.internal.on;
    internalSourceNumber = PBR.sources.light.internal.number;
    externalLightSource = PBR.sources.light.external.on;
    numElements = PBR.methods.numElements;
    X = solution.C(1,solution.count);
    %% Geometry    
    switch reactorType
        case 'cylindrical'
            R = PBR.reactor.R;
            L0 = -R;
            Lf = R;
            dL = (Lf-L0)/numElements;
            PBR.methods.dL = dL;
            L = [L0:dL:Lf];
            [x,y] = meshgrid(L,L);
            r = @(x,y,xi,yi) ((x-xi).^2+(y-yi).^2).^0.5; 
        case 'planar'
            dW = PBR.reactor.W/numElements;
            dL = PBR.reactor.L/numElements;
            W2 = [0:dW:W];
            L2 = [0:dL:L];
            [x,y] = meshgrid(W2,L2);
            r = @(x,y,xi,yi) x;
            R = W;
        otherwise
            error('Reactor type not recognized');
    end

    R0field = r(x,y,0,0);

    %% Calculations
    switch internalLightSource
        case 1
            d = PBR.reactor.d;
            r0 = PBR.reactor.r0;
            [internalI,internalU,ri] = internalSourceProf(PBR,solution,r,x,y,r0,d);
        case 0
            internalI = 0;
            internalU = 0;
        otherwise
            error('Internal light source command not recognized');
    end
    
    switch externalLightSource
        case 1
            [externalI,externalU] = externalSourceProf(PBR,solution,R,R0field);
        case 0
            externalI = 0;
            externalU = 0;
        otherwise
            error('External light source command not recognized');
    end
    
    Itotal = internalI+externalI;
    Utotal = internalU+externalU;

    if internalLightSource == 1
        [Itotal,Utotal] = internalPosCorrFinal(PBR,Itotal,Utotal,ri,r0);
    end
    [Itotal,Utotal] = externalPosCorrFinal(Itotal,Utotal,R0field,R);
    %%
    if plotQ
        maxI = log10(max(max(Itotal)));
        numI = floor(10.^([0:(maxI-0)/100:maxI]));
        maxU = maxI*2;
        numU = floor(10.^([0:(maxU-0)/100:maxU]));
        figure
        subplot(1,2,1)
        plotIprof(PBR,Itotal,x,y,X,1000,400,numI,'Light distribution, umol/m2 s')
        subplot(1,2,2)
        plotIprof(PBR,Utotal,x,y,X,1000,400,numU,'Light uptake, mmmol/gDW h')
    end

end