function identity = SRC_ADMM2(A, y, class_indices)
% This is the ADMM for solving occulded image
    % Convert inputs to double precision
    A = double(A);
    y = double(y);
    k = max(class_indices); 

    % Normalize columns of A to have unit L2 norm
    A = A ./ vecnorm(A);

    % ADMM parameters
    rho = 0.1;
    lambda = 0.5;
    epsilon = 1e-5; 
    maxIter = 10000;

    % Initialize variables
    x = zeros(size(A, 2), 1);
    e = zeros(length(y), 1); % Error term for occlusion
    z = zeros(size(x));
    u = zeros(size(x));

    for iter = 1:maxIter
        % x-update
        x = (A' * A + rho * eye(size(A, 2))) \ (A' * (y - e) + rho * (z - u));

        % e-update for occlusion
        e = shrinkage(y - A * x, lambda / rho);

        % z-update
        z = max(0, x + u - lambda/rho) - max(0, -x - u - lambda/rho);

        % u-update
        u = u + rho * (x - z);

        % Convergence check
        if norm(A * x + e - y, 2) < epsilon
            break;
        end
    end

   % Compute residuals for each class
residuals = zeros(k, 1);
for i = 1:k
    delta_i = (class_indices == i);
    x_hat_i = x .* delta_i;
    residuals(i) = norm(y - e - A * x_hat_i, 2);
end

    % Determine identity based on minimum residual
    [~, identity] = min(residuals);

    % Plotting
    figure;
    subplot(3,1,1);
    bar(residuals);
    title('Residuals');

    subplot(3,1,2);
    stem(x);
    title('Sparse Representation (x)');

    subplot(3,1,3);
    stem(e);
    title('Error Term (e)');
end

% Shrinkage operator function
function s = shrinkage(a, kappa)
    s = max(0, a - kappa) - max(0, -a - kappa);
end
