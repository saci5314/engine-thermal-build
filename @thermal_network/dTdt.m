function [dTdt, dTdt_data] = dTdt(t, T, Drr, Ds, sim)
%{
This is the evolution equation for the initial-boudary-value problem. It
finds the time rate of change of structural wall temps, ablatve wall temps,
film coolant temps, and regen coolant temps at the timestep.

Author:
    Samuel Ciesielski

Inputs:
    t = current time (not actually doing anything with this right now)
    T = (vector) [K] current system temps
    Drr = (matrix) [1/m^2] 2nd order radial differentiation matrix
    Ds = (matrix) [1/m] 1st order nozzle spline differentiation matrix
    engine = engine object being modeled

Outputs:
    dTdt = (struct) used to pull out whatever I need into IVBP functions.

%}

%%% RESHAPE EVALUATION TEMP VECTOR
    T = reshape(); % [K]



%%% ----------------------------------- %%%
%%% HOT WALL BOUDNARY CONDITION HEATING %%%
%%% ----------------------------------- %%%

if ~isempty(sim.film_coolant)   %%% film cooling present (UNDER CONSTRUCTION) 
    %%% PRALLOCATE

    
    
    
    %%% RADIATION
    


    %%% COOLANT EVOLUTION
    for nx = 1:sim.Nx


                %%% radiation
                dTdt(nx,1) = dQdt_film/() % [K/s]
                
                %%% hot wall heat flux
                q_wg(nx) = q_conv_wf + q_rad_wg; % [W/m^2] hot wall heat flux

                %%% coolant energy balance
                dQdt_film = (mdot_out*cp*T_out - mdot_out*cp*T_out) ...
                            + q_rad_film + q_film + q_wall; % [W]

                mdot_vap = 
                if T(nx,1) < T_sat % re
                    dTdt(nx,1) = dQdt_film/(); % [K/s]

                if T_out(nx) == T_sat
                    dTdt(nx,1) = dQdt_film/(); % [K/s]

                else 



                end

                q_wg(nx) = q_film_w + q_rad_w; % [

            case 2 %%% boiling stage
                T_out(nx) = ; % [K]


                h_wg = ; % [W/m]

            case 3 %%% gaseous cooling
                % gaseous film state variabkes

            case 4 % FULLY REDEVELOPED

        
            %%% convection
        end


        %%% temp change
    end



else    %%% no film cooling present (UNDER CONSTRUCTION)

    %%% heat flux to hot wall
    h_g = bartz(T(:,2), sim.r(:,1), sim.engine.r_t, sim.engine.rc_t); % [W/(m^2*K)] 
    q_wg = h_g .* (T(:,1) - T(:,2)); % [W/m^2] heat flux to hot wall

    %%% boundary layer temp change
    dTdt(:,1) = zeros(mesh.Nx,1); % [K/s]
end

%%% ------------------------------------ %%%
%%% COLD WALL BOUDNARY CONDITION HEATING %%%
%%% ------------------------------------ %%%

if ~isempty(sim.regen_coolant)   %%% regen cooling present (READY FOR TESTING)

    %%% thermal transport property vectors
    [cp_cool, k_cool, rho_cool, mu_cool] = ... 
        sim.thermal_fluid_props(sim.regen_coolant, T(:,end));
    
    %%% coolant velocity
    u_cool = (sim.mdot_regen./sim.n_chan) ./ (rho_cool.*sim.A_chan); % [m/s]

    %%% dimensonless flow parameters
    Re_cool = rho_cool .* u_cool .* sim.Dh_chan ./ mu_cool; % Reynolds numbver
    Pr_cool = cp_cool .* mu_cool ./ k_cool; % Prandtl number
    Nu_cool = sim.nusselt_forced(sim.regen_coolant, Re_cool, Pr_cool, T(:,end-1), T(:,end)); % Nusselt number

    % heat flux to cold wall
    h_wc = (k_cool ./ sim.Dh_chan) .* Nu_cool; % [W/(m^2*K)] 
    q_wc = h_wc .* (T(:,end) - T(:,end-1)); % [W/m^2] 

    % advection + cold wall convective heating
    dTdt(:,end) = u_cool .* (Ds * T(:,end)) - ...
                  q_wc ./ (cp_cool .* coolsys.h_chan .* rho_cool); % [K/s]

    dTdt(1,end) = 0; % [K/s] inlet boundary condition

else  %%% no regen cooling present (TODO)
    % adiabatic wall
    q_wc = 0;
    
    % ambient temp change (assuming negligible)
    dTdt(:,end) = zeros(Nx,1); % [K/s]

end



%%% ---------------------- %%%
%%% BULK WALL NODE HEATING %%%
%%% ---------------------- %%%
 
    if coolsys.ablative == 1   %%% structural + ablative wall (TODO)
        error("Ablative cooling not implemented");

    else    %%% structural wall only 

        for nx = 1:sim.Nx
            % thermal transport properties of wall at current temps
            [cp_wall, k_wall, rho_wall, ~] = thermal_mat_props(sim.wall_material, T(nx,2:end-1), 'linear');
            alpha = k_wall ./ (cp_wall .* rho_wall); % [m^2/s] thermal diffusivity of wall nodes
            
            % boundary heating vector
            dTdt_BC(1) = q_wg(nx) / (rho_wall(1)*mesh.dr*cp_wall(1)); % [K/s] hot wall boundary condition
            dTdt_BC(end) = q_wc(nx) / (rho_wall(end)*mesh.dr*cp_wall(end)); % [K/s] cold wall boundary condition
            
            % diffusion (heat equation) + cold/hot wall boundary heating
            dTdt(nx,2:end-1) = alpha .* (Drr * T(nx,2:end-1).').' + dTdt_BC; % [K/s] 

        end

    end



%%% RESHAPE/PACK TEMP EVOLUTION VECTOR
    dTdt = reshape(dTdt, [], 1); % [K/s]
    


end