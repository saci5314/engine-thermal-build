function [x, dx] = dyadic_adapt(r, a, b, tol, noz)
%{
Dyadically refines the sample points for a 1D curve between two points.

Author(s):
    Samuel Ciesielski

Inputs:
    r = (function) [m] nozzle radius functon 
    a = (scalar) [m] left interval endpoint 
    b = (scalar) [m] right interval endpoint
    tol = (scalar) [m] absolute radial error
    noz = (struct) nozzle geometry data

Outputs:
    x = (vector) [m] refined interval sample vector
    dx = (vector) [m] element sizes

%}
    

%%% INITIATE BISECTION
    [x, dx] = bisect_curve(a, r(a, noz), b, r(b, noz), tol);
    
%%% BISECTON FUNCTION
    function [x, dx] = bisect_curve(a, r_a, b, r_b, tol)
        %%% evaluate new nodes
        m = (a+b)/2; r_m = r(m, noz);
        E = abs(r_m - (r_a+r_b)/2); % absolute error 
        
        %%% check if interpolation error warrants bisection
        if E > tol
            %%% refine further
            [xL, dxL] = bisect_curve(a, r_a, m, r_m, tol);
            [xR, dxR] = bisect_curve(m, r_m, b, r_b, tol);
            
            %%% merge left/right nodes w/o duplicate
            x = [xL, xR];         
            dx = [dxL, dxR];

        else
            %%% don't refine further
            x = m;
            dx = b-a;
            
        end
    end


        
end