function add_regen(sim, mdot, T_in, n_chan, t_fin, h_chan)
%{
Configures regen cooling model.

Inputs:
    mdot = (scalar) [kg/s] regen coolant flowrate
    T_in = (scalar) [K] coolant inlet temp
    n_chan = (scalar) number of cooling channels
    t_fin = (vector) [m] channel fin thickness (need to vectorize eventually)
    h_chan = (vector) [m] channel height (need to vectorize eventually)

%}



%%% LOCAL CHANNEL GEOMETRY CALCS
    %%% channel width
    w_chan = 2*pi*sim.r(:,end)'/n_chan - t_fin; % [m]
    
    %%% check channel widths are nonzero
    if any(w_chan < .00001)
        error("Channel width goes < .01 mm." + ...
              "Decrease channel count or fin thickness");
    end

    %%% channel areas
    A_chan = h_chan .* w_chan; % [m^2]

    %%% hydraulic diameter
    Dh_chan = 2*A_chan./(h_chan + w_chan); % [m]
    


%%% PACKAGE STUFF
    sim.regen_coolant = sim.engine.fuel_type;

    sim.mdot_regen = mdot; % [kg/s] 
    sim.T_regen_in = T_in; % [K]
    
    sim.n_chan = n_chan;
    sim.w_chan = w_chan; % [m]
    sim.h_chan = h_chan; % [m]
    sim.A_chan = A_chan; % [m^2]
    sim.Dh_chan = Dh_chan; % [m]
    sim.t_fin = t_fin; % [m]



end