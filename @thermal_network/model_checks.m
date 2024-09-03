function model_checks(sim)
% Plots nozzle mesh and cooling channel geometry.



%% PLOT COOLING CHANNEL GEOMETRY
figure

hold on
plot(sim.x, sim.w_chan)
plot(sim.x, sim.h_chan)
plot(sim.x, sim.Dh_chan)
plot(sim.x, sim.t_fin)

legend('Channel Width', 'Channel Height', 'Hydarulic Diameter', 'Fin Thickness')
xlabel('Axial postion (m)')
ylabel('(m)')
title('Cooling Channel Geometry')

xlim([0, sim.x(end)])
ylim([0, max([sim.w_chan sim.h_chan sim.Dh_chan sim.t_fin])*1.2])

hold off
grid on



%% PLOT MESH
figure
hold on

%%% HORIZONTAL LINES
for nr = 1:sim.Nr
    plot(sim.x, sim.r(:,nr), '-k');
end

%%% VERTICAL LINES
for nx = 1:sim.Nx
    line([sim.x(nx) sim.x(nx)], [sim.r(nx,1) sim.r(nx,end)], ...
         'Color', 'black');
end

hold off

%%% AXES INFO
title("Nozzle Wall Mesh", 'FontSize', 16)
xlabel("Axial pos (m)")
ylabel("Radial pos (m)")

%%% WINDOW & SCALING
ylim([0, max(sim.x)/2])
xlim([0, max(sim.x)])
pbaspect([2 1 1])






end