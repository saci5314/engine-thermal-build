function [t, T] = rk2(dTdt, t_span, T0, delta_conv)
%{
2nd order Runge-Kutta integration scheme.

Inputs:
    T0 = [K] initial temp matrix
    gas_props = struct containing core gas equilibrium properties
    coolsys = struct containing cooling system configuration data
    mesh = struct containing mesh/grid data
    params = struct containing simulation parameters

Outputs:
    t = [s] time vector
    T = [K] temp vector

Author:
    Samuel Ciesielski

Sources:
    [1] T.A. Driscoll, R.J. Braun, "Fundamentals of Numerical Computation," 
        Society for Industrial and Applied Mathematics, 2018.

%}



%%% PREALLOCATE SOLUTION
    %%% time data
    dt = params.dt; 
    t = 0:dt:params.t_max; 
    
    %%% temp data
    T = zeros(mesh.Nx*(mesh.Nr+2), length(t)); % [K] 
    T(:,1) = reshape(T0, [], 1); % [K] assign temps @ T=0



%%% SIMULATE

    for i = 2:length(t)
        disp(t(i))
    
        %%% integration step
        k1 = dTdt(t(i-1), T(:,i-1), mesh, gas_props, coolsys)*dt;
        dT = dTdt(t(i-1), T(:,i-1) + k1/2, mesh, gas_props, coolsys)*dt;
        
        T(:,i-1) = T(:,i-1) + dT; % [K]

        %%% simulation checker (TODO)

    end

end