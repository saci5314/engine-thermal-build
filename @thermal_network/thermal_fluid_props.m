function [cp, k, rho, mu T_freeze, T_vapor] = thermal_fluid_props(fluid, T)
%{
Function for pulling temperature-dependent heat transport properties - 
specific heat, conductvity, density, and dynamic viscocity for common 
propellants coolants.

Inputs:
    fluid = (string) requested liquid properties
    T = [K] vector of temperatures at which properties are evaluated

Outputs:
    cp = specific heat capacity [J/kg*K]
    k = thermal conductivity [W/m*K]
    rho = density [kg/m^3]
    mu = dynamic viscocity [Pa*s]

Author:
    Samuel Ciesielski

Sources:

    [1] L.E. Faith, G.H. Ackerman, H.T. Henderson, "Heat Sink Capabilites
        of Jet A Fuel: Heat Transfer and Coking Studies"

    [2] NIST smth smth Methane smth smth


%}



%%% POPULATE INTERPOLATION DATA

    switch fluid
        case "Jet-A" 
            % data pulled from [1] pg 47. 
            % liquid phase only

            %%% approximately constant critical temps for incompressible fluid
            T_freeze = 225; % [K] ~freezing temp
            T_vapor = 575; % [K] ~vaporization temp

            %%% latent heat
            l = 0; % [J/kg]
    
            %%% sample temps
            T_data = (0:100:700)*5/9 +273.15; % [K]

            %%% cp sample data ([2] pg 47)
            cp_data = [1.84 2.13 2.41 2.69 3.01 3.38 3.94 6.41]*1000; % [J/(kg*K)]

            %%% k sample data ([2] pg 47)
            k_data = [175 157 141 127 114 102 90 90]/1000; % [W/(m*K)] 

            %%% rho sample data ([2] pg 47)
            rho_data = [845 809 769 725 677 619 543 403]; % [kg/m^3] 

            %%% mu sample data ([2] pg 47)
            mu_data = [4850 1270 591 368 269 167 91 46]*1e-6; % [Pa*s] 
            
        case "CH4" % (TODO)
            
        case "H2" % (TODO)

        case "Ethanol" % (TODO)

        case "H2O" % (TODO)
            
    end

%%% CHECK TEMP BOUNDS
    %%% below absolute zero
    if any(T < 0)
        error('Requested fluid properties below absolute zero.'); 
    end
    
    %%% below dataset
    if any(T < min(T_data))
        warning('Requested fluid properties below available dataset.'); 
    end
    
%%% INTERPOLATE AT REQUESTED TEMPERATURES
    cp = interp1(T_data, cp_data, T, 'spline', 'extrap'); % [J/(kg*K)]
    k = interp1(T_data, k_data, T, 'spline', 'extrap'); % [W/(m*K)]
    rho = interp1(T_data, rho_data, T, 'spline', 'extrap'); % [kg/m^3]
    mu = interp1(T_data, mu_data, T, 'spline', 'extrap'); % [Pa*s]

    

%% ARTIFICIAL CORRECTIONS

%%% BELOW ABSOLUTE ZERO
for n = 1:length(T)
    %%% BELOW DATASET
    if T(n) < min(T_data)
        cp(n) = interp1(T_data, cp_data, T(n), 'next', 'extrap'); 
        k(n) = interp1(T_data, k_data, T(n), 'next', 'extrap');   
        rho(n) = interp1(T_data, rho_data, T(n), 'next', 'extrap');
        mu(n) = interp1(T_data, mu_data, T(n), 'next', 'extrap');

    %%% ABOVE DATASET
    elseif T(n) > max(T_data)
        cp(n) = interp1(T_data, cp_data, T(n), 'previous', 'extrap'); 
        k(n) = interp1(T_data, k_data, T(n), 'previous', 'extrap'); 
        rho(n) = interp1(T_data, rho_data, T(n), 'previous', 'extrap');
        mu(n) = interp1(T_data, mu_data, T(n), 'previous', 'extrap');
    
    end

end


end