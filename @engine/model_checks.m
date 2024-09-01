function model_checks(engine)
%{
Visual checks for nozzle contour and isentropic flow calcs.

Author:
    Samuel Ciesielski

%}

%%% UNPACKING
    x = engine.x;

%%% NOZZLE CONTOUR
    figure
    hold on
   
    %%% nozzle contour
    plot(x, engine.r_iml, '.', 'Color', "#A2142F", 'MarkerSize', 8);
    plot(x, engine.r_iml, '-', 'Color', "#A2142F", 'LineWidth', 1);
    grid on
    
    %%% information
    title("Nozzle Wall Contour", 'FontSize', 16)
    xlabel("Axial pos (m)")
    ylabel("Radial pos (m)")

    %%% aspect ratio
    xlim([0, max(x)]); ylim([0, max(x)/2]);
    pbaspect([2 1 1])

    hold off


%%% ISENTROPIC FLOW PROPERTIES
    figure
      
    %%% mach
    subplot(2,2,1)
    plot(x, engine.M);
    title ('Mach Number')
    xlabel('Axial pos (m)'); 
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.M)]);
    grid on

    %%% density
    subplot(2,2,2)
    plot(x, engine.rho);
    title ('Gas Density')
    xlabel('Axial pos (m)'); ylabel('(kg/m^3)');
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.rho)]);
    grid on
    
    %%% static pressure
    subplot(2,2,3)
    plot(x, engine.P_static);
    title ('Static Pressure')
    xlabel('Axial pos (m)'); ylabel('(Pa)');
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.P_static)]);
    grid on
    
    %%% static temp
    subplot(2,2,4)
    hold on
    plot(x, engine.T_static);
    plot(x, engine.T_aw);
    title ('Chamber Temps')
    legend('Static Temp', 'Adiabatic Wall Temp', 'Location', 'southeast');
    xlabel('Axial pos (m)'); ylabel('(K)');
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.T_static)]);
    hold off
    grid on
    
    sgtitle('Core Gas Isentropic Flow Properties')
    


%% CORE GAS THERMAL TRANSPORT PROPERTIES

%%% QUALITATIVE CHECK
    figure
    
    %%% heat ratio
    subplot(2,2,1)
    plot(x, engine.gamma);
    title ('Specific heat ratio')
    xlabel('Axial pos (m)')
    xlim([0 x(end)]); ylim([1.1, 1.2]);
    grid on
    
    %%% heat capacity
    subplot(2,2,2)
    plot(x, engine.cp/1000);
    title('Specific Heat Capacity')
    xlabel('Axial pos (m)'); ylabel('(kW/kg*K)');
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.cp)/1000]);
    grid on
    
    %%% dynamic viscocity
    subplot(2,2,3)
    plot(x, engine.mu);
    title('Dynamic Viscocity')
    xlabel('Axial pos (m)'); ylabel('(Pa*s)');
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.mu)]);
    grid on
    
    %%% thermal conductivity
    subplot(2,2,4)
    plot(x, engine.k);
    title('Thermal Conductivity')
    xlabel('Axial pos (m)'); ylabel('(W/(m*K))');
    xlim([0 x(end)]); ylim([0, 1.2*max(engine.k)]);
    grid on
    
    sgtitle('Core Gas Thermal Transport Properties')
    


end