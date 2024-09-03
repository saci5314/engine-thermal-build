function thermal_solve(sim, solver_type)
%{
Executes heat transfer IBVP.

Inputs:
    solver_type = (string) specifies integrations scheme

%}

%%% INITIAL CONDITIONS

T0 = 273.15*zeros(sim.Nx, sim.Nr); % [K]
    
    %%% hot wall boundary temps
    if ~isempty(film_coolant)
        T0(1,1) = sim.T_film_in; % [K] 
    else 
        T0(:,1) = sim.engine.T_aw; % [K]
    end
    
    %%% cold wall boundary temps
    if ~isempty(regen_coolant)
        T0(:,end) = sim.T_regen_in; % [K] 
    else 
        T0(:,end) = 273.15; % [K] 
    end


%%% TEMPORAL CONDITIONS


%%% CHOOSE INTEGRATION SCHEME
if sovler_type == "euler"   % 1st order Euler's method (UNDER CONSTRUCTION)
    
    [sim.t, sim.T] = sim.euler(@(t,T) dTdt(t, T, sim), T0, t_vec, i_max, delta_conv);
    
elseif solver_type == "rk23"    % 2nd/3rd order adaptive Runge-Kutta (TODO)

    [sim.t, sim.T] = sim.rk23(@(t,T) dTdt(t, T, sim), T0, t_vec, i_max, delta_conv);

elseif solver_type == "rk4"    % 4th order Runge-Kutta (TODO)

    [sim.t, sim.T] = sim.rk4(@(t,T) dTdt(t, T, sim), T0, t_vec, i_max, delta_conv);

elseif solver_type == "am2"    % 2nd order Adams-Moulton (implicit) (TODO)
    
    [sim.t, sim.T] = sim.am2(@(t,T) dTdt(t, T, sim), T0, t_vec, i_max, delta_conv);

end



end