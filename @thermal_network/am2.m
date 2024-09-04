function [t, T] = am2(dTdt, t_span, T0, delta_conv)
%{
2nd order Adams-Moulton implicit integration scheme.

Inputs:
    T0            = [K] initial system temps
    gas_props     = struct containing core gas equilibrium properties
    coolsys       = struct containing cooling system configuration data
    mesh          = struct containing mesh/grid data
    params        = struct containing simulation parameters

Outputs:
    t             = [s] time vector
    T             = [K] temp vector

Author:
    Samuel Ciesielski

Sources:
    [1] T.A. Driscoll, R.J. Braun, "Fundamentals of Numerical Computation," 
        Society for Industrial and Applied Mathematics, 2018.

%}

%%% PREALLOCATE STUFF
    %%% time data
    dt = params.dt; 
    t = 0:dt:params.t_max; 
    
    %%% temp data
    T = zeros(mesh.Nx*(mesh.Nr+2), length(t)); % [K] 
    T(:,1) = reshape(T0, [], 1); % [K] assign temps @ T=0

%%% TIME STEPPING
    for i = 1:(length(t)-1)
        disp(t(i))
        % known objective function components
        T_known = T(:,i) + (dt/2)*dTdt(t(i), T(:,i), mesh, gas_props, coolsys);

        % quasi-newton rootfinding
        T_new = quasi_newton(@trapzero, T_known); % [K]
        
        % update solution vector
        T(:,i+1) = T_new(:,end); % [K]
    end



%%% DE-VECTORIZE SOLUTION
    T = reshape(T, [mesh.Nx, mesh.Nr+2, length(t)]); % [K]

    

%%% OBJECTIVE FUNCTION
    function F = trapzero(z)
        
        % from [1] eq 6.7.3:
        F = z - (dt/2)*dTdt(t(i+1), z, mesh, gas_props, coolsys) - T_known; 

    end


end