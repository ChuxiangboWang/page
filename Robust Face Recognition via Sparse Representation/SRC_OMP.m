function identity = SRC_OMP(A, y, class_indices)
    A = double(A);
    y = double(y);
    k = max(class_indices); 

    A = A ./ vecnorm(A);

    
    maxIter = 50;
    numColumns = size(A, 2);

   
    residual = y;
    support = [];
    x = zeros(numColumns, 1);

    for iter = 1:maxIter
        
        [~, maxIdx] = max(abs(A' * residual));
        support = [support, maxIdx];

        
        partialSolution = A(:, support) \ y;
        x(support) = partialSolution;

        
        residual = y - A(:, support) * partialSolution;
    end

    
    figure; 
    stem(x); 
    xlabel('Index'); 
    ylabel('Value'); 
    title('Sparsity of x by OMP'); 

    
    residuals = zeros(k, 1);
    x_hats = zeros(length(x), k);
    for i = 1:k
        delta_i = (class_indices == i);
        x_hat_i = x .* delta_i;
        residuals(i) = norm(y - A * x_hat_i, 2);
        x_hats(:, i) = x_hat_i;
    end

     
    figure; 
    bar(residuals); 
    xlabel('Class'); 
    ylabel('Residual'); 
    title('Residuals for Each Class (L-0)'); 

   
    one_norms = zeros(1, k);
    for i = 1:k
        one_norms(i) = norm(x_hats(:, i), 1);
    end

    max_one_norm = max(one_norms);
    sci = (k * max_one_norm / norm(x, 1) - 1) / (k - 1)
    sci_threshold = 0;

    if sci > sci_threshold
        [~, identity] = min(residuals);
    else
        identity = 'Image Rejected';
    end
end
