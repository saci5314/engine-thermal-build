function plot_steady_data(sim)
%{
This function produces plots & figures for steady-state sim data, or 
transient sim data at a specific timestep.

Author:
    Samuel Ciesielski
%}

%%% 2D SYSTEM TEMPS
    figure
      
    %%% hot/cold wall temps
    subplot(2,2,[3,4]);

    hold on
    plot(mesh.x, sim_data.T_wg, 'Color', "#A2142F", 'LineWidth', 1);
    plot(mesh.x, sim_data.T_wc, 'Color', "#0072BD", 'LineWidth', 1);
    yline(sim_data.T_melt, '--r', 'Melting Temp');
    title ('Wall Temps'); xlabel('Axial pos (m)'); ylabel('(K)');
    legend('hot wall', 'cold wall', 'Location', 'northwest');
    ylim([0, 1.2*max([sim_data.T_wg sim_data.T_melt])])
    hold off
    grid on
    
    %%% coolant temps
    subplot(2,2,1);
    hold on
    plot(mesh.x, sim_data.T_cool, 'Color', "#4DBEEE", 'LineWidth', 1);
    yline(sim_data.T_vapor, '--r', 'Vapor Temp')
    title ('Coolant Temp')
    xlabel('Axial pos (m)'); ylabel('(K)');
    y_lower = .8 * min(sim_data.T_cool);
    y_upper = 1.2 * max([sim_data.T_cool sim_data.T_vapor]);
    ylim([y_lower, y_upper])
    hold off
    grid on



    %%% heat transfer coefficients
    subplot(2,2,2);
    hold on
    plot(mesh.x, sim_data.h_g, 'Color', "#A2142F", 'LineWidth', 1);
    %plot(mesh.x, sim_data.h_c, 'Color', "#0072BD", 'LineWidth', 1);
    title ('Heat Transfer Coefficients');  
    xlabel('Axial pos (m)'); ylabel('(W/m^2*K)');
    %legend('hot wall', 'cold wall', 'Location', 'northwest');
    %ylim([0, 1.2*max([sim_data.h_g sim_data.h_c])]);
    ylim([0, 1.2*max(sim_data.h_g)]); 
    hold off
    grid on    
    
%{

    %%% heat flux
    subplot(2,2,4);
    plot(mesh.x, sim_data.q, 'Color', "#7E2F8E", 'LineWidth', 1);
    title ('Heat Flux'); xlabel('Axial pos (m)'); ylabel('(W/m^2)');
    ylim([0, 1.2*max(sim_data.q)]); 
    grid on
   

    sgtitle('System Temperatures')
    
%}

%sim_data.T_wg = .8 * gas_props.T_aw .* (min(mesh.r) ./ mesh.r);
%sim_data.T_wc = .95 .* sim_data.T_wg;



%%% 3D HEATMAP 
    figure
    
    %%% pull colormap RGB data
    Cw = flip(colormap('hot'));
    Cc = flip(colormap('winter'));
    close; figure 
    
    %%% generate axial points
    N = coolsys.N_chan;
    for nx = 1:mesh.Nx, Z(nx,1:N) = -mesh.x(nx); end
    
    %%% generate structural wall colormap data
    Tw_max = max(sim_data.T_wg);
    Tw_min = min(sim_data.T_wc);
    T_sample = linspace(Tw_min, Tw_max, length(Cw));
    
    %%% plotting bulk wall temps
    Nr = 10;
    for nr = 1:Nr
        if nr == 2, hold on; end
    
        % linearly interpolate colormap for radial layer
        for nx = 1:mesh.Nx
            Tw(nx,1:N) = sim_data.T_wg(nx) - ...
                        ((nr-1)/(Nr-1))*(sim_data.T_wg(nx)-sim_data.T_wc(nx));
        end
        C1 = interp1(T_sample,Cw,Tw);
    
        % generate XY points for surface
        [X,Y,~] = cylinder(mesh.r + (nr-1)*(mesh.t_wall/(Nr-1)), N-1);
    
        % pull XY poinst for cooling channels
        if nr == Nr-1, X_chan = X; Y_chan = Y; end
    
        % plot surface    
        %surf(X, Y, Z, C1, 'FaceAlpha', .1, 'EdgeColor', 'none');
        surf(X(:,1:N/2), Y(:,1:N/2), Z(:,1:N/2), C1(:,1:N/2,:), 'FaceAlpha', .3, 'EdgeColor', 'none');
    
    end
    
    %%% generate coolant channel
    Tc_max = max(sim_data.T_cool);
    Tc_min = min(sim_data.T_cool);
    T_sample = linspace(Tc_min, Tc_max, length(Cc));
    
    %%% linearly interpolate colormap for cooling channels
    for nx = 1:mesh.Nx, Tc(nx,1:N) = sim_data.T_cool(nx); end
    C2 = interp1(T_sample,Cc,Tc);
    
    %%% plot cooling channels
    for n = 1:N/2
        patch([X_chan(:,n); nan], ...
              [Y_chan(:,n); nan], ...
              [Z(:,n); nan], ...
              [C2(:,n,:); nan(1,1,3)], ...
              'FaceColor','none','EdgeColor','interp', 'LineWidth', 3);
        
    end
    
    %%% title
    title(engine.name, 'FontSize', 16)
    
    %%% Structural wall colorbar scaling
    Tw_ticks = linspace(Tw_min, Tw_max, 6);
    Tw1 = num2str(Tw_ticks(1)); 
    Tw2 = num2str(Tw_ticks(2));    
    Tw3 = num2str(Tw_ticks(3));    
    Tw4 = num2str(Tw_ticks(4));    
    Tw5 = num2str(Tw_ticks(5));    
    Tw6 = num2str(Tw_ticks(6));   
    
    %%% Coolant colorbar scaling
    Tc_ticks = linspace(Tc_min, Tc_max, 6);
    Tc1 = num2str(Tc_ticks(1)); 
    Tc2 = num2str(Tc_ticks(2));    
    Tc3 = num2str(Tc_ticks(3));    
    Tc4 = num2str(Tc_ticks(4));    
    Tc5 = num2str(Tc_ticks(5));    
    Tc6 = num2str(Tc_ticks(6));  
    
    %%% colorbars
    cb(1) = colorbar('Colormap', Cw, 'Location', 'west', 'Ticks', linspace(.05,.99,6), 'TickLabels', {Tw1,Tw2,Tw3,Tw4,Tw5,Tw6});
    cb(1).Label.String = "Wall Temperatures (K)";
    
    cb(2) = colorbar('Colormap', Cc, 'Location', 'east', 'Ticks', linspace(.05,.99,6), 'TickLabels', {Tc1,Tc2,Tc3,Tc4,Tc5,Tc6});
    cb(2).Label.String = "Coolant Temperatures (K)";
    
    %%% lock aspect ratio
    pbaspect([1 .5 2.75])
    
    hold off
    

end