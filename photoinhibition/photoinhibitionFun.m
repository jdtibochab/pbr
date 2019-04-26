
%% Photoinhibition
% Based on the model and parameters by Baroli, 1995

function theta = photoinhibitionFun(PBR,I,theta)
photoinhibitionModel = PBR.methods.models.photoinhibition;
switch photoinhibitionModel
    case 'baroli_1995'
        theta = baroli1995(I,theta,PBR.methods.dt);
    case 'none'
        theta = ones(1,length(theta));
    otherwise
        error('Photoinhibition model not recognized');
end

end