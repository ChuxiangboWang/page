clc;
clear all

n = 3000;
r = 0.5; % radius of the moons
w = 0.05; % width of the moons
d = 0.05; % distance between the two moons

numClusters = 5;

theta1 = pi - linspace(0, pi, numClusters);
x1 = r * cos(theta1);
y1 = r * sin(theta1);

theta2 = linspace(0, pi, numClusters);
x2 = r * cos(theta2) + r;
y2 = -r * sin(theta2) - d;

pointsX = [];
pointsY = [];

for i = 1:numClusters
    pointsX = [pointsX; x1(i) + randn(n/numClusters/2, 1) * w];
    pointsY = [pointsY; y1(i) + randn(n/numClusters/2, 1) * w];
end

for i = 1:numClusters
    pointsX = [pointsX; x2(i) + randn(n/numClusters/2, 1) * w];
    pointsY = [pointsY; y2(i) + randn(n/numClusters/2, 1) * w];
end

figure;
scatter(pointsX, pointsY, 12, 'filled');
title('Half Moon Shaped Point Cloud with Gaussian Clusters');
xlabel('X-axis');
ylabel('Y-axis');
axis equal;
grid on;

figureCounter = 1;  % Initialize a counter for saving figures
saveas(gcf, ['/Users/chuxiangbowang/Desktop/ScatterPlot_', num2str(figureCounter), '.png']);
figureCounter = figureCounter + 1;


for ep = 0.01:0.02:0.19
    
    K = @(x) exp(-x/(2*ep));

    d = (pointsX - pointsX').^2 + (pointsY - pointsY').^2;
    A = K(d);
    A = A - diag(diag(A)); 

    G = graph(A);

    figure;
    plot(G,'XData',pointsX,'YData',pointsY,'EdgeCData', G.Edges.Weight,'EdgeAlpha',0.5)
    colorbar
    colormap(flip(gray))
    title(['Graph for ep = ', num2str(ep)]);
    saveas(gcf, ['/Users/chuxiangbowang/Desktop/GraphPlot_ep_', num2str(ep), '_', num2str(figureCounter), '.png']);
    figureCounter = figureCounter + 1;

    % generate the diffusion map
    t = 100; % number of time steps

    % probability transition matrix
    D = sum(A,2)*ones(1,length(A));   % row sum repeated over each column
    P = A./D;

  
    [V,L,W] = eig(P);   
    L = ones(length(V),1)*diag(L.^t)'; 

    [eigenVectorsP, eigenValuesP] = eig(P);

   
    xNew = L.*V;
    xNewA = xNew(:,2);
    xNewB = xNew(:,3);

    figure;
    hold on
    plot(xNewA(1:length(pointsX)/2),xNewB(1:length(pointsX)/2),'.')
    plot(xNewA(length(pointsX)/2+1:end),xNewB(length(pointsX)/2+1:end),'.')
    title(['Diffusion Map of Half Moon Shaped Point Cloud for ep = ', num2str(ep)]);
    xlabel('New X-axis');
    ylabel('New Y-axis');
    grid on;
    saveas(gcf, ['/Users/chuxiangbowang/Desktop/DiffusionMap_ep_', num2str(ep), '_', num2str(figureCounter), '.png']);
    figureCounter = figureCounter + 1;

    % Plot first 10 eigenvalues
    figure;
    plot(1:10, diag(eigenValuesP(1:10, 1:10)), 'o-');
    title(['First 10 Eigenvalues for ep = ', num2str(ep)]);
    xlabel('Eigenvalue Index');
    ylabel('Eigenvalue');
    grid on;
    saveas(gcf, ['/Users/chuxiangbowang/Desktop/EigenvaluesPlot_ep_', num2str(ep), '_', num2str(figureCounter), '.png']);
    figureCounter = figureCounter + 1;
end
