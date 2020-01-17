function [] = main(scenario, dataset, normalize, selection, thresholdKruskal, thresholdCorrelation, reduction, classifier, criteria, criteriaThreshold)
        
    trainpath = strcat('../structures/datasets/train', dataset);
    filename = strcat(trainpath, '.mat');
    testpath = strcat('../structures/datasets/test', dataset);
    filename4 = strcat(testpath, '.mat');
    
    % ---------------------------------------------------------------
    % PRE-PROCESSING
    % --------------
     
    if (exist (filename, 'file') == 0)
        disp('Pre-Processing the Training Data');
        trainData = preProcess(filename, dataset, type); %TODO: Not done
        disp('Training Data Pre-Processed Successfully');
    end
    
    if (exist (filename4, 'file') == 0)
        disp('Pre-Processing the Testing Data');
        testData = preProcess(filename4, dataset, type); %TODO: Not done
        disp('Testing Data Pre-Processed Successfully');
    end
    
    % ---------------------------------------------------------------
    % NORMALIZATION
    % -------------
    
    if normalize == "Yes"
        filename2 = strcat(trainpath, 'normalized.mat');
        filename5 = strcat(testpath, 'normalized.mat');
        %Training
        if exist (filename2, 'file') == 0
            disp('Normalizing the Training Data...');
            trainData = normalizing(filename, dataset, 'train');
            disp('Trainning Data Normalized Successfully');
        else 
            disp('Loading the Normalized Training Data...');
            trainData = load(filename2);
            disp('Normalized Training Data Loaded Successfully!');
        end
        %Testing
        if exist (filename5, 'file') == 0
            disp('Normalizing the Testing Data...');
            testData = normalizing(filename4, dataset, 'test');
            disp('Testing Data Normalized Successfully');
        else 
            disp('Loading the Normalized Testing Data...');
            testData = load(filename5);
            disp('Normalized Testing Data Loaded Successfully!');
        end
    else       
        disp('Loading the Training Dataset...');
        trainData = load(filename);
        disp('Data Loaded Successfully!');  
        
        disp('Loading the Testing Dataset...');
        testData = load(filename4);
        disp('Data Loaded Successfully!');  
    end
     
    expected_y = load('../structures/datasets/testReference.mat');
    trainData.target = convertClasses(scenario, trainData.target);
    expected_y.reference_teste = convertClasses(scenario, expected_y.reference_teste);
    
    
    % ---------------------------------------------------------------
    % FEATURE SELECTION
    % ----------------------
    % Correlation & Co-variance
    
    redundantsIndexes = [];
    if ismember("Correlation & Co-variance", selection)
        path2 = strcat('../structures/corrcov/train', dataset);
        filename3 = strcat(path2, 'corrcov.mat');
        
        if exist (filename3, 'file') == 0
            disp('Analyzing Correlation and Co-variance...');
            corrcov = corrVar(trainData, dataset);
            disp('Analysis Done!');
        else
            disp('Loading the Correlation & Co-variance data...');
            corrcov = load(filename3);
            disp('Loaded Successfully!');  
        end
        redundantsIndexes = findRedundants(trainData, corrcov, thresholdCorrelation);
    end
    
    % Kruskal-Test
    kruskalIndexes = [];
    if ismember("Kruskal-Test", selection)
        path2 = strcat('../structures/kruskal/train', dataset);
        filename3 = strcat(path2, 'kruskal.mat');
        if exist (filename3, 'file') == 0
            disp('Performing Kurskal Test...');
            kruskal = kruskalTest(trainData, thresholdKruskal, dataset);
            disp('Kruskal Test Performed Sucessfully!');
        else
            disp('Loading the Kruskal Test...');
            kruskal = load(filename3); 
            disp('Loaded Successfully!');  
        end
    end
    
    indexes = intersect(kruskalIndexes, redundantsIndexes);
    trainData(:, indexes) = [];

    % ---------------------------------------------------------------
    % FEATURE REDUCTION
    % -----------------
    
    
    if (reduction == "PCA")
        disp('Applying the Principal Component Analysis...');
        [trainpca, testpca] = pcaScript(trainData, testData, criteria, criteriaThreshold);
        disp('PCA Finished');
        trainData.features = trainpca.features';
        testData.features = testpca.features';
        
    elseif (reduction == "LDA")
        disp('Applying the Linear Discriminant Analysis...');
        [trainlda, testlda] = ldaScript(trainData, testData, expected_y);
        disp('LDA Finished');
        trainData.features = trainlda.features';
        testData.features = testlda.features';
        
    elseif (reduction == "PCA&LDA")
        disp('Applying the Principal Component Analysis...');
        [trainpca, testpca] = pcaScript(trainData, testData, criteria, criteriaThreshold);
        disp('PCA Finished');
        trainData.features = trainpca.features';
        testData.features = testpca.features';
        disp('Applying the Linear Discriminant Analysis...');
        [trainlda, testlda] = ldaScript(trainData, testData, expected_y);
        disp('LDA Finished');
        trainData.features = trainlda.features';
        testData.features = testlda.features';
    else
        disp('Applying the Linear Discriminant Analysis...');
        [trainlda, testlda] = ldaScript(trainData, testData, expected_y);
        disp('LDA Finished');
        trainData.features = trainlda.features';
        testData.features = testlda.features';
        disp('Applying the Principal Component Analysis...');
        [trainpca, testpca] = pcaScript(trainData, testData, criteria, criteriaThreshold);
        disp('PCA Finished');
        trainData.features = trainpca.features';
        testData.features = testpca.features';
    end
    
    % ---------------------------------------------------------------
    % CLASSIFICATION
    % --------------
    disp('Training and Testing the Model...');
    if(classifier == "Euclidean Linear Discriminant")
        predicted_y = euclidean(trainData.features', trainData.target , testData.features');
    elseif (classifier == "Mahalanobis Linear Discriminant")
        predicted_y = mahalanobis(trainData.features', trainData.target, testData.features');
    elseif (classifier == "Linear Discriminant")
        myclassifier = fitcdiscr(trainData.features, trainData.target, 'DiscrimType', 'linear');
        predicted_y = predict(myclassifier, testData.features);
    elseif (classifier == "Decision Tree")
        myclassifier = fitctree(trainData.features, trainData.target);
        predicted_y = predict(myclassifier, testData.features);
    elseif (classifier == "SVM")
        if(scenario ~= "A")
            disp("It's impossible to apply SVM classifier in a multi-class classification problem");
        else
            myclassifier = fitcsvm(trainData.features, trainData.target);
            predicted_y = predict(myclassifier, testData.features);
        end
    else %KNN
        k = round( sqrt( length(trainData.features') ) );
        
        myclassifier = fitcknn(trainData.features, trainData.target, 'NumNeighbors', k);
        predicted_y = predict(myclassifier, testData.features);

    end
    disp('Trained and Tested Successfully!');
    
    % ---------------------------------------------------------------
    % PERFORMANCE ASSESSMENT
    % ----------------------
    
    filename = strcat(scenario, '_', dataset, '_', normalize, '_' , selection, '_', num2str(thresholdKruskal), '_', num2str(thresholdCorrelation), '_', reduction, '_', classifier, '_',criteria, '_', num2str(criteriaThreshold));
    
    clearvars -except expected_y predicted_y filename scenario
    disp('Assessing de Performance of the Model...');

    assessPerformance(scenario, expected_y.reference_teste, predicted_y, filename);
    
    disp('Finished. You can access the results in the results/testing folder.');
    
end 