clc;
clear all;


N = 2000;
x = rand (N, 2);
y(:,1) = x(:,1) + x(:,2).^3;
y(:,2) = x(:,2) - x(:,1).^3;
J = zeros (N,2,2);

for i = 1:N
    J(i,:,:) = [1, 3*x(i,2)^2; -3*x(i,1)^2, 1];
end

epsilon = 0.005;
D = pdist2(y, y);
W = zeros (N,N) ;

for i = 1:N
    for j = i+1:N
        J_inv_i = inv(squeeze(J(i,:,:)));
        J_inv_j = inv(squeeze(J(j,:,:)));
        dij = J_inv_i * (y(j,:)-y(i,:))';
        djj = J_inv_j * (y(j,:)-y(i,:))';
        wij = exp(-(norm(dij)^2 + norm(djj)^2) / (4*epsilon));
        W(i,j) = wij;
        W(j,i) = wij;
    end
end


D = diag(sum(W, 2));
P = D^(-1) * W;
[V, lambda] = eig(P);
lambda = diag (lambda);

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