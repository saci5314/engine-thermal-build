function core_gas_props(engine)
%{
This function finds local mach number and static state variables along the
nozzle spline under the assumption of isentropic flow.

Author:
    Samuel Ciesielski

Sources:
    [1] J. Anderson, "Fundamentals of Aerodynamics," 6th-edition, 
        McGraw-Hill Education, 2017.

    [2] "Modern Engineering for Design of Liquid-Propellant Rocket
        Engines", D. K. Huzel, D. H. Huang, AIAA, 1992.

%}

%% PULL NOZZLE CONTOUR

x = engine.x; % [m] axial points
r = engine.r_iml; % [m] radial points



%% INTERPOLATE CEA DATA

%%% FIND CRITICAL INDICES 
    Nc = 0; Nt = 0;
    for n = 1:(length(x)-1)
        if (Nc == 0) && (r(n+1) < r(n)) % check for converging section start
            Nc = n; 
        end
        if (Nt == 0) && (r(n+1) > r(n)) % check for diverging section start
            Nt = n; 
            break
        end
    end

%%% INTERPOLATE
    %%% pull cea_data field names
    cea_propnames = fieldnames(engine.cea_data);
    
    %%% parse through each field
    for i = 1:length(cea_propnames)
        % indexed field name
        prop_i = convertCharsToStrings(cell2mat(cea_propnames(i)));
    
        % x fit points
        X = [ x(1) x(Nc) x(Nt) x(end) ] ; % [m]
    
        % data fit points
        V = [ engine.cea_data.(prop_i)(1) engine.cea_data.(prop_i)' ];
    
        % interpolation step
        cea_props.(prop_i) = interp1(X, V, unique(x), 'pchip'); % interpolation
    end



%% ISENTROPIC RELATIONS

gamma_sonic = cea_props.gam(2); % specific heat ratio at sonic conditions (throat)
engine.M = zeros(1, length(x)); % [dimensionless] preallocate mach number vector

%%% SUBSONIC/SUPERSONIC AREA VECTORS
    A_subsonic = pi * r(1:Nt).^2; % [m^2] upstream (subsonic) areas
    A_supersonic = pi * r(Nt+1:end).^2; % [m^2] downstream (supersonic) areas

%%% SUBSONIC MACH NUMBERS (UPSTREAM OF THROAT)
    engine.M(1:Nt) = mach(engine.A_t, A_subsonic, gamma_sonic, "subsonic");

%%% SUPERSONIC MACH NUMBERS (DOWNSTREAM OF THROAT)
    engine.M(Nt+1:end) = mach(engine.A_t, A_supersonic, gamma_sonic, "supersonic");

%%% STATIC TEMPERATURE ([1] eq 8.40)
    engine.T_static = engine.T_c ./ (1 + (gamma_sonic-1)/2 .* engine.M.^2); % [K]

%%% STATIC PRESSURE ([1] eq 8.42)
    engine.P_static = engine.P_c .* (1 + (gamma_sonic-1)/2 .* engine.M.^2) ...
                      .^ -(gamma_sonic/(gamma_sonic-1)); % [Pa] 

%%% STATIC DENSITY ([1] eq 8.43)
    engine.rho = engine.cea_data.rho(1) .* (1 + (gamma_sonic-1)/2 .* engine.M.^2) ... 
                    .^ -(1/(gamma_sonic-1)); % [kg/m^3]



%% THERMAL TRANSPORT PROPERTIES

%%% SPECIFIC HEAT RATIO
    engine.gamma = cea_props.gam; 

%%% SPECIFIC HEAT CAPCITY 
    engine.cp = cea_props.cp*1000; % [W/(kg*K)]

%%% DYNAMIC VISCOCITY ([2] eq 4-16, modified for SI units)
    engine.mu = (0.453592*39.37)*(46.6e-10)*((cea_props.mw*0.00220462).^.5) .* ...
                   ((1.8*engine.T_static).^.6); % [Pa*s]

%%% DIMENSIONLESS FLOW PARAMETERS
    %%% Prantl number approximation ([2] eq 4-15)
    engine.Pr = 4*engine.gamma./(9*engine.gamma-5); % [dimensionless]
    
    %%% Reynold's number 
    engine.Re = (2/pi)*engine.mdot ./ (engine.mu.*r); % [dimensionless]

%%% THERMAL CONDUCTIVITY
    engine.k = engine.cp .* engine.mu ./ engine.Pr; % [W/(m*K)]

%%% ADIABATIC WALL TEMP ([2] eq 4-10a)
    r_aw = engine.Pr.^.33; % correction factor ([2] pg 85)
    engine.T_aw = engine.T_c*(1+r_aw.*((engine.gamma-1)/2).*engine.M.^2)./ ...
                     (1+((engine.gamma-1)/2).*engine.M.^2); % [K] 


%% MACH NUMBER ROOTFINDING FUNCTION

    function M = mach(At, A, gamma, regime)
    %{
    Finds mach numbers for supersonic or subsonic nozzle conditions via 
    area-Mach number relation.
    
    Inputs:
        At = (scalar) [m^2] throat (sonic) area 
        A = (scalar or vector) [m^2] local area(s) to evaluate mach number
        gamma = (scalar) specific heat ratio at sonic condtions (M = 1)
        regime = (string) 'supersonic' or 'subsonic' conditions
    
    Outpus:
        M = (scalar or vector) mach number(s) correlating to local area(s)

    %}
    
    %%% ROOTFINDING
        M = zeros(1, length(A));
        for n = 1:length(A)
    
            %%% local area ratio
            A_ratio = A(n)/At;
    
            %%% use area ratio for initial guess
            switch regime
                case "subsonic"
                    M0 = 1/A_ratio; 
                case "supersonic"
                    M0 = A_ratio;
            end
    
            %%% check if conditions are sonic
            if A_ratio == 1
                M(n) = 1;
                
            %%% otherwise solve normally
            elseif A_ratio > 1 
                %%% area-mach relation zero function
                f = @(M) 1/M^2 * (2/(gamma+1) * (1 + (gamma-1)/2 * M^2)) ... 
                    ^((gamma+1)/(gamma-1)) - 1*A_ratio^2;
    
                %%% find root
                M(n) = fzero(f, M0); 
                
            elseif A_ratio < 1
                error('Area ratio cannot be less than 1.')
    
            end
    
        end
        
    end



end