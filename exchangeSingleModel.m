function [ExchangeD,DataD] = exchangeSingleModel(model)
%model=coliW;%S. cerevisiae
    %Identify exchange reactions in D
        % ExRxnsD = strfind(model.rxnNames,'exchange');
        % IndexD= find(not(cellfun('isempty', ExRxnsD)));
        DExRxns = strmatch('EX_',model.rxns); %
        FBA_D=optimizeCbModel(model);
    ExchangeD={};
    for i=1:numel(DExRxns)
        ExchangeD{i,1}=DExRxns(i); ExchangeD{i,2}=model.rxns{DExRxns(i)};
        ExchangeD{i,3}=model.rxnNames{DExRxns(i)};
        ExchangeD{i,4}=printRxnFormula(model,model.rxns{DExRxns(i)},false);
        str = char(model.mets(model.S(:,DExRxns(i))<0));
        ExchangeD{i,5} =str(1:end-1); ExchangeD{i,6}=model.lb(DExRxns(i));
        ExchangeD{i,7}=model.ub(DExRxns(i));
        if ~isempty(FBA_D.x)
        ExchangeD{i,8}=FBA_D.x(DExRxns(i));
        else
            ExchangeD{i,8}=0;
        end
    end
    %filtering by lower bound different from 0
    Ind=find([ExchangeD{:,6}]);
    Ind=Ind';
    DataD={};
    for i=1:numel(Ind)
     DataD{i,1}=ExchangeD{Ind(i),1}; DataD{i,2}=ExchangeD{Ind(i),2};
     DataD{i,3}=ExchangeD{Ind(i),3}; DataD{i,4}=ExchangeD{Ind(i),4};
     DataD{i,5}=ExchangeD{Ind(i),5}; DataD{i,6}=ExchangeD{Ind(i),6};
     DataD{i,7}=ExchangeD{Ind(i),7};
     DataD{i,8}=ExchangeD{Ind(i),8};
    end%
    DataD = cell2table(DataD,...
    'VariableNames',{'Index' 'A_Rxn' 'B_Name' 'C_eq' 'Met' 'D_lb' 'E_ub' 'Flux'});
    ExchangeD = cell2table(ExchangeD,...
    'VariableNames',{'Index' 'A_Rxn' 'B_Name' 'C_eq' 'Met' 'D_lb' 'E_ub' 'Flux'});

end