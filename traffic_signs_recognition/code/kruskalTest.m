function [output] = kruskalTest(data, thresholdKruskal, dataset)
    path = strcat('../results/kruskal/train', dataset);

    dim = size(data.features);
    kruskal = zeros(dim(1,2), 1);

    for i = 1:dim(1,2)
        kruskal(i) = kruskalwallis(data.features(:, i), data.target, 'off');
    end
    
    figure('Visible','off');
    plot(kruskal)
    
    xlabel('Features')
    ylabel('Score')
    title('Kruskal Test Score')
    
    filename = strcat(path, 'kruskal.png');
    saveas(gcf, filename);
    
    output = find(kruskal <= thresholdKruskal);
end

