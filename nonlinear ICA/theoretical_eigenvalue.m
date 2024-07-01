
n_max = 50; 
epsilon = 0.005; 

mu = zeros(n_max+1);
for n = 0:n_max
    for m = 0:n_max
        mu(n+1,m+1) = pi^2 * (n^2 + m^2);
    end
end

lambda = exp(-epsilon/2 * mu);
lambda_sorted = sort(lambda(:), 'descend');

figure;
bar(-2*log(lambda_sorted(1:10))/(pi^2*epsilon));