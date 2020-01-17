function [corrcov] = corrVar(data, dataset)
    path = strcat('../structures/corrcov/train', dataset);
    path1 = strcat('../results/correlation/train', dataset);
    path2 = strcat('../results/covariance/train', dataset);
    
    % ---------------------------------------------------------------
    % CO-VARIANCE
    covariance = cov(data.features);
    figure('Visible','off');
    imagesc(covariance);
    colorbar
    xlabel('Features')
    ylabel('Features')
    title('Co-Variance')
    
    filename = strcat(path2, 'covariance.png');
    saveas(gcf, filename);
    
    % ---------------------------------------------------------------
    % CORRELATION
    correlation = corrcoef(data.features);
    figure('Visible','off')
    imagesc(correlation)
    colorbar
    xlabel('Features')
    ylabel('Features')
    title('Correlation')
    filename = strcat(path1, 'correlation.png');
    saveas(gcf, filename);
    
    corrcov = struct('covariance', covariance, 'correlation', correlation);
    filename = strcat(path, 'corrcov.mat');
    save (filename, 'covariance', 'correlation', '-v7.3');
    
end

