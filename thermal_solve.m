function thermal_solve(analysis)
%{
Method that actually does the physics to find temps. For regen/film
problems, steady state soluition is extracted. For ablation problems, all
time data is extracted.

Inputs:
    engine = struct containing engine design data
    coolsys = struct containing TCS design data
    params = struct containing simulation parameters

Outputs:
    engine = struct containing updated engine design data
    mesh = struct containing engine geometry and grid data
    sim_data = struct containing simulation time and temperature data

Author:
    Samuel Ciesielski


%}


%%% ASSIGN INITIAL CONDITIONS
T0 = zeros(mesh.Nx, mesh.Nr+2);

    %%% bulk wall temps
    T0(:,2:end-1) = engine.T_atm; % [K] start out at ambient

    %%% hot wall boundary temps
    if coolsys.film == 1
        % (TODO)
    else
        T0(:,1) = gas_props.T_aw; % [K]
    end

    %%% cold wall boundary temps
    if coolsys.regen == 1
        T0(:,end) = coolsys.T_cool_in; % [K]
    else
        T0(:,end) = engine.T_atm; % [K]
    end


%%% SOLVE INITIAL-BOUNDARY-VALUE PROBLEM
    [t, T] = euler(T0, analysis);

%%% PACKING OUTPUT
    analysis.t = t;
    analysis.T = T;
    analysis.h_g = ba;
    anal


    if isempty(analysis.ablator)
        analysis.T = T(:,:,end);
    end






end