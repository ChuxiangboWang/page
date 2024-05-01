clc;
clear all;

R1 = 10 * 10^(-4);  
R2 = 16 * 10^(-4);  
Nr = 1000;           
dr = (R2 - 0) / Nr; 
r = linspace(0, R2, Nr + 1); 
D1 = 9.84 * 10^(-7); 
D2 = 4.92 * 10^(-7); 
dt = 0.01;          
Tfinal = 10;        


A = zeros(Nr + 1, Nr + 1); 


for i = 1:Nr+1
    if r(i) < R1
        difcoeff = D1;
    else
        difcoeff = D2;
    end
    A(i, i) = -2 * difcoeff / dr^2;
    if i > 1
        A(i, i-1) = difcoeff / dr^2 - difcoeff / ( dr * r(i));
    end
    if i < Nr + 1
        A(i, i+1) = difcoeff / dr^2 + difcoeff / (dr * r(i));
    end
end

A(end, :) = 0; 
A(end, end) = 1; 


M = eye(Nr+1) - dt * A;

% Initial conditions
C = zeros(Nr + 1, 1);
C(1:floor(R1/dr) + 1) = 0.3 * 90; 
C(floor(R1/dr)+2:end-1) = 0

figure;
h = plot(r, C, 'LineWidth', 2);
axis([0 R2 0 max(C) + 10]);
xlabel('r');
ylabel('Concentration');



for t = 0:dt:Tfinal
    C_n = M \ C; 
    
   
    C_n(end) = 0.5 * 10;
    
  
    R1_index = floor(R1/dr) + 1;
    flux_left = D1 * (C_n(R1_index) - C_n(R1_index - 1)) / dr; 
    flux_right = D2 * (C_n(R1_index + 1) - C_n(R1_index)) / dr; 

    if abs(flux_left - flux_right) > 1e-6 
        C_n(R1_index + 1) = C_n(R1_index) + (flux_left / D2) * dr;
    end
    
    C = C_n; 
    
   
    set(h, 'YData', C);
    drawnow; 
    pause(0.1); 
end

