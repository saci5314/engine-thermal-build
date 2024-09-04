function [t, T, sim_data] = euler(dTdt, T0, t_max, delta_conv)
%{
1st order euler integration for thermal network IBVP.

Inputs:
    dTdt = (vector) [K/s] system temperature evolution function
    T0 = (vector) [s] initial temps
    t_max = (scalar) [s] max simulation time
    i_max = (integer scalar) max timesteps
    delta_conv = (scalar) convergence criteria
    
Output:
    t = (vector) [s] solution timesteps
    T = (vector) [K] solution temps

Author(s):
    Samuel Ciesielski

%}

%%% ---------------- %%%
%%% SIMULATION SETUP %%%
%%% ---------------- %%% 

%%% SIMULATION DATA

    %%% nominal timestep vector
    t = linspace(tspan(1), tspan(2), dt); % [s]
    
    %%% temperature data
    T = reshape

%%% DIFFERENTIATION MATRICIES
    Drr = sim.fd_matrix(); % diffusion (TODO)
    Ds = sim.fd_materix(); % advection (TODO)


%%% ------------ %%%
%%% TIMESTEPPING %%%
%%% ------------ %%% 

for i = 2:length(t)

    %%% UPDATE TEMPERATURE EVOLUTION VECTOR
    [dTdt, dTdt_data] = dTdt(t(i-1), T(i-1,:)); % [K] temp change

    %%% DO STABILITY CHECKS AND TAKE TIMESTEP
    if any()    % Von-Neumann stability criteria for diffusion (TODO)
        %%% throw warning
        warning(strcat("Abort - violated Von-neuman diffusion criteria at t = ", ...
                num2str(t(i)),"s after ", num2str(i), " iterations."));

        %%% pack solution vectors
        t = t(1:i); % [s]
        T = T(:,1:i); % [K]
        
        %%% exit integration loop
        break

    elseif any()    % Von-Neumann stability criteria for advection (TODO)
        %%% throw warning
        warning(strcat("Abort - violated Von-neuman advection criteria at t = ", ...
                num2str(t(i)),"s after ", num2str(i), " iterations."));

        %%% pack solution vectors
        t = t(1:i); % [s]
        T = T(:,1:i); % [K]
        
        %%% exit integration loop
        break

    elseif any((1-2*dTdt_data.Fo) < 0)    % timestep stability check
        warning(strcat("Abort - violated timestep criteria at ", ...
                num2str(t(i))," after ", num2str(i), " iterations."));

        %%% pack solution vectors
        t = t(1:i-1); % [s]
        T = T(:,1:i-1); % [K]
        
        %%% exit integration loop
        break

    elseif any(dTdt_data.Fo.*(1+dTdt_data.Bi) > .5)   % surface node stability check
        %%% throw warning
        warning(strcat("Abort - violated surface node criteria at t = ", ...
                num2str(t(i)),"s after ", num2str(i), " iterations."));

        %%% pack solution vectors
        t = t(1:i); % [s]
        T = T(:,1:i); % [K]
        
        %%% exit integration loop
        break

    else    % accept timestep
        %%% sim clock
        disp(strcat("t_sim = ", num2str(t(i)), " s"));
        
        %%% integrate
        T(:,i) = T(:,i-1) + dTdt*dt; % [K]

    end

    %%% PHASE CHANGE CORRECTIONS
    if ~empty(sim.film_coolant)
        for nx = 1:Nx

            if T()

            end
        end
    end

    %%% CONVERGENCE CHECK
    delta = abs(T(:,i) - T(:,i-1)) ./ T(:,i-1); 

    if all(delta < delta_conv)
        %%% annouce convergence
        disp(strcat("Solution converged at t = ", num2str(t(i)), ...
                    "s after ", num2str(i), " iterations."));

        %%% pack solution vectors
        t = t(1:i); % [s]
        T = T(:,1:i); % [K]
        
        %%% exit integration loop
        break

    end
        
    %%% TIMEOUT
    if i == length(t)
        %%% throw alert
       disp("Simulation timeout. Failed to converge.");

       %%% package solution vectors
       t = t(1:i); % [s]
       T = T(:,1:i); % [s]

    end

end

%%% ------------ %%%
%%% TIMESTEPPING %%%
%%% ------------ %%% 


end