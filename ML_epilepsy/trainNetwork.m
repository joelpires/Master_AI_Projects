
function [ net ] = trainNetwork( trainingSet, trainFeatVect, trainTrgMatrix, Net, handles)
    disp('Training the Network...')
    load(trainingSet);
    
    
    %ERROR WEIGHTS ADJUSTMENT AND SPECIALIZATION
    weightsErrors = ones(1,length(handles.FeatVectSel));
    
    interIctalIndexes = find(trainTrgMatrix(1,:) == 1);
    preIctalIndexes = find(trainTrgMatrix(2,:) == 1);
    crysisIndexes = find(trainTrgMatrix(3,:) == 1);
    posIctalIndexes = find(trainTrgMatrix(4,:) == 1);
    
    if strcmp(handles.preference, 'prever') == 1
        weightsErrors(preIctalIndexes) = 1;
        if strcmp(handles.specialization, 'alta') == 1
            weightsErrors(interIctalIndexes) = 0.01;
            weightsErrors(crysisIndexes) = 0.02;
            weightsErrors(posIctalIndexes) = 0.03;
            
        elseif strcmp(handles.specialization,'media') == 1
            weightsErrors(interIctalIndexes) = 0.1;
            weightsErrors(crysisIndexes) = 0.2;
            weightsErrors(posIctalIndexes) = 0.3;
            
            
        elseif strcmp(handles.specialization,'baixa') == 1
            weightsErrors(interIctalIndexes) = 0.6;
            weightsErrors(crysisIndexes) = 0.7;
            weightsErrors(posIctalIndexes) = 0.8;
        end
        
    else
        weightsErrors(crysisIndexes) = 1;
        if strcmp(handles.specialization, 'alta') == 1
            weightsErrors(interIctalIndexes) = 0.01;
            weightsErrors(preIctalIndexes) = 0.02;
            weightsErrors(posIctalIndexes) = 0.03;
            
        elseif strcmp(handles.specialization,'media') == 1
            weightsErrors(interIctalIndexes) = 0.1;
            weightsErrors(preIctalIndexes) = 0.2;
            weightsErrors(posIctalIndexes) = 0.3;
            
        elseif strcmp(handles.specialization,'baixa') == 1
            weightsErrors(interIctalIndexes) = 0.6;
            weightsErrors(preIctalIndexes) = 0.7;
            weightsErrors(posIctalIndexes) = 0.8;
        end
    end
    
     %TRAIN THE NETWORK
     net = train(Net, trainFeatVect, trainTrgMatrix, [], [], weightsErrors);
     
     %SAVE TRAINED NETWORK
     filename = strcat(handles.networkType, '_numberLayers=',  num2str(handles.numberLayers), '_neuronsPerLayer=', num2str(handles.neuronsPerLayer),'_activationFunction=', handles.activationFunction, '_preference=', handles.preference, '_specialization=', handles.specialization, '_balance=', num2str(handles.balance), '.mat');
     save(filename, 'net');
     disp('Finished the Training')
     
end

