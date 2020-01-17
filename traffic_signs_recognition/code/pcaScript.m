function [outTrain, outTest] = pcaScript(dataTrain, dataTest, criteria, criteriaThreshold)
    
    modelTrain = my_pca(dataTrain);
    projectionTrain = my_linproj(dataTrain, modelTrain, "train");
    
    modelTest = my_pca(dataTest);
    projectionTest = my_linproj(dataTest, modelTest, "test");
    
    if(criteria == "Kaiser")
        dimension = length(find(modelTrain.eigval >= criteriaThreshold));
    elseif (criteria == "Scree")
        proportion_of_variance = cumsum(modelTrain.eigval) ./ sum(modelTrain.eigval);
        dimension = length(find(proportion_of_variance >= criteriaThreshold));
    else
        aux = size(projectionTrain.features);
        dimension = aux(1);
    end
    
    
    if dimension < 1
        dimension = 1;
    end
    
    outTrain = dataTrain;
    outTrain.features = projectionTrain.features(1:dimension,:);
    outTest = dataTest;
    outTest.features = projectionTest.features(1:dimension,:);
    
end

