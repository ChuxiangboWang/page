N = 2000; 
x = rand(N,2);
y(:,1) = x(:,1) + x(:,2).^3;
y(:,2) = x(:,2) - x(:,1).^3;

% Plot:
subplot(1,2,1)
scatter(x(:,1), x(:,2), 10, 'k', 'filled');
axis equal;

subplot(1,2,2)
scatter(y(:,1), y(:,2), 10, 'k', 'filled');
axis equal;
