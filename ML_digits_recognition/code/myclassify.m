function resultado = myclassify(data, n)

    opcao = input('[Tipo de classificador]\n [1]- Associative Memory + Hardlim\n [2]- Associative Memory + Purelin\n [3]- Associative Memory + Logsig\n [4]- Hardlim\n [5]- Purelin\n [6]- Logsig\n'); 

    if opcao == 1
        load('hardlimAM.mat');

    elseif opcao == 2
        load('linearAM.mat');

    elseif opcao == 3
        load('logsigAM.mat');

    elseif opcao == 4 
        load('hardlim.mat');

    elseif opcao == 5
        load('linear.mat');

    elseif opcao == 6
        load('logsig.mat');

    end

    [linhas,colunas] = max(net(data));
    
    temp = colunas(n);
    
    resultado = int64(temp);
    

end