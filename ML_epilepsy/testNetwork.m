function [ specificityPreIctal, sensitivityPreIctal, sensitivityIctal, specificityIctal, preIctaltp, Ictaltp, preIctalfp, Ictalfp, preIctaltn, Ictaltn, preIctalfn, Ictalfn ] = testNetwork(handles, testFeatVect, testTrgMatrix)
    disp('Testing the Network...')
    filename = strcat(handles.networkType, '_numberLayers=',  num2str(handles.numberLayers), '_neuronsPerLayer=', num2str(handles.neuronsPerLayer),'_activationFunction=', handles.activationFunction, '_preference=', handles.preference, '_specialization=', handles.specialization, '_balance=', num2str(handles.balance), '.mat');
    results = [];
    if (exist(filename, 'file') ~= 2)
        disp('You have to train the network first with those specifications');
    else
        net = load(filename, 'net');
        net = net.net;
        
        results = sim(net,testFeatVect);
        
        %CONVERT THE RESULTS
        for i=1:length(results)
            max = 1;
            for j=2:4
                if(results(j,i)>=results(max,i))
                   max = j; 
                end
            end
            results(:,i) = zeros(4,1);
            results(max,i)=1;
        end
        
        %POST-PROCESSING
        if(strcmp(handles.postProcessing, '10 relaxed'))
            for i=1:length(results)-10
                aux = 0;
                 for j=1:10
                     if(isequal(results(:,i),results(:,i+j)))
                         aux = aux+1;
                     end
                 end

                 if(aux < 5)
                     results(:,i)=[1;0;0;0];
                 end
             end
        elseif(strcmp(handles.postProcessing, 'nothing'))

        else
            next = str2num(handles.postProcessing(1:2));
            for i=1:length(results)-next
                aux = 1;
                 for j=1:next
                     if(isequal(results(:,i),results(:,i+j)))

                     else
                         aux = 0;
                     end
                 end

                 if(aux == 0)
                     results(:,i)=[1;0;0;0];
                 end
             end                                    
        end
        
        disp('Analysing the Specificity and Sensitivity of the Results')
        %ANALYSIS
        preIctaltp = 0; preIctaltn = 0; preIctalfn = 0; preIctalfp = 0;

        Ictaltp = 0; Ictaltn = 0; Ictalfn = 0; Ictalfp = 0;            

        for i=1:length(results)
           %PREDICTION
            if(results(2,i)==testTrgMatrix(2,i))
               if(results(2,i)==1)
                   preIctaltp = preIctaltp+1;
               else
                   preIctaltn = preIctaltn+1;
               end
            else
               if(results(2,i)==1)
                   preIctalfp = preIctalfp+1;
               else
                   preIctalfn = preIctalfn+1;
               end
            end

            if(results(3,i)==testTrgMatrix(3,i))
               if(results(3,i)==1)
                   Ictaltp = Ictaltp+1;
               else
                   Ictaltn = Ictaltn+1;
               end
            else
               if(results(3,i)==1)
                   Ictalfp = Ictalfp+1;
               else
                   Ictalfn = Ictalfn+1;
               end
            end
        end
        
        sensitivityPreIctal = preIctaltp/(preIctaltp+preIctalfn);
        sensitivityIctal  = Ictaltp /(Ictaltp +Ictalfn);

        specificityPreIctal = preIctaltn/(preIctaltn+preIctalfp);
        specificityIctal  = Ictaltn /(Ictaltn +Ictalfp);

    end
    disp('Finished the Testing')
    
end

