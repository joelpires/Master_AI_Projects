function main(opcao1,ativacao)

run('test1.m')

load('targets.mat');
load('numeros.mat');
load('test.mat','P')
load('testes.mat')

if opcao1==1
    load('perfeitos.mat');
    pesos = perfeitos * pinv(matrizFinal1);
    purificados = pesos*matrizFinal1;
    P = pesos * P;
    
    if ativacao == 1
        net = perceptron;
        net = configure(net,purificados, targets);

        net.IW{1,1} = rand(10,256);
        net.b{1,1} = rand(10,1);
        net.performParam.lr = 0.5;
        net.trainParam.epochs = 1000; 
        net.trainParam.show = 35;
        net.trainParam.goal = 1e-6;
        net.divideParam.trainRatio = 85/100;
        net.divideParam.valRatio = 15/100;
        net.performFcn = 'sse';
        
        [net,tr] = train(net,purificados,targets);
                
        hardlimAM = net;
        save hardlimAM
    % linear     
    elseif ativacao==2
        net = perceptron;
        net = configure(net,purificados, targets);
        
        W=rand(10,256);
        b=rand(10,1);
        net.IW{1,1}=W;
        net.b{1,1}=b;
        
        
        net.layers{1}.transferFcn = 'purelin';
        net.inputWeights{1}.learnFcn = 'learngd';       
        net.biases{1}.learnFcn = 'learngd'; 
        net.trainFcn = 'traingd';
        net.performFcn = 'mse';
        net.trainParam.epochs = 10000;
        net.divideParam.trainRatio = 85/100;
        net.divideParam.valRatio = 15/100;
       
        
        [net,tr] = train(net,purificados,targets);
        
        %result = net(purificados);
        %errors = gsubtract(result,targets);
        %performance = perform(net,targets,result);
        %validation=sim(net,P)
        
        linearAM = net;
        save linearAM
        
    elseif ativacao==3
        net = perceptron;
        net = configure(net,purificados,targets);
        
        net.IW{1,1} = rand(10,256);
        net.b{1,1} = rand(10,1);
        net.layers{1}.transferFcn = 'logsig';
        net.inputWeights{1}.learnFcn = 'learngd';       
        net.biases{1}.learnFcn = 'learngd'; 
        net.trainFcn = 'traingd';
        
        
        net.trainParam.epochs = 10000;
        net.performFcn = 'mse';
        
        net.divideParam.trainRatio = 85/100;
        net.divideParam.valRatio = 15/100;
          
        [net,tr]=train(net,purificados,targets);
        
        
        %result = net(purificados);
        %errors = gsubtract(result,targets);
        %performance = perform(net,targets,result);
        %validation=sim(net,P)
        
        
        logsigAM = net;
        save logsigAM
    end
else
     if ativacao==1
        net = perceptron;
        net = configure(net, matrizFinal1, targets);
        
        net.IW{1,1} = rand(10,256);
        net.b{1,1} = rand(10,1);
        
        net.performParam.lr = 0.5;
        net.trainParam.epochs = 1000;
        net.trainParam.show =35;
        
        
        net.performFcn ='sse';
        net.divideParam.trainRatio = 85/100;
        net.divideParam.valRatio = 15/100;
        
        
        [net,tr]=train(net,matrizFinal1,targets);
        
       
        hardlim = net;
        save hardlim
    
    elseif ativacao==2
        
        net = perceptron;
        net = configure(net,matrizFinal1,targets);
        
        net.IW{1,1} = rand(10,256);
        net.b{1,1} = rand(10,1);
        
        net.layers{1}.transferFcn = 'purelin';
        net.inputWeights{1}.learnFcn = 'learngd';       
        net.biases{1}.learnFcn = 'learngd'; 
        net.trainFcn = 'traingd';
        
        
        net.trainParam.epochs = 10000;
        net.performFcn = 'mse';
        net.divideParam.trainRatio = 85/100;
        net.divideParam.valRatio = 15/100;
        
        net = train(net,matrizFinal1,targets);
        
        linear = net;
        save linear
        
    elseif ativacao==3
        net = perceptron;
        net = configure(net,matrizFinal1,targets);
        
        net.IW{1,1} = rand(10,256);
        net.b{1,1} = rand(10,1);
        
        net.layers{1}.transferFcn = 'logsig';
        net.inputWeights{1}.learnFcn = 'learngd';       
        net.biases{1}.learnFcn = 'learngd'; 
        net.trainFcn = 'traingd';
        
        
        net.trainParam.epochs = 10000;
        net.performFcn = 'mse';
        
        net.divideParam.trainRatio = 85/100;
        net.divideParam.valRatio = 15/100;
          
        [net,tr]=train(net,matrizFinal1,targets);
        
        %View the Network
        %result = net(matrizFinal1);
        %errors = gsubtract(result,targets);
        %performance = perform(net,targets,result);
        %validation=sim(net,P)
        
        
        logsig = net;
        save logsig
     end
    
     save net;
        
end
