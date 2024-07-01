function Y = simulate_ito_process(x, num_bursts, delta_t)
    N = size(x, 1);
    Y = zeros(N, 2, num_bursts);
    
    drift = [1, 1]; 
    diffusion = [1, 1]; 
    for i = 1:N
        for j = 1:num_bursts
            xi = x(i, :);
            t = 0;
            dt = delta_t; 
            dW = sqrt(dt) * randn(1, 2); 
            xi = xi + drift * dt + diffusion .* dW;
            
          
            yi = [xi(1) + xi(2)^3, xi(2) - xi(1)^3];
            
            Y(i, :, j) = yi;
        end
    end
end
