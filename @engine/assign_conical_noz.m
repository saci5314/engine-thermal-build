function  assign_conical_noz(engine, theta_div, dx_max, r_tol)
%{

This function generates a mesh for a conical nozzle given critical engine
geometry.

Author:
    Samuel Ciesielski

Inputs:
    theta_div = (scalar) diverging half angle [deg]
    dx_max = (scalar) max axial element spacing [m]
    r_tol = (scalar) contour absolute radial fit tolerance [m]

%}

%addpath('@engine/Methods/');



%% UNPACKING
    
%%% NOZZLE DESIGN GEOMETRY
    noz.r_c = engine.d_c/2;                % [m] chamber radius
    noz.r_t = engine.d_t/2;                % [m] throat radius
    noz.r_e = engine.d_e/2;                % [m] exit radius
    noz.theta_conv = engine.theta_conv;    % [m] converging angle
    noz.theta_div = theta_div;             % [m] diverging angle (conical only)
    noz.rc_c = engine.rc_c;                % [m] converging radius of curvature
    noz.rc_t = engine.rc_t;                % [m] throat radius of curvature
    noz.l_c = engine.l_c;                  % [m] chamber length (injector to throat plane)



%% DISCRETIZATION

%%% GLOBAL PLANE STATIONS
    %%% radii deltas 
    dr_1c = noz.rc_c*(1-cosd(noz.theta_conv));                              % [m] converging radius dr
    dr_1t = noz.rc_t*(1-cosd(noz.theta_conv));                              % [m] throat upstream (fwd) dr
    dr_2 = noz.rc_t*(1-cosd(noz.theta_div));                                % [m] throat downstream (aft) dr

    %%% injector plane
    X(1) = 0;                                                               % [m] injector plane

    %%% throat plane
    X(5) = noz.l_c;                                                         % [m] throat plane

    %%% converging section
    X(4) = X(5) - noz.rc_t*sind(noz.theta_conv);                            % [m] end of conical section
    X(3) = X(4) - (noz.r_c - noz.r_t - dr_1c - dr_1t)/tand(noz.theta_conv); % [m] start of conical section
    X(2) = X(3) - noz.rc_c*sind(noz.theta_conv);                            % [m] start of converging section

    %%% diverging section
    X(6) = X(5) + noz.rc_t*sind(noz.theta_div);                             % [m] start of conical section
    X(7) = X(6) + (noz.r_e - noz.r_t - dr_2)/tand(noz.theta_div);           % [m] exit plane

    %%% geometry checks
    if X(2) <= 0
        error("Chamber not long enough.")
    elseif engine.d_c < (1.5*engine.d_t)
        error("Chamber diameter is less than throat diameter. Go home.")
    end

    %%% give plane stations to nozzle geoemtry struct
    noz.X = X;

%%% SOLVE FOR ELEMENT STATION HEIGHTS
    %%% make base discretization
    N0 = ceil(X(7)/dx_max);
    x0 = linspace(0, X(7), N0+1); 

    %%% initialize solution vectors
    x = 0; % [m] global element heights from injector plane
    dx = 0; % [m] local element heights

    %%% step through base discretization
    for n = 1:N0 
        % refine base element
        [x_n, dx_n] = engine.dyadic_adapt(@conical_nozzle_radius, x0(n), x0(n+1), r_tol, noz);

        % append refined element(s)
        x = [x, x_n]; dx = [dx, dx_n];
    end
    
    %%% packing solution
    engine.x = [x, X(7)]; % [m] axial vector
    engine.dx = dx; % [m] element heights
    

%% INNER MOLD LINE (IML)

%%% CALC RADIUS VECTOR
    %%% initializing
    engine.r_iml = zeros(1, length(engine.x)); % [m]

    %%% solving
    for n = 1:length(engine.x)
        engine.r_iml(n) = conical_nozzle_radius(engine.x(n), noz); % [m]
    end

%%% CALC NOZZLE AREA VECTOR
    engine.A = pi .* engine.r_iml .^ 2; % [m^2]



%% RADIUS FUNCTION

    function r = conical_nozzle_radius(x, noz)
        %{
        Returns radius of a conical nozzle defined by noz at point x.
        
        Inputs:
            x = axial position from injector plane [m]
            noz = (struct) nozzle geometry data
        %}
        
        if (x >= noz.X(1)) && (x <= noz.X(2)) % straight chamber section
            r = noz.r_c; % [m]

        elseif (x > noz.X(2)) && (x <= noz.X(3)) % converging radius
            dr = noz.rc_c - sqrt(noz.rc_c^2 - (x - noz.X(2))^2); % [m]
            r = noz.r_c - dr; % [m]
        
        elseif (x > noz.X(3)) && (x <= noz.X(4)) % conical converging section
            dr1 = noz.rc_c - sqrt(noz.rc_c^2 - (noz.X(3) - noz.X(2))^2); % [m]
            dr2 = (x - noz.X(3))*tand(noz.theta_conv); % [m]
            r = noz.r_c - dr1 - dr2; % [m]
        
        elseif (x > noz.X(4)) && (x <= noz.X(6)) % throat radius
            dr = noz.rc_t - sqrt(noz.rc_t^2 - (noz.X(5) - x)^2); % [m]
            r = noz.r_t + dr; % [m]
        
        elseif (x > noz.X(6)) && (x <= noz.X(7)) % conical diverging section
            dr = (noz.X(7) - x)*tand(noz.theta_div); % [m]
            r = noz.r_e - dr; % [m]
        
        elseif (x < noz.X(1)) || (x > noz.X(7))
            error('Radius was requested at an axial positon outside the bounds of engine geometry.')
        end

    end


end