function [ predictedTarget ] = euclidean( features, target, tests)
k = unique(target);
[~, testSamples] = size(tests);
categories = length(k);

g = zeros(categories, testSamples);

for i = 1:categories
    
    idx = ( target == k(i) );
    
    m_k = mean( features(:, idx ), 2 );
    for j = 1:testSamples
        d = abs(m_k - tests(:, j));
        g(i, j) = d' * d;
    end
end

[~, I] = min(g, [], 1);
predictedTarget = k(I);

end
