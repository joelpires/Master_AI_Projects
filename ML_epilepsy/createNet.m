function [ Net ] = createNet(trainFeatVect, trainTrgMatrix,  handles)
    
    if (strcmp(handles.networkType, 'Feed Forward'))
		disp('Creating a Feed Forward Neural Network...')
		hiddenSizes = repmat( handles.neuronsPerLayer, 1, handles.numberLayers - 1);
		
		Net = feedforwardnet(hiddenSizes);

        for i=1:handles.numberLayers
            Net.layers{i}.transferFcn = handles.activationFunction;
        end

    elseif (strcmp(handles.networkType, 'Fitnet'))
        disp('Creating a Fitnet Neural Network...')
        Net = fitnet(handles.neuronsPerLayer,handles.batchTrainingMethod);

    elseif (strcmp(handles.networkType, 'Layer Recurrent'))
        disp('Creating a Layer Recurrent Neural Network ...')
		layersDelays = 1:2;
		layersSize = [repmat( handles.neuronsPerLayer, 1, handles.numberLayers - 1)];

		Net = layrecnet(layersDelays, layersSize);

	elseif (strcmp(handles.networkType, 'Focused Time-Delay'))
        disp('Creating a Focused Time-Delay Neural Network...')
		
		activationFunctions = [repmat( {handles.activationFunction}, 1, handles.numberLayers - 1)];
		layersSize = [repmat( handles.neuronsPerLayer, 1, handles.numberLayers - 1)];
		
		Net = newfftd(trainFeatVect, trainTrgMatrix,  0:handles.numberLayers - 1, layersSize, activationFunctions, handles.batchTrainingMethod);

		W = 0.1*rand(size(Net.IW{1,1}));
		b = 0.1*rand(size(Net.b{1,1}));

		Net.IW{1,1} = W;
		Net.b{1,1} = b;
        
    end
    
    Net.performParam.lr = handles.learningRate;
    Net.trainParam.epochs = handles.epochs;
    Net.trainParam.goal = handles.goal;
    Net.performFcn = handles.performanceFcn;
    Net.trainFcn = handles.batchTrainingMethod;
    Net.divideParam.trainRatio = handles.trainPercentage;
    Net.divideParam.valRatio = 1-(handles.trainPercentage+handles.testPercentage);
    Net.divideParam.testRatio = 0;
        

end

