%For a patient, a number of interictal points at most equal to the sum of the points of the
%other classes should be chosen, for example randomly. This corresponds to an
%undersampling of the interictal phase.
%
function [ trainFeatVect, trainTrgMatrix, testFeatVect, testTrgMatrix ] = prepareDatasets( handles )
    
    load(handles.trainingSet);
    
    %lets modify the target vector
    [modifiedTarget, crysisStart, crysisEnd] = modifyTarget(Trg);
    
    %creating a matrix from modifiedTarget vector
    targetMatrix = zeros(length(modifiedTarget),4);
    for i=1:length(modifiedTarget)
        targetMatrix(i,modifiedTarget(i)) = 1;
    end
    
    numberCrysis = length(crysisStart);
    
    nCrysisTraining = round(numberCrysis*(1-handles.testPercentage));
    
    %TRAINING
    crysisPointsTraining = [];
    
    for i=1:nCrysisTraining
      crysisPointsTraining = [crysisPointsTraining crysisStart(i):1:crysisEnd(i)];
    end
    
    numberInterIctalPoints = length(modifiedTarget) - length(crysisPointsTraining);
    
    if(handles.balance & (numberInterIctalPoints) > length(crysisPointsTraining))
        numberInterIctalPoints = length(crysisPointsTraining);
    end
    
    interIctalPointsTraining = find(modifiedTarget == 1)';
    interIctalPointsTraining = interIctalPointsTraining(1:numberInterIctalPoints);
    
    %Building training data
    trainIndexes = [interIctalPointsTraining crysisPointsTraining];
    trainIndexes = sort(trainIndexes);
    trainFeatVect = handles.FeatVectSel(trainIndexes, :)';
    trainTrgMatrix = targetMatrix(trainIndexes, :)'; 
    
    datasetIndexes = 1:length(handles.FeatVectSel);
    
    %TESTING
    testIndexes = setdiff(datasetIndexes,trainIndexes);
    testFeatVect = handles.FeatVectSel(testIndexes, :)';
    testTrgMatrix = targetMatrix(testIndexes, :)';
    
end

    