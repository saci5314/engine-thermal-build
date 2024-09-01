function nozzle_design_calcs(engine, P_atm)
%{
This function finds ideal and actual conditions. It assigns nozzle throat
and exit condititions to their ideal, if not prespecified as design inputs.

Author:
    Samuel Ciesielski

Sources:
    [1] G.P. Sutton, O. Biblarz, "Rocket Propulsion Elements", John Wiley 
        & Sons, 2001.

%}



%% EXTRACT EQUILIBRIUM GAS PROPS
%%% CHAMBER STAGNATION TEMP
    engine.T_c = engine.cea_data.t(1); % [K]

%%% SPECIFIC HEAT RATIO @ THROAT PLANE
    gamma = engine.cea_data.gam(2);

%%% GAS CONSTANT @ THROAT PLANE
    R = engine.P_c/(engine.cea_data.t(2)*engine.cea_data.rho(2)); % [J/(kg*K)]



%% IDEAL NOZZLE CONDITIONS
    
    P_e_ideal = P_atm; % [Pa] ideal exit pressure is atmospheric for static test

    M_e_ideal = sqrt((2/(gamma-1)) * ...
                ((engine.P_c/P_e_ideal)^((gamma-1)/gamma) - 1)); % ideal exit mach

    AeAt_ideal = 1/M_e_ideal * ... 
                 (2/(gamma+1) * (1 + (gamma-1)/2 * M_e_ideal^2))^((gamma+1)/(2*gamma-2)); % ideal area ratio



%% ISENTROPIC SIZING

%%% IF BOTH THROAT AND EXIT DIAMETER ARE ASSIGNED (TODO)
    if ~isempty(engine.d_t) && ~isempty(engine.d_e)
        %%% critical areas
        engine.A_t = pi * engine.d_t^2 / 4; % [m^2]
        engine.A_e = pi * engine.d_e^2 / 4; % [m^2]
        
        %%% actual exit conditions
        M_e_actual = mach(engine.A_t, engine.A_e, gamma, "supersonic");
        engine.P_e = engine.P_c * (1 + (gamma-1)/2 * M_e_actual^2)^((gamma-1)/gamma); % [Pa]

        %%% actual exit velocity
        engine.v_e = sqrt((2*gamma)/(gamma-1) * R * engine.T_c * ... 
                     (1 - (engine.P_e/engine.P_c)) ^ ((gamma-1)/gamma)); % [m/s] ([1] eq 3-16) 
        
        %%% required mass flowrate to hit target thrust
        engine.mdot = (engine.F_t + (P_atm - engine.P_e))/engine.v_e; % [kg/s] 
        


%%% IF ONLY EXIT DIAMETER IS ASSIGNED
    elseif  isempty(engine.d_t) &&  ~isempty(engine.d_e)
        warning("Cannot assign exit area without throat area. Assuming ideal exit.")

        %%% assign ideal exit pressure as nominal
        engine.P_e = P_e_ideal; % [Pa]
        
        %%% ideal exit velocity
        engine.v_e = sqrt((2*gamma)/(gamma-1) * R * engine.T_c * ... 
                     (1 - (engine.P_e/engine.P_c)) ^ ((gamma-1)/gamma)); % [m/s] ([1] eq 3-16)

        %%% required mass flowrate to hit target thrust
        engine.mdot = engine.F_t/engine.v_e; % [kg/s] 

        %%% throat area required to hit target thrust
        engine.A_t = engine.mdot/engine.P_c * sqrt(R * engine.T_c) / ...
                     sqrt(gamma * (2/(gamma+1))^((gamma+1)/(gamma-1))); % [m^2] ([1] eq 3-24)
        
        %%% ideal exit area
        engine.A_e = engine.A_t * AeAt_ideal; % [m^2]

        %%% critical diameters
        engine.d_t = sqrt(4 * engine.A_t / pi); % [m]
        engine.d_e = sqrt(4 * engine.A_e / pi); % [m]



%%% IF ONLY THROAT DIAMETER IS ASSIGNED
    elseif  ~isempty(engine.d_t) && isempty(engine.d_e)
        %%% assign ideal exit pressure as nominal
        engine.P_e = P_e_ideal; % [Pa]

        %%% ideal exit velocity
        engine.v_e = sqrt((2*gamma)/(gamma-1) * R * engine.T_c * ... 
                     (1 - (engine.P_e/engine.P_c)) ^ ((gamma-1)/gamma)); % [m/s] ([1] eq 3-16) 
        
        %%% required mass flowrate to hit target thrust
        engine.mdot = engine.F_t/engine.v_e; % [kg/s] 

        %%% throat area from assigned diameter
        engine.A_t = pi*engine.d_t^2/4; % [m^2]

        %%% ideal exit area
        engine.A_e = engine.A_t * AeAt_ideal; % [m^2]

        %%% critical diameters
        engine.d_e = sqrt(4 * engine.A_e / pi); % [m]



%%% IF NEITHER THROAT OR EXIT DIAMETER ARE ASSIGNED
    elseif  isempty(engine.d_t) && isempty(engine.d_e)
        %%% assign ideal exit pressure as nominal
        engine.P_e = P_e_ideal; % [Pa]
        
        %%% ideal exit velocity
        engine.v_e = sqrt((2*gamma)/(gamma-1) * R * engine.T_c * ... 
                     (1 - (engine.P_e/engine.P_c)) ^ ((gamma-1)/gamma)); % [m/s] ([1] eq 3-16)

        %%% required mass flowrate to hit target thrust
        engine.mdot = engine.F_t/engine.v_e; % [kg/s] 

        %%% throat area required to hit target thrust
        engine.A_t = engine.mdot/engine.P_c * sqrt(R * engine.T_c) / ...
                     sqrt(gamma * (2/(gamma+1))^((gamma+1)/(gamma-1))); % [m^2] ([1] eq 3-24)
        
        %%% ideal exit area
        engine.A_e = engine.A_t * AeAt_ideal; % [m^2]

        %%% critical diameters
        engine.d_t = sqrt(4 * engine.A_t / pi); % [m]
        engine.d_e = sqrt(4 * engine.A_e / pi); % [m]

    end



%% PERFORMANCE CALCS
%%% CHARACTERISTIC VELOCITY
    engine.c_star = engine.P_c * engine.A_t / engine.mdot; % [m/s] ([1] eq 2-18)

%%% EFFECTIVE EXHAUST VELOCITY
    engine.c_eff = engine.v_e + (engine.P_e - P_atm)*engine.A_e/engine.mdot; % [m/s] ([1] eq 2-16)
    
%%% SPECIFIC IMPULSE
    engine.I_s = engine.F_t / (engine.mdot * 9.81); % [s] ([1] eq 2-5)

   

end