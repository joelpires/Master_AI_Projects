function [ predictedTarget ] = mahalanobis( X, y, tests)
k = unique(y);

[~, testSamples] = size(tests);
categores = length(k);

g = zeros(categores, testSamples);

C = cov(X');
inv_C = inv(C);

for i = 1:categores
    idx = ( y == k(i) );

    m_k = mean( X(:, idx ), 2 );

    for j = 1:testSamples
        d = abs(m_k - tests(:, j));
        g(i, j) = d' * inv_C * d;
    end
end

[~, I] = min(g, [], 1);
predictedTarget = k(I);

end
%EOF