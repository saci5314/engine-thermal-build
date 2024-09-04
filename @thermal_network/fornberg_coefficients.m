function w = fornberg_coefficients(t,m)
%{
This function finds Fornberg finite difference coefficients differentiation
about t = 0 given unevenly spacex grid points.

Inputs:
    t = (vector) of arbitrarily spaced grid points
    m = (integer) differencing order

Outputs:
    w = (vector) Fornberg coefficients

Sources:
    [1] T. A. Driscoll, R. J. Braun, "Fundamentals of Numerical
        Computation," Society for Industrial and Applied Mathematics, 2018.

%}
    r = length(t)-1;
    w = zeros(size(t));
    for k = 0:r
        w(k+1) = weight(t,m,r,k);
    end



    function c = weight(t,m,r,k)
        
        if (m<0) || (m>r)
            c = 0;
        elseif (m==0) && (r==0)
            c = 1;
        else
            if k<r
                c = (t(r+1)*weight(t,m,r-1,k) - ...
                    m*weight(t,m-1,r-1,k))/(t(r+1)-t(k+1));
            else
                beta = prod(t(r)-t(1:r-1)) / prod(t(r+1)-t(1:r));
                c = beta*(m*weight(t,m-1,r-1,r-1) - t(r)*weight(t,m,r-1,r-1));
            end
        end
    end
end