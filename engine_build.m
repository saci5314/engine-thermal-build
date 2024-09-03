%{
---------------------------------------------------------------------------
Design file for the Reaper TCA.
---------------------------------------------------------------------------

---------------------------------------------------------------------------
Author: Samuel Ciesielski
---------------------------------------------------------------------------
%}



%% HOUSEKEEPING
clc; close all; clear;



%% ENGINE DESIGN
    
reaper = engine; % duh
    
%%% IMPORT CEA DATA
    reaper.import_cea_data("reaper_cea.txt");
    
%%% PROPELLANT SELECTION
    reaper.fuel_type = 'Jet-A'; % liquid methane / LNG
    reaper.ox_type = 'LO2'; % liquid oxygen / LOX
    
%%% PERFORMANCE & HIGH-LEVEL SIZING
    reaper.F_t = 660*4.448; % [N] target thrust
    reaper.P_c = 400*6894.76; % [Pa] chamber pressure
    
    reaper.d_c = 2.5*.0254; % [m] combustion chamber dameter
    
    P_atm = 81000; % [Pa] target exit pressure (~Boulder ambient pressure)
    reaper.nozzle_design_calcs(P_atm);
    
%%% NOZZLE CONTOUR
    reaper.l_c = 6*.0254; % [m] chamber length (injector to throat plane)
    
    reaper.rc_c = .5*.0254; % [m] converging edge radius of curvature
    reaper.rc_t = .5*.0254; % [m] throat radius of curvature
    
    reaper.theta_conv = 45; % [deg] converging section angle
    theta_div = 15; % [deg] diverging angle for conical nozzle
    reaper.theta_conv = 45; % [deg] converging section angle
    dx_max = .0025; % [m] max axial element spacing
    r_tol = .0001; % [m] allowbale fit error in radial direction
    
    reaper.assign_conical_noz(theta_div, dx_max, r_tol);
    
%%% COMBUSTION GAS FLOW PROPERTIES
    reaper.core_gas_props();

%%% ENGINE MODEL CHECKS
    reaper.model_checks();



%% THERMAL ANALYSIS

hotMetal = thermal_network(reaper); % hell yeah brother

%%% MESHING
    t_w = .002; % [m] inner wall thickness
    dr_max = .0002; % [m] thru-wall max element thickness
    
    hotMetal.mesh(t_w, dr_max);
    
%%% CONFIGURE COOLING SYSTEM
    %%% regen cooling
    mdot_regen = reaper.mdot; % [kg/s] regen flowrate
    T_regen_in = 273.15; % [K] regen inlet temp
    
    n_chan = 20; % number of cooling channels
    t_fin = ones(1, hotMetal.Nx)*.001; % [m] fin thickness vector
    h_chan = ones(1, hotMetal.Nx)*.002; % [m] channel height vector
    
    hotMetal.add_regen(mdot_regen, T_regen_in, n_chan, t_fin, h_chan);
    
    %%% film cooling
    %mdot_film = ; % [kg/s] film coolant flowrate
    %x_film_in = ; % [m] film inlet location
    
    %hotMetal.add_film(mdot_film, x_film_in);
    
%%% SEND IT
    hotMetal.model_checks();
    %hotMetal.solve("euler"); % (TODO)
    %hotMetal.solve("rk2"); % (TODO)
    %hotMetal.solve("rk4"); % (TODO)
    %hotMetal.solve("am2"); % (TODO)
    
%%% POSTPROCESSING
    %hotMetal.plot_steady_data(); % (UNDER CONSTRUCTION)
    %hotMetal.plot_transient_data(); % (TODO)
    %hotMetal.export_sim_results(); % (TODO)