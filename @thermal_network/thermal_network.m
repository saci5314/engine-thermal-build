classdef thermal_network < handle

    properties (Access = public)
        %%% ENGINE BEING ANALYZED
        engine
        
        %%% MESH DATA
        x                           % (vector) [m] axial node locations
        r                           % (matrix) [m] radial node locations
        dx                          % (vector) [m] axial node deltas
        dr                          % (scalar) [m] radial node deltas
        Nx                          % (scalar) number of axial nodes
        Nr                          % (scalar) number of radial nodes
    
        %%% SIMULATION SOLUTION DATA
        t                           % (vector) [s] timestep data
        T                           % (matrix) [K] solution temps
        h_g                         % (vector) [W/(m^2*K)] hot wall heat transfer coefficient
        h_c                         % (vector) [W/(m^2*K)] cold wall heat transfer coefficient
        q_wg_conv                   % (vector) [W/m^2] hot wall convective heat flux
        q_wg_rad                    % (vector) [W/m^2] hot wall radiative heat flux
        q_wc                        % (vector) [W/m^2] cold wall (convective) heat flux
        Q_cool                      % (vector) [W] cooling power

    end

    properties (Access = private)
        %%% MESH DATA
        x                           % (vector) [m] axial node locations
        r                           % (matrix) [m] radial node locations
        dx                          % (vector) [m] axial node deltas
        dr                          % (scalar) [m] radial node deltas
        Nx                          % (scalar) number of axial nodes
        Nr                          % (scalar) number of radial nodes

        %%% REGEN COOLING CONFIGURATION
        regen_coolant               % (string) regen coolant
        mdot_regen                  % (scalar) [kg/s] regen coolant
        T_regen_in                  % (scalar) [K] regen coolant inlet temp

        n_chan                      % (scalar) number of cooling channels
        t_fin                       % (vector) [m] channel fin thickness
        h_chan                      % (vector) [m] channel height
        w_chan                      % (vector) [m] channel width
        A_chan                      % (vector) [m^2] channel ara
        Dh_chan                     % (vector) [m] channel hydraulic diameter

        %%% FILM COOLING CONFIGURATION
        film_coolant                % (string) film coolant
        mdot_film                   % (scalar) [kg/s] film coolant mass flowrate
        T_film_in                   % (scalar) [K] film coolant inlet temp
        x_film_in                   % (scalar) [m] film inlet x position

    end

    methods (Access = public)
        %%% CLASS CONSTRUCTOR
        function analysis = steady_state_thermal(engine)
            if nargin == 1
                analysis.engine = engine;
            elseif nargin == 0
                error("Need to pass an engine to simulation object.");
            else
                error("Only one input argument allowed.");
            end
        end

        %%% PREPROCESSING
        mesh(sim, t_w, dr_max)
        
        %%% BOUNDARY CONDITIONS
        add_regen(sim, mdot, T_in, n_chan, t_fin, h_chan) 
        add_film(sim, coolant, mdot, x_in) % (TODO)
        
        %%% SOLVER
        model_checks(sim)
        thermal_solve(sim) % (UNDER CONSTRUCTION)

        %%% POSTPROCESSING
        plot_steady_data(sim) % (TODO)
        plot_transient_data(sim) % (TODO)
        export_sim_results(sim) % (TODO)

    end

    methods (Static, Access = private)
        %%% EVOLUTION FUNCTION
        [dTdt, Fo, Bi] = dTdt(t, T, sim) % (UNDER CONSTRUCTION)

        %%% INTEGRATION SCHEMES
        [t, T] = euler(dTdt, t_span, T0, delta_conv) % (UNDER CONSTRUCTION)
        [t, T] = rk23(dTdt, t_span, T0, delta_conv) % (TODO)
        [t, T] = am2(dTdt, t_span, T0, delta_conv) % (TODO)

        %%% FINITE DIFFERENCING METHODS
        J = fd_jacobian(f, x0, y0) % (TODO)
        D = fd_matrix(x, n, m) % (TODO)
        w = fornberg_coefficients(t, m) % (TODO)

        %%% PROPERY FUNCTIONS
        [cp, k, rho, mu, T_vapor] = thermal_fluid_props(fluid, T) % (TODO)
        [cp, k, rho, cte, T_melt] = thermal_mat_props(material, T, type) % (TODO)

        %%% HEAT TRANSFER FUNCTIONS
        h_g = bartz(T_wg, T_c, P_c, gamma, M, c_star, mu, cp, Pr, r, r_t, rc_t) % (TODO)
        h_c = h_c_coeff(T_c, T_wc, L_eff, A, working_fluid) % (TODO)
        epsilon_g = emissivity(N_H2O, N_CO2, P, T, V, A, Nx, method) % (TODO)
        
    end

end