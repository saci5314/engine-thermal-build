function J = fd_jacobian(f, x0, y0)
%{
Finite difference approximation of Jacobian matrix. 
See [1] function 4.6.1 for implementation details.

Inputs:
    f = function to be differentiated
    x0 = evaluation point
    y0 = f(x0)

Outputs:
    x = vector of approximations

Sources:
    [1] T.A. Driscoll, R.J. Braun, "Fundamentals of Numerical Computation," 
        Society for Industrial and Applied Mathematics, 2018.

%}

%%% Determine fd step size from machine error
delta = sqrt(eps);

%%% Preallocate stuff
    J = zeros(length(y0), length(x0));
    I = eye(length(x0));

%%% Build Jacobian
    for j = 1:length(x0)
        J(:,j) = (f(x0+delta*I(:,j)) - y0) / delta;
    end

end