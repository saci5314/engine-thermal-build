function [t, T] = euler(dTdt, T0, t_max, delta_conv)
%{
1st order euler integration for IBVP.

Author(s):
    Samuel Ciesielski

Inputs:
    dTdt = (vector) [K/s] system temperature evolution function
    T0 = (vector) [s] initial temps
    t_max = (scalar) [s] max simulation time
    i_max = (integer scalar) max timesteps
    delta_conv = (scalar) convergence criteria
    
Output:
    t = (vector) [s] solution timesteps
    T = (vector) [K] solution temps
%}

%% PREALLOCATING STUFF
    %%% time data
    % timestep by stab
    [~, Fi, Bo] = dTdt(t_vec(i), T0);

    % nominal timestep vector
    t_vec = linspace(tspan(1), tspan(2), dt); % [s]
    
    %%% temperature data
    T



%% INTEGRATION LOOP

for i = 2:length(t_vec)
    %%% UPDATED EVOLUTION VECTOR
    [dTdt, Fo, Bi] = dTdt(t_vec(i), T(i-1,:)); % [K] temp change

    %%% TAKE TIMESTEP
    if any((1-2*Fo) < 0)    % timestep stability check
        warning(strcat("Abort - violated timestep criteria at ", ...
                num2str(t_vec(i))," after ", num2str(i), " iterations."));

        %%% package solution vectors
        t = t_vec(1:i-1); % [s]
        T = T(:,1:i-1); % [K]
        
        %%% exit integration loop
        break

    elseif any(Fo.*(1+Bi) > .5)   % surface node stability check
        %%% throw warning
        warning(strcat("Abort - violated surface node criteria at ", ...
                num2str(t_vec(i))," after ", num2str(i), " iterations."));

        %%% package solution vectors
        t = t_vec(1:i); % [s]
        T = T(:,1:i); % [K]
        
        %%% exit integration loop
        break

    else    % just update new temps
        T(:,i) = T(:,i-1) + dTdt*dt; % [K]

    end

    %%% CONVERGENCE CHECK
    delta = abs(T(:,i) - T(:,i-1)) ./ T(:,i-1); 

    if all(delta < delta_conv)
        %%% annouce convergence
        disp(strcat("Solution converged at ", num2str(t_vec(i)), ...
                    " after ", num2str(i), " iterations."));

        %%% package solution vectors
        t = t_vec(1:i); % [s]
        T = T(:,1:i); % [K]
        
        %%% exit integration loop
        break
        
    elseif i == length(t_vec)
        %%% announce no convergence
       disp("Solution failed to converge by simulation end time.");

       %%% package solution vectors
       t = t_vec; % [s]

    end


end





end