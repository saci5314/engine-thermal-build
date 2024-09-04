function epsilon_g = emissivity(N_H2O, N_CO2, P, T, V, A, method)
%{
This function finds the total emissivity of the CO2 and H2O combustion
product components everywhere along the nozzle, assuming chemical
equilibrium (ignoring transient species). These are the dominant dipoles 
(thus the dominant radiators) for most hydrocarbon propellant combinations.

Inputs:
    N_H2O = combustion product mole fraction of water
    N_CO2 = combustion product mole fraction of carbon dioxide
    P = [Pa] static pressure along nozzle
    T = [Pa] static temperature along nozzle
    T0
    V = [m] thrust chamber volume
    A = [m^2] thrust chamber area
    Nx = length of r vector

Outputs:
    epsilon_g = reaction product emissivity

Sources:
    [1] Grisson, M. "Liquid Film Cooling in Rocket Engines", AEDC-TR-91-1, 
        US Air Force Technical Library, 1991.

    [2] 
    
Note: All the math is on pages 11-13 of Grisson. Heads up, it is gross.
%}

switch method
    case 'Grisson'
        
    case 'Grisson full'
        
        %%% SETUP CALCS
        P = P/101325; % [atm] convert static temp from pascals to standard atmospheres
        L_eff = .95 * 4 * V / A; % [m] optical path length approximation
        
        
        
        %%% H2O EMISSIVITY
            % coefficients
            c_H2O = interp1([1000 2000 3000], [.165 .9 2.05], T, 'spline', 'extrap');
            n_H2O = interp1([1000 2000 3000], [.45 .65 .61], T, 'spline', 'extrap');
            
            % optical density
            p_H2O = P .* N_H2O; % [Pa] H2O partial pressure
            rho_opt_H2O = p_H2O * L_eff; % [] H2O optical density
            
            % pressure correction factors
            Kp_H2O = zeros(1,Nx);
            for nx = 1:Nx
                c1 = .26 + .74*exp(-2.5*rho_opt_H2O(nx));
                c2 = .75 + .31*exp(-10*rho_opt_H2O(nx));
                Kp_H2O(nx) = 1 + c1*(1-exp((1-P(nx)*(1+N_H2O(nx))/c2)));
            end    
        
            % calculate emissivity
            epsilon_f_H2O = .825; % limiting emissivity for H2O
            epsilon_H2O = epsilon_f_H2O * Kp_H2O .* (1 + (rho_opt_H2O./c_H2O).^-n_H2O);
        
        
        
        %%% CO2 EMISSIVITY
        
            %%% COEFFICIENTS
            c_CO2 = interp1([1000 2000 3000], [.05 .075 .15], T, 'spline', 'extrap');
            n_CO2 = .6;
            
            % OPTICAL DENSITY
            p_CO2 = P .* N_CO2; % [Pa] H2O partial pressure
            rho_opt_CO2 = p_CO2 * L_eff; % [] H2O optical density
            
            % pressure correction factors
            Kp_CO2 = zeros(1,Nx);
            m = 100*rho_opt_CO2;
            for nx = 1:Nx
                power = .036 * rho_opt_CO2(nx)^.433 * (1 + (2*log10(P(nx)))^(-m(nx)))^(1/m(nx));
                Kp_H2O(nx) = 10^power;
            end
        
            % calculate emissivity
            epsilon_f_CO2 = .238; % limiting emissivity for H2O
            epsilon_CO2 = epsilon_f_CO2 * Kp_CO2 .* (1 + (rho_opt_CO2./c_CO2).^-n_CO2);
        
        
        
        %%% SPECTRAL OVERLAP CORRECTION 
            rho_opt = (p_H2O + p_CO2) * L_eff ; % [atm*m] 
            % doesn't specify if this should be average or total :( going with total for now
            
            delta_epsilon = zeros(1,Nx);
            for nx = 1:Nx
                % correcton factor for the correction factor (what the fuck)
                n = 5.5 * (1 + (1.09*rho_opt)^-3.33)^-(1/3.33);
                Kx = 1 - abs(2*n_H2O/(n_H2O+n_CO2) - 1)^n;
                
                % correction factor
                delta_epsilon(nx) = 0.0551 * Kx * (1 - exp(-4*rho_opt)) * (1 - exp(-4*rho_opt));   
            end
        
        
        
        %%% CALCULATE NET GAS EMISSIVITY
            epsilon_g = epsilon_H2O + epsilon_CO2 - delta_epsilon;
    case 'RPA'
        %%% CHEMICAL PROPERTY TABLES

        %%% 
end