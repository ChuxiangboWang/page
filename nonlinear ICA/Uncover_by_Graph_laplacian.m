
epsilon = 3;
t = 0.01;

N = 2000;
X = rand(N, 2);

Y = [X(:,1) + X(:,2).^3, X(:,2) - X(:,1).^3];

[eigvals, eigvecs, diff_map] = diffusion_map(Y, epsilon, t);



figure;
subplot(4,1,1);
scatter(X(:,1), X(:,2), 15, eigvecs(:,2), 'filled');
colormap;
colorbar;
xlabel('x1');
ylabel('x2');
title('Graph Laplacian');


subplot(4,1,2);
scatter(X(:,1), X(:,2), 15, eigvecs(:,3), 'filled');
colormap;
colorbar;
xlabel('x1');
ylabel('x2');
title('Graph Laplacian');

subplot(4,1,3);
scatter(eigvecs(:,2), eigvecs(:,3), 15, X(:,1), 'filled');
colormap;
colorbar;
xlabel('\phi_1');
ylabel('\phi_2');
title('Graph Laplacian');

subplot(4,1,4);
scatter(eigvecs(:,2), eigvecs(:,3), 15, X(:,2), 'filled');
colormap;
colorbar;
xlabel('\phi_1');
ylabel('\phi_2');
title('Graph Laplacian');

