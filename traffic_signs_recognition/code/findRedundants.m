function [redundantsIndexes] = findRedundants(data, corrcov, thresholdCorrelation)
    
    dim = size(data.features);
    redundants = zeros(dim(1,2),1);

    for i = 1:dim(1,2)
        temp = find(abs(corrcov.correlation(i, i+1:end)) >= thresholdCorrelation);
        if ~isempty(temp)
            temp = temp+i;
            redundants(i) = 1;
            redundants(temp) = 1;
        end
    end
    
    redundantsIndexes = find( redundants == 1 );
end

