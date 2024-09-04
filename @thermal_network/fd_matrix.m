function D = fd_matrix(x, n, m)
%{
This function builds an nth-derivative, mth-order-accurate finite 
difference matrix for a 1D vector of arbitrarily spaced grid points.

Author:
    Samuel Ciesielski

Inputs:
    x = vector of arbitrarily spaced points
    n = order of differentiation
    m = order of accuracy (only supporting 2 or 4)

Outputs:
    D = finite difference matrix for x

Sources:
    [1] T. A. Driscoll, R. J. Braun, "Fundamentals of Numerical
        Computation," Society for Industrial and Applied Mathematics, 2018.

%}


%%% PREALLOCATE
    N = length(x); 
    D = zeros(N);

%%% DETECT INVALID ORDER
    if (m ~= 2) && (m ~= 4)
        warning("Supplied finite difference matrix order not supported." + ...
                "Defaulting to 2nd order accurate.");
        m = 2; 
    end

%%% POPULATE FINITE DIFFERENCE MATRIX
    switch m
        case 2
            %%% 2nd order
            D(1,1:4)                = fornberg_coefficients(x(1:4) - x(1), n);          
            D(end,end-4:end)        = fornberg_coefficients(x(end-4:end) - x(end), n);

            %%% bulk nodes
            for nx = 2:N-1
                D(nx,nx-1:nx+1)     = fornberg_coefficients(x(nx-1:nx+1) - x(nx), n);
            end

        case 4  %%% 4th order

            %%% boundary nodes
            D(1,1:5)                = fornberg_coefficients(x(1:5) - x(1), n);          
            D(2,1:5)                = fornberg_coefficients(x(1:5) - x(2), n);          
            D(end-1,end-5:end)      = fornberg_coefficients(x(end-5:end) - x(end-1), n);
            D(end,end-5:end)        = fornberg_coefficients(x(end-5:end) - x(end), n);

            %%% bulk nodes
            for nx = 3:N-2
                D(nx,nx-2:nx+2)     = fornberg_coefficients(x(nx-2:nx+2) - x(nx), n);
            end
            
    end

end