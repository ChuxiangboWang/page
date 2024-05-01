function [PCO_m, PCO_f] = co_model(t)
    
    % Constants
     D_LCO = 23; 
    D_PCO = 1.5; 
    V_A = 6000; 
    VCO_m = 0.0153; 
    VCO_f = 0.0006;
    cap_m = 0.168; 
    cap_f = 0.208; 
    M_m = 223; 
    M_f = 181; 
    PO2_HbO2_L = 1.029; 
    PO2_HbO2_m = 0.5609; 
    PO2_HbO2_f = 0.4128; 

    % Initial conditions
    y0 = [0, 0];

    if t == 0
        % Directly return the initial conditions if t = 0
        PCO_m = y0(1);
        PCO_f = y0(2);
    else
        % Solving ODE from 0 to t
        tspan = [0 t]; 
        [times, y] = ode45(@(t, y) odes(t, y), tspan, y0, odeset('RelTol',1e-6,'AbsTol',1e-8));

        O2Hb = 87.5; % oxyhemoglobin concentration as a percentage
         PO2 = 90;    % partial pressure of oxygen in mmHg
          M = 218;     % equilibrium constant

        % Extract the concentrations at the last computed time
        PCO_m = (y(end, 1)* PO2 / (O2Hb * M));
        PCO_f = (y(end, 2)* PO2 / (O2Hb * M));


    end

    function dydt = odes(t, y)
        if t >= 960 || t < 0  
            P_LCO = 0; 
        else
            P_LCO = 0.038; 
        end
        
        a11 = -[D_LCO * PO2_HbO2_L / (1 + 713 * D_LCO / V_A) + D_PCO * PO2_HbO2_m]*100 / (5000*cap_m * M_m);
        a12 = D_PCO * PO2_HbO2_f *100/ (5000*cap_m * M_f);
        a21 = D_PCO * PO2_HbO2_m *100/ (400*cap_f * M_m);
        a22 = -D_PCO * PO2_HbO2_f *100/ (400*cap_f * M_f);
        f1 = (VCO_m + D_LCO * P_LCO / (1 + 713 * D_LCO / V_A)) * 100 / (5000*cap_m);
        f2 = VCO_f * 100 /(400* cap_f);

       
        dydt = [a11 * y(1) + a12 * y(2) + f1; a21 * y(1) + a22 * y(2) + f2];
    end
end
