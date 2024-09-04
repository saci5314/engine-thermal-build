function [cp, k, rho, cte, T_melt] = thermal_mat_props(material, T, type)
%{
This is a general function for pulling temperature-dependent heat transport 
properties for structural materials.

Could keep this data in a txt or csv and pull it, but we're not pulling a
lot of data at once so it seems more cheaper to just store it locally and
avoid opening/closing streams every time we want to call this function.

Inputs:
    material = string indicating requested material
    T = vector of temperatures at which properties are evaluated [K]

Outputs:
    cp = specific heat capacity [J/kg*K]
    k = thermal conductivity [W/m*K]
    rho = density [kg/m^3]
    cte = linear coefficient of thermal expanson [m/m*K] = [1/K]

Sources:
    [1] "Metallic Materials and Elements for Aerospace Vehicle Structures",
         MIL-HDBK-5H, Department of Defense, 1998.

%}

%% POPULATE INTERPOLATION DATA

switch material
    case "Al 6061" % (data from [1] pg 3-261, fig 3.6.2.0)
        %%% melting temp
        T_melt = 858.15; % [K] melting temp (1085 F)

        %%% sample temps (every 50 deg F)
        T_data = ((-400:100:1000) - 32) * (5/9) + 273.15; % [K]
        
        %%% sample property data
        cp_data = [.015 .09 .1430 .175 .198 ... 
                   .213 .223 .231 .237 .243 ...
                   .247 .252 .256 .264 .270]*4.1839e+03; % [Btu/(lb*F)] --> [J/(kg*K)]

        k_data = [26 53 68 77 84 ... 
                  89 93 97 100 102 ...
                  103.5 103.5 102.5 101 97]*1.7296; % [Btu/(ft*hr*F)] --> [W/(m*K)]   

        cte_data = [8.6 10.3 11.35 12 12.4 ...
                    12.7 13 13.3 13.6 13.9 ...
                    14.15 14.45 14.75 15 15.3]*1.8e-6; % [1/F] --> [1/K]

        rho_ref = 2700; % [kg/m^3] reference density (@ 70 F)

    case "SS 316" % (TODO)

    case "SS 15-5 PH" % (TODO)

    case "AISI 1025" % (TODO)
        
    case "some sorta copper" % (TODO) 

    case "Inconel 718" % (data from [1] pg 6-51, fig 6.3.5.0)
        %%% melting temp
        T_melt = 1533; % [K] melting temp (2300 F)

        %%% sample temps (every 50 deg F)
        T_data = ((-400:100:1600) - 32) * (5/9) + 273.15; % [K]
        
        %%% sample property data
        cp_data = ((.065/1600)*T_data + .097)*4.1839e+03; % [Btu/(lb*F)] --> [J/(kg*K)]

        k_data = ((7.4/1600)*T_data + 6.4)*1.7296; % [Btu/(ft*hr*F)] --> [W/(m*K)]   

        cte_data = [5.0 5.5 6.0 6.4 6.7 6.9 7.1 7.3 7.45 7.6 7.7...
                    7.8 7.9 7.95 8.05 8.15 8.3 8.5 8.7 9.05 9.4]*1.8e-6; % [1/F] --> [1/K]

        rho_ref = 8300; % [kg/m^3] reference density (@ 70 F)

end



%% CHECK IF REQUESTED TEMPS ARE OUT OF BOUNDS

%%% BELOW ABSOLUTE ZERO
    if any(T < 0), error('Requested thermal material properties below absolute zero.'); end
    
%%% BELOW DATASET
    if any(T < min(T_data)), warning('Requested material properties below available dataset.'); end
    
%%% ABOVE MELTING TEMP
    if any(T > max(T_data)), warning('Requested material properties above available dataset.'); end



%% INTERPOLATE AT REQUESTED TEMPERATURES
    
cp = interp1(T_data, cp_data, T, type, 'extrap'); 
k = interp1(T_data, k_data, T, type, 'extrap');   
cte = interp1(T_data, cte_data, T, type, 'extrap');
%rho = calc_density(T_data, cte_data, rho_ref, T);
rho = rho_ref; % sufficient for small thermal strains



%% ARTIFICIAL CORRECTIONS

%%% BELOW ABSOLUTE ZERO
for n = 1:length(T)
    %%% BELOW DATASET
    if T(n) < min(T_data)
        cp(n) = interp1(T_data, cp_data, T(n), 'next', 'extrap'); 
        k(n) = interp1(T_data, k_data, T(n), 'next', 'extrap');   
        cte(n) = interp1(T_data, cte_data, T(n), 'next', 'extrap');

    %%% ABOVE DATASET
    elseif T(n) > max(T_data)
        cp(n) = interp1(T_data, cp_data, T(n), 'previous', 'extrap'); 
        k(n) = interp1(T_data, k_data, T(n), 'previous', 'extrap');   
        cte(n) = interp1(T_data, cte_data, T(n), 'previous', 'extrap');
    
    end

end



%% DENSITY CALCULATION

    function rho_vec = calc_density(T_data, cte_data, rho_ref, T_eval)

        %%% SOME SETUP
        T_ref = 294.261; % [K] reference temp
        cte_v = 3 * cte_data; % [m^3/(m^3*K)] volumetric expansion coefficient approximation

        rho_vec = zeros(1, length(T_eval)); % preallocate solution vector

        %%% COMPUTE DENSITY AT EACH TEMP
        for i = 1:length(T_eval)
            rho_vec(i) = rho_ref / exp(integral(@(T) interp1(T_data,cte_v,T), T_ref, T_eval(i)));
        end

    end

end