function [data1] = normalizing(filename, dataset, type)
    path = strcat('../structures/datasets/', type);
    path = strcat(path, dataset);
    path = strcat(path, 'normalized.mat');
    
    disp(filename)
    data1 = load(filename);
    
    data1.features = zscore(data1.features);
    features = data1.features;
    
    if(type == "train")
        target = data1.target;
        save(path, 'target', 'features', '-v7.3');
    else
        save(path, 'features', '-v7.3');
    end
    
    
    
end