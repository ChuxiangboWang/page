function [eigvals, eigvecs, diff_map] = diffusion_map(data, epsilon, t)



D = pdist2(data, data);

K = exp(-D.^2 / (2*epsilon^2));

P = bsxfun(@rdivide, K, sum(K, 2));

[eigvecs, eigvals] = eig(P);
eigvals = diag(eigvals);

[~, idx] = sort(eigvals, 'descend');
eigvals = eigvals(idx);
eigvecs = eigvecs(:, idx);

diff_map = bsxfun(@times, eigvecs, eigvals'.^t);
