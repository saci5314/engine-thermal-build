function h_wc = h_wc_coefficient(T_c, T_wc, L_eff, A, working_fluid)
%{
This function finds the cold-wall convective heat transfer coefficient. If 
regen cooling is present, channel flow relations are used. Otherwise, it is 
treated as natural convecton. Could use flat plate relations for forced
convection for a flight configuration.

Note: Should probably add correction factors for fin efficiency.

Inputs:
    T_c = [K] coolant bulk temp vector (if regen present
          [K] ambient air temp sufficiently far from surface (if no regen
          present)
    T_wc = [K] cold wall surface temp
    L_eff = [m] channel hydraulic diameter (if regen present)
            [m] chamber height (if no regen present)
    mdot_c = [kg/s] channel mass flow rate

    
Outputs:
    h_c = [W/m*K] convective heat transfer coefficient

Sources:
    [1] Thermal Fluid Sciences

    [2] RPA 
%}
    
if working_fluid == 'ambient'
    %%% 
    [k_c, ~, mu_c, ~] = coolant_props(working_fluid, T_c);

    % Grashof number
    Gr = 9.81 * Leff^3 / mu_c^2 * (T_wc/T_c - 1); 
    Pr = cp_c * mu_c / k_c;
    
    
    
else
    %%% COOLANT FLOW PROPERTIES
    % pull conductivity at current temps
    [k_c, cp_c, mu_c, ~] = coolant_props(working_fluid, T_c);

    % dimensionless flow parameters
    Re_c = (mdot_c/N_c) * L_eff ./ (mu_c .* A); % coolant Reynold's number
    Pr_c = cp_c .* mu_c ./ k_c; % coolant Prantyl number
    
    %%% FIND NUSSELT NUMBER
    if fuel_type == "Jet-A" || fuel_type  == "RP-1"
        Nu = .021 * Re.^.8 .* Pr.^.4 .* (.64 + .36 * (T_c ./ T_wc)); % ([2] pg 15)
    elseif fuel_type == "CH4"
        Nu = .0185 * Re.^.8 .* Pr.^.4 .* (T_c ./ T_wc).^.1; % ([2] pg 15)
    elseif
        Nu = .033 * Re.^.8 .* Pr.^.4 .* (T_c ./ T_wc).^.57; % ([2] pg 15)
    else
        Nu = .023 * Re.^.8 .* Pr.^.4; % ([1] pg ..., [2] pg 15)
    end

    %%% CALC HEAT TRANSFER COEFFICIENT
    h_wc = Nu .* k_c .* L_eff; % [W/(m^2*K)] cold wall heat transfer coefficient
end
   



end