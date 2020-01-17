function newFeatVectSel = analyseCorrelation(handles)
    load(handles.trainingSet);
    
    aux = size(FeatVectSel);
    limit = aux(2);
    
    if (handles.characteristics > limit || handles.characteristics < 1)
        handles.characteristicss = limit;
    end

    concat = horzcat(FeatVectSel, Trg);
    temp = size(concat);
    
    
    [r, p] = corrcoef(concat);
    
    cor = r(temp(2), 1:limit);
    cor = abs(cor);

    [~, ind] = sort(cor, 'descend');
    newFeatVectSel = FeatVectSel(:, ind(1:handles.characteristics));
end