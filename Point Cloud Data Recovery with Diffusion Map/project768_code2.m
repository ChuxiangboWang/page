clc;
clear all;

% Parameters
num_point_clouds = 500;   % Number of point clouds
points_per_cloud = 20;   % Number of points per cloud
mean_range = [0, 1];      % Range for the means of the Gaussians
cov_value = 0.0001;       % Smaller variance for tighter clusters
N = num_point_clouds * points_per_cloud;


covariance_matrix = [cov_value, 0; 0, cov_value];


x = zeros(num_point_clouds * points_per_cloud, 2);


for i = 1:num_point_clouds
 
    mean = mean_range(1) + (mean_range(2) - mean_range(1)) * rand(1, 2);
    

    points = mvnrnd(mean, covariance_matrix, points_per_cloud);
    
  
    start_index = (i-1) * points_per_cloud + 1;
    end_index = i * points_per_cloud;
    x(start_index:end_index, :) = points;
end


figure;


plot(x(:, 1), x(:, 2), '.b', 'MarkerSize', 5); 
xlim(mean_range);
ylim(mean_range);
xlabel('X');
ylabel('Y');
grid on;
title('Uniformly Distributed Point Clouds in R^2 with Distinct Clustering');
hold off;
axis equal;  

%%

num_bursts = 100;
delta_t = 0.001;

Y = simulate_ito_process(x, num_bursts, delta_t);

C = zeros(N, 2, 2);
for i = 1:N
    Y_i = squeeze(Y(i, :, :))';
    C(i, :, :) = cov(Y_i);
end

C_pinv = zeros(N, 2, 2);
for i = 1:N
    C_i = squeeze(C(i, :, :));
    C_pinv(i, :, :) = pinv(C_i);
end
%%
epsilon = 0.0001;
delta = 0.1; 
d = 2; 

W = zeros(N, N);
for i = 1:N
    for j = i:N
        C_psoinv_i = squeeze(C_pinv(i,:,:));
        C_psoinv_j = squeeze(C_pinv(j,:,:));
        
        C_psoinv_sum = C_psoinv_i + C_psoinv_j;
        
        y_diff = (Y(j,:,1) - Y(i,:,1))';
        
        wij = exp(-((delta^2)/(d+2)) * (y_diff' * C_psoinv_sum * y_diff) / (4*epsilon));
        
        W(i,j) = wij;
        W(j,i) = wij;
    end
end
I = eye(N);
D = diag(sum(W, 2));
P = D^(-1) * W - I;
[V, lambda] = eig(P);
lambda = diag(lambda);



figure;

subplot(4,1,1);
scatter(V(:,2),V(:,3),15,x(:,1),'filled');
colorbar;
title('Anisotropic Difussion');
xlabel('\phi_1');
ylabel('\phi_2');

subplot(4,1,2);
scatter(V(:,2),V(:,3),15,x(:,2),'filled');
colorbar;
title('Anisotropic Difussion');
xlabel('\phi_1');
ylabel('\phi_2');


subplot(4,1,3);
scatter(x(:,1),x(:,2),15,V(:,2),'filled');
colorbar;
title('Anisotropic Difussion');
xlabel('\phi_1');
ylabel('\phi_2');


subplot(4,1,4);
scatter(x(:,1),x(:,2),15,V(:,3),'filled');
colorbar;
title('Anisotropic Difussion');
xlabel('\phi_1');
ylabel('\phi_2');

