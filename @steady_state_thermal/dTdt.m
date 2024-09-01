function [dTdt, Fo, Bi] = dTdt(t, T, sim)
%{
This is the evolution equation for the initial-boudary-value problem. It
finds the time rate of change of structural wall temps, ablatve wall temps,
film coolant temps, and regen coolant temps at the timestep.

Author:
    Samuel Ciesielski

Inputs:
    t = current time (not doing anything with this right now)
                     (could theoretically supply Pc vs t curve from test 
                     data, do chemical equilibrium calcs, and get new gas 
                     prop data on every timestep. Ignoring for now.)
    T = current system temps [K]
    mesh = struct containing nozzle geometry + grid data
    core_gas_props = struct containing combustion gas properties + state variables
    coolsys = struct containg cooling system configuration + state variable data
    sim = 

Outputs:
    dTdt = wall element temp rates of change [K/s]
    
%}



%%% DE-VECTORIZE TEMPS
    T = reshape(T, [], mesh.Nr+2); % [K] 



%%% PREALLOCATE SOME STUFF
    dTdt_BC = zeros(1,mesh.Nr);
    dTdt = zeros(mesh.Nx, mesh.Nr+2);



%%% HOT WALL BOUDNARY HEATING

    if coolsys.film == 1    %%% film cooling present (TODO) 
        error("Film cooling not implemented yet.")

    else    %%% no film cooling present (READY FOR TESTING)

        % heat flux to hot wall
        h_g = bartz(T(:,2), core_gas_props, mesh.r(:,1), mesh.r_t, mesh.rc_t); % [W/(m^2*K)] 
        q_wg = h_g .* (T(:,1) - T(:,2)); % [W/m^2] heat flux to hot wall

        % boundary layer temp change
        dTdt(:,1) = zeros(mesh.Nx,1); % [K/s]
    end



%%% COLD WALL BOUNDARY HEATING

    if coolsys.regen == 1   %%% regen cooling present (READY FOR TESTING)

        % thermal transport properties of coolant at curent temps
        [cp_cool, k_cool, rho_cool, mu_cool] = thermal_fluid_props(coolsys.working_fluid, T(:,end));
        
        % coolant velocity at current temps
        u_cool = coolsys.mdot_chan ./ (rho_cool .* coolsys.A_chan); % [m/s]

        % dimensonless flow parameters
        Re_cool = rho_cool .* u_cool .* coolsys.Dh_chan ./ mu_cool; % Reynolds numbver
        Pr_cool = cp_cool .* mu_cool ./ k_cool; % Prandtl number
        Nu_cool = nusselt_forced(coolsys.working_fluid, Re_cool, Pr_cool, T(:,end-1), T(:,end)); % Nusselt number

        % heat flux to cold wall
        h_c = (k_cool ./ coolsys.Dh_chan) .* Nu_cool; % [W/(m^2*K)] 
        q_wc = h_c .* (T(:,end) - T(:,end-1)); % [W/m^2] 

        % advection + cold wall convective heating
        dTdt(:,end) = -u_cool .* (mesh.Ds * T(:,end)) - ...
                       q_wc ./ (cp_cool .* coolsys.h_chan .* rho_cool); % [K/s]

        dTdt(1,end) = 0; % [K/s] inlet boundary condition

    else    %%% no regen cooling present (TODO)

        % heat flux to cold wall
        %h_c = * nusselt_natural(coolsys); % [W/(m^2*K)] 
        %q_wc = h_c .* (T(:,end-1) - T(:,end)); % [W/m^2] 
        q_wc = 0;
        
        % ambient temp change (assuming negligible)
        dTdt(:,end) = zeros(Nx,1); % [K/s]

    end



%%% BULK WALL TEMP HEATING

    if coolsys.ablative == 1   %%% structural + ablative wall (TODO)
        error("Ablative cooling not implemented");

    else    %%% structural wall only (READY FOR TESTING)

        for nx = 1:mesh.Nx
            % thermal transport properties of wall at current temps
            [cp_wall, k_wall, rho_wall, ~] = thermal_mat_props(coolsys.wall_material, T(nx,2:end-1), 'linear');
            alpha = k_wall ./ (cp_wall .* rho_wall); % [m^2/s] thermal diffusivity of wall nodes
    
            % boundary heating vector
            dTdt_BC(1) = q_wg(nx) / (rho_wall(1)*mesh.dr*cp_wall(1)); % [K/s] hot wall boundary condition
            dTdt_BC(end) = q_wc(nx) / (rho_wall(end)*mesh.dr*cp_wall(end)); % [K/s] cold wall boundary condition

            % diffusion (heat equation) + cold/hot wall boundary heating
            dTdt(nx,2:end-1) = alpha .* (mesh.Drr * T(nx,2:end-1).').' + dTdt_BC; % [K/s] 

        end
        
    end



%%% VECTORIZE OUTPUT
    dTdt = reshape(dTdt, [], 1); % [K/s]


    
end