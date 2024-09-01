function M = mach(At, A, gamma, regime)
%{
Finds mach numbers for supersonic or subsonic nozzle conditions via 
area-Mach number relation.

Author(s):
    Samuel Ciesielski

Inputs:
    At = (scalar) [m^2] throat (sonic) area 
    A = (scalar or vector) [m^2] local area(s) to evaluate mach number
    gamma = (scalar) specific heat ratio at sonic condtions (M = 1)
    regime = (string) 'supersonic' or 'subsonic' conditions

Outpus:
    M = (scalar or vector) mach number(s) correlating to local area(s)

%}

%%% ROOTFINDING
    M = zeros(1, length(A));
    for n = 1:length(A)

        %%% local area ratio
        A_ratio = A(n)/At;

        %%% use area ratio for initial guess
        switch regime
            case "subsonic"
                M0 = 1/A_ratio; 
            case "supersonic"
                M0 = A_ratio;
        end

        %%% check if conditions are sonic
        if A_ratio == 1
            M(n) = 1;
            
        %%% otherwise solve normally
        elseif A_ratio > 1 
            %%% area-mach relation zero function
            f = @(M) 1/M^2 * (2/(gamma+1) * (1 + (gamma-1)/2 * M^2)) ... 
                ^((gamma+1)/(gamma-1)) - 1*A_ratio^2;

            %%% find root
            M(n) = fzero(f, M0); 
            
        elseif A_ratio < 1
            error('Area ratio cannot be less than 1.')

        end

    end
        
end
