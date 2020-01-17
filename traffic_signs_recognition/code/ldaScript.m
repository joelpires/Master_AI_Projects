function [outTrain, outTest] = ldaScript(dataTrain, dataTest, expected_y)

    categories = length(unique(dataTrain.target)) - 1;

    trainModel = my_lda(dataTrain, categories);
    trainProjection = my_linproj(dataTrain, trainModel, "train");
    
    categories = length(unique(expected_y.reference_teste)) - 1;
    dataTest.features = dataTest.features;
    dataTest.target = expected_y.reference_teste;
    testModel = my_lda(dataTest, categories);
    testProjection = my_linproj(dataTest, testModel, "test");    
    
    outTrain = dataTrain;
    outTrain.features = trainProjection.features;
    outTest = dataTest;
    outTest.features = testProjection.features;

end

