clc;
clear all;

R1 = 10 * 10^(-4);  
R2 = 16 * 10^(-4);  
R3 = 20 * 10^(-4);
Nr = 1000;           
dr = (R3 - 0) / Nr; 
r = linspace(0, R3, Nr + 1); 
D1 = 9 * 10^(-7); 
D2 = 3.79 * 10^(-7); 
dt = 0.1;          
Tfinal = 1440;        


A = zeros(Nr + 1, Nr + 1); 


for i = 1:Nr+1
   
   if r(i) < R1 || r(i) > R2
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
%C = zeros(Nr + 1, 1);
%C(1:floor(R1/dr) + 1) = 0.3 * 90; 
%C(floor(R1/dr)+2:end-1) = 0;
[PCO_m, PCO_f] = co_model(0);
C = zeros(Nr + 1, 1);
C(1:floor(R1/dr) + 1) = PCO_m; 
%C(floor(R2/dr), end) = PCO_f; 
C(end) = PCO_f;
C(1) = PCO_m;

% Plot for the initial conditions
figure;
plot(r, C, 'LineWidth', 2);
axis([0 R3 0 0.05]);
xlabel('r');
ylabel('Concentration');
title('Initial Condition');

figure;
h = plot(r, C, 'LineWidth', 2);
axis([0 R3 0 0.05]);
xlabel('r');
ylabel('Concentration');



for t = 0:dt:Tfinal
    %C_n = M \ C; 
    
   
    [PCO_m, PCO_f] = co_model(t);
    C(1:floor(R1/dr) + 1) = PCO_m; 
    C(floor(R2/dr): end) = PCO_f; 
    %C(end) = PCO_f;
    %C(1) = PCO_m;

   
    C_n = M \ C;
    %C_n(1) = C_mother;
    %C_n(1:floor(R1/dr) + 1) = C_mother; % Ensure uniform concentration
    %C_n(end) = C_baby;
    
  
    R1_index = floor(R1/dr) + 1;
    flux_left = D1 * (C_n(R1_index) - C_n(R1_index - 1)) / dr; 
    flux_right = D2 * (C_n(R1_index + 1) - C_n(R1_index)) / dr; 

    if abs(flux_left - flux_right) > 1e-6 
        C_n(R1_index + 1) = C_n(R1_index) + (flux_left / D2) * dr;

    end
    
    
    R2_index = floor(R2/dr) + 1;
    flux_left_R2 = D2 * (C_n(R2_index) - C_n(R2_index - 1)) / dr; 
    flux_right_R2 = D1 * (C_n(R2_index+1) - C_n(R2_index)) / dr; 

    if abs(flux_left_R2 - flux_right_R2) > 1e-6 
        C_n(R2_index) = C_n(R2_index+1) + (flux_left / D1) * dr;

    end


    C = C_n; 

 if mod(t, 20*dt) == 0
        set(h, 'YData', C);
        drawnow;
    end
    pause(0.0001); 
end

