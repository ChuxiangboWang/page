clc;
clear all;

N = 2000;
x = rand(N, 2);
num_bursts = 1000;
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

epsilon = 0.005;
delta = 0.1; 
d = 2; 

W = zeros(N, N);
for i = 1:N
    for j = i+1:N
        C_psoinv_i = squeeze(C_pinv(i,:,:));
        C_psoinv_j = squeeze(C_pinv(j,:,:));
        
        C_psoinv_sum = C_psoinv_i + C_psoinv_j;
        
        y_diff = (Y(j,:,1) - Y(i,:,1))';
        
        wij = exp(-((delta^2)/(d+2)) * (y_diff' * C_psoinv_sum * y_diff) / (4*epsilon));
        
        W(i,j) = wij;
        W(j,i) = wij;
    end
end

D = diag(sum(W, 2));
P = D^(-1) * W;
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
