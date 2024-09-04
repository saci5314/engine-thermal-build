function x = quasi_newton(f, x1, tol)
%{
Quasi-newton rootfinding function using Levenberg's method. 
See [1] function 4.6.2 for implementation details.

Inputs:
    f = objective function
    x1 = initial guess
    tol = convergence criteria

Outputs:
    x = vector of approximations

Sources:
    [1] T.A. Driscoll, R.J. Braun, "Fundamentals of Numerical Computation," 
        Society for Industrial and Applied Mathematics, 2018.

%}

%%% CONVERGENCE CIRTERIA
    if nargin < 3; tol = 1e-12; end
    ftol = tol; xtol = tol; maxiter = 40;


%%% OPERATING PARAMETERS
    x = x1(:); fk = f(x1);
    k = 1; s = Inf;
    Ak = fd_jacobian(f,x(:,1),fk); % inital jacobian
    jac_is_new = true;
    I = eye(length(x));


%%% ROOTFIND
    lambda = 10;
    while(norm(s) > xtol) && (norm(fk) > ftol) && (k < maxiter)

        %%% compute step
        B = Ak'*Ak + lambda*I;
        z = Ak'*fk;
        s = -(B\z);

        xnew = x(:,k) + s; fnew = f(xnew);

        %%% accept result
        if norm(fnew) < norm(fk)
            y = fnew - fk;
            x(:,k+1) = xnew; fk = fnew;
            k = k+1;

            % get closer to Newton
            lambda = lambda/10; 

            % Broyden update of Jacobian
            Ak = Ak + (y-Ak*s)*(s'/(s'*s));
            jac_is_new = false;

        else
            % get closer to steepest descent
            lambda = lambda*4;

            % Re-initialize Jacobian if out of date
            if ~jac_is_new
                Ak = fd_jacobian(f,x(:,k),fk);
                jac_is_new = true;

            end

        end

    end

    if(norm(fk) > 1e-3)
        warning('Iteration did not find a root')
    end

end