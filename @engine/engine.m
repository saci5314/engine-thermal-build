classdef engine < handle

    properties

        %%% CEA DATA
        cea_data                    % (struct) chemical equilibrium data

        %%% PERFORMANCE CHARACTERISTCS
        F_t                         % (scalar) [N] target thrust
        P_c                         % (scalar) [Pa] chamber pressure
        P_e                         % (scalar) [Pa] exit pressure
        mdot                        % (scalar) [kg/s] net propellant flowrate
        T_c                         % (scalar) [K] chamber stagnation temp
        c_star                      % (scalar) [m/s] characteristic velocity
        c_eff                       % (scalar) [m/s] effective exhaust velocity
        v_e                         % (scalar) [m/s] ideal exhause velocity
        I_s                         % (scalar) [s] specific impulse
        
        %%% PROPELLANTS
        fuel_type                   % (string) indicating fuel       
        ox_type                     % (string) indicating oxdizer

        %%% TCA GEOMETRY
        x                           % (vector) [m] nozzle contour sample points
        dx                          % (vector) [m] element height vector
        r_iml                       % (vector) [m] inner mold line radius vector
        A                           % (vector) [m] inner mold line area vector
        l_c                         % (scalar) [m] chamber length 
        d_c                         % (scalar) [m] chamber diameter
        d_t                         % (scalar) [m] throat diameter
        d_e                         % (scalar) [m] exit diameter
        A_c                         % (scalar) [m^2] chamber area
        A_t                         % (scalar) [m^2] throat area
        A_e                         % (scalar) [m^2] exit area
        rc_c                        % (scalar) [m] converging edge radius of curvature
        rc_t                        % (scalar) [m] throat radius of curvature
        theta_conv                  % (scalar) [deg] converging angle

        %%% CORE GAS ISENTROPIC FLOW PROPERTIES
        M                           % (vector) local mach numbers
        P_static                    % (vector) [Pa] local static pressure
        T_static                    % (vector) [K] local static temperature
        rho                         % (vector) [kg/m^3] local gas density

        %%% CORE GAS THERMAL TRANSPORT PROPERTIES
        gamma                       % (vector) specific heat ratio
        cp                          % (vector) [W/(kg*K)] specific heat capacity
        mu                          % (vector) [Pa*s] dymamic viscocity
        k                           % (vector) [W/(m*K)] thermal conductivity
        Re                          % (vector) Reynold's number
        Pr                          % (vector) Prantyl number
        T_aw                        % (vector) [K] adiabatic wall temperature

    end



    methods 

        %%% IMPORT CEA DATA
        import_cea_data(engine, filename) 

        %%% DESIGN CALCS
        nozzle_design_calcs(engine, P_atm)                          

        %%% NOZZLE CONTOUR GENERATION
        assign_conical_noz(engine, theta_div, dx_max, r_tol)   % generates conical nozzle spline
        assign_parabolic_noz(engine, dx_max, r_tol)            % generates parabolic nozzle spline (TODO)
        assign_rao_noz(engine, dx_max, r_tol)                  % generates rao nozzle spline (TODO)
        
        %%% NOZZLE IMPORT/EXPORT OPTIONS
        import_nozzle_dxf(engine, filename)                    % import nozzle geometry (TODO)
        export_nozzle_dxf(engine, filename)                    % export nozzle geometry (TODO)
        
        %%% CORE GAS FLOW PROPERTY CALCS
        core_gas_props(engine) % (UNDER CONSTRUCTION)

        %%% DESIGN VISUALS
        model_checks(engine) % (UNDER CONSTRUCTION)

    end

    methods (Static, Access = private)
        %%% MESH ADAPTATION
        [x, dx] = dyadic_adapt(r, a, b, tol, noz)

        %%% MACH-AREA RELATION
        M = mach(At, A, gamma, regime)

    end

end