function mesh(sim, t_w, dr_max)
%{
Discretizes nozzle through the chamber wall.

Inputs:
    t_w = (scalar) [m] chamber wall thickness
    dr_max = (scalar) [m] max radial element spacing

%}



%%% AXIAL POINT DATA
sim.x = sim.engine.x; % [m] pulling axial coordinates from nozzle contour
sim.Nx = length(sim.x); % number of axial nodes

%%% RADIAL POINT DATA
sim.Nr = ceil(t_w/dr_max) + 2; % number of radial nodes
sim.dr = t_w/(sim.Nr-2); % [m] radial element spacing

%%% DISCRETIZING
sim.r = zeros(sim.Nx, sim.Nr); % preallocating for radial coordinates

for nx = 1:sim.Nx
    for nr = 1:sim.Nr
        if nr == 1             
            %%% inner wall nodes
            sim.r(nx,nr) = sim.engine.r_iml(nx); % [m]

        elseif (nr == 2) || (nr == sim.Nr)      
            %%% 1st bulk wall nodes or outer wall nodes
            sim.r(nx,nr) = sim.r(nx,nr-1) + sim.dr/2; % [m]

        else                    
            %%% bulk wall nodes
            sim.r(nx,nr) = sim.r(nx,nr-1) + sim.dr; % [m]

        end
    end
end



end