function identity = SRC_ADMM(A, y, class_indices)
    
    A = double(A);
    y = double(y);
    k = max(class_indices); 

   
    A = A ./ vecnorm(A);

    % ADMM
    rho = 0.1;
    lambda = 0.5;
    epsilon = 1e-5; 
    maxIter = 10000;

    x = zeros(size(A, 2), 1);
    z = zeros(size(x));
    u = zeros(size(x));

    
    for iter = 1:maxIter
       
        x = (A' * A + rho * eye(size(A, 2))) \ (A' * y + rho * (z - u));

        
        z = max(0, x + u - lambda/rho) - max(0, -x - u - lambda/rho);

      
        u = u + rho * (x - z);

        
        if norm(A * x - y, 2) < epsilon
            break;
        end
    end
    
    % Plotting the sparsity of x
    figure; 
    stem(x); 
    xlabel('Index'); 
    ylabel('Value'); 
    title('Sparsity of x'); 
    
    x = x(:);
    residuals = zeros(k, 1);
    x_hats = zeros(length(x), k);
    for i = 1:k
        
        delta_i = (class_indices == i);
        
        x_hat_i = x .* delta_i;
       
        residuals(i) = norm(y - A * x_hat_i, 2);
         x_hat_i = x_hat_i(:);
        x_hats(:, i) = x_hat_i;
    end

    one_norms = zeros(1, k);

    for i = 1:k
    one_norms(i) = norm(x_hats(:, i), 1);
    end
    
     % Plotting the residuals
    figure; 
    bar(residuals); 
    xlabel('Class'); 
    ylabel('Residual'); 
    title('Residuals for Each Class (L-1)'); 
   
    max_one_norm = max(one_norms);

    sci = (k * max_one_norm / norm(x, 1) - 1) / (k - 1)


    sci_threshold = 0;

    if sci > sci_threshold
    
    [~, identity] = min(residuals);
else
    
    identity = 'Image Rejected';
end
