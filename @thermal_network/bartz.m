function h_g = bartz(T_wg, T_c, P_c, gamma, M, c_star, mu, cp, Pr, r, r_t, rc_t)
%{
This function finds the convective heat transfer coefficient between the
combuson gas and the inner wall of the combustion chamber per Bartz's
equation.

Inputs:
    T_wg = [K] vector of IML (inner mold line) wall temps
    gas_props = struct containng combustion gas property data
    r = [m] nozzle IML radii vector
    r_t = [m] nozzle throat radius
    rc_t = [m] nozzle radius of curvature
    
Outputs:
    h_g = [W/(m^2*K)] vector of heat transfer coefficients 

Author:
    Samuel Ciesielski

Sources: 

    [1] Bartz, D. R. , "A Simple Equation for Rapid Estimation of Rocket
        Nozzle Convective Heat Transfer Coefficients", Jet Propulsion
        Laboratory, California Insititute of Technology.

%}


%%% coefficient for the coefficient ([1] eq. 6)
    sigma = (.5 .* (T_wg./T_c) .* (1 + (gamma-1)./2 .* M.^2) + .5) .^ -.68 ...
            .* (1 + (gamma - 1)./2 .* M.^2) .^ -.12; 

%%% heat transfer coefficient ([1] eq. 7)
    h_g = (.026/(2*r_t)^.2 .* (mu.^.2 .* cp ./ Pr.^.6) .* ... 
          (P_c / c_star).^.8 .* (2*r_t/rc_t).^.1) .* ...
          (r_t^2 ./ r.^2).^.9 .* sigma; % [W/(m^2*K)] 
    
end