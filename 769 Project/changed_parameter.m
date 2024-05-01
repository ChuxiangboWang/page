clc;
clear all;

%outputDir = '/Users/chuxiangbowang/Desktop/769plot5/';
%if ~exist(outputDir, 'dir')
%    mkdir(outputDir);
%end


R1 = 10 * 10^(-4);  
R2 = 16 * 10^(-4);  
R3 = 20 * 10^(-4);
Nr = 1000;           
dr = (R3 - 0) / Nr; 
r = linspace(0, R3, Nr + 1); 


D1_orig = 9 * 10^(-7); 
D2_orig = 3.79 * 10^(-7); 
D1_mod = 1 * D1_orig;  
D2_mod = 1 * D2_orig; 

dt = 0.1;          
Tfinal = 1440;        


A_orig = zeros(Nr + 1, Nr + 1);
A_mod = zeros(Nr + 1, Nr + 1);
for i = 1:Nr+1
    if r(i) < R1 || r(i) > R2
        D_orig = D1_orig;
        D_mod = D1_mod;
    else
        D_orig = D2_orig;
        D_mod = D2_mod;
    end
 
    A_orig(i, i) = -2 * D_orig / dr^2;
    if i > 1
        A_orig(i, i-1) = D_orig / dr^2 - D_orig / ( dr * r(i));
    end
    if i < Nr + 1
        A_orig(i, i+1) = D_orig / dr^2 + D_orig / (dr * r(i));
    end
    

    A_mod(i, i) = -2 * D_mod / dr^2;
    if i > 1
        A_mod(i, i-1) = D_mod / dr^2 - D_mod / ( dr * r(i));
    end
    if i < Nr + 1
        A_mod(i, i+1) = D_mod / dr^2 + D_mod / (dr * r(i));
    end
end
A_orig(end, :) = 0; 
A_orig(end, end) = 1; 
A_mod(end, :) = 0;
A_mod(end, end) = 1;

M_orig = eye(Nr+1) - dt * A_orig;
M_mod = eye(Nr+1) - dt * A_mod;


[PCO_m_orig, PCO_f_orig] = co_model2(0, 0.5609, 0.4128);
[PCO_m_mod, PCO_f_mod] = co_model2(0, 0.46, 0.3);

C_orig = zeros(Nr + 1, 1);
C_mod = zeros(Nr + 1, 1);
C_orig(1:floor(R1/dr) + 1) = PCO_m_orig; 
C_orig(end) = PCO_f_orig;
C_mod(1:floor(R1/dr) + 1) = PCO_m_mod; 
C_mod(end) = PCO_f_mod;
C_orig(1) = PCO_m_orig; 
C_mod(1) = PCO_m_mod; 


figure;
h1 = plot(r, C_orig, 'b', 'LineWidth', 2);  % Original plot in blue
hold on;
h2 = plot(r, C_mod, 'r', 'LineWidth', 2);   % Modified plot in red
legend('Original', 'Modified');
axis([R1 R3 0 0.05]);
xlabel('r');
ylabel('Concentration');
title('Initial Condition');
frameIndex = 1;
for t = 0:dt:Tfinal
   
    [PCO_m_orig, PCO_f_orig] = co_model2(t, 0.5609, 0.4128);
    [PCO_m_mod, PCO_f_mod] = co_model2(t, 0.46, 0.3);;

    
    C_orig(1:floor(R1/dr) + 1) = PCO_m_orig; 
    C_orig(floor(R2/dr): end) = PCO_f_orig;
    C_mod(1:floor(R1/dr) + 1) = PCO_m_mod;
    C_mod(floor(R2/dr): end) = PCO_f_mod;
    C_orig(1) = PCO_m_orig; 
    C_mod(1) = PCO_m_mod; 


    C_n_orig = M_orig \ C_orig;
    C_n_mod = M_mod \ C_mod;

    C_orig = C_n_orig;
    C_mod = C_n_mod;

    if mod(t, 200*dt) == 0
        set(h1, 'YData', C_orig);
        set(h2, 'YData', C_mod);
        drawnow;

         %Save the frame
        frameFilename = sprintf('plot_%02d.png', frameIndex);
        saveas(gcf, [outputDir frameFilename]);
        frameIndex = frameIndex + 1;
    end
    pause(0.0001); 
end
