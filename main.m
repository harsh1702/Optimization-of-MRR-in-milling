%% Here we have to declare whether we are maximizing or minimizing the function, not needed for the final project
%uncomment the variable input parameters later
type = 'min';
n = 2;
%type = input('enter whether you would maximize or minimize');
%n = input('enter the number of variables');

%% Decalring the tolerance

tol = 10^-12;
tol2 = 10^-3;

%% first we do an unconstrained optimization for the initial point

numPar = 2;
x = sym('x', [1 numPar]);

X0 = zeros(1:n);
[q, f] = sympenfunc(X0, 0);    %need to check once if this is valid
if (type == 'max')
    invpenfunc = 1/q;
    f_max = matlabFunction(invpenfunc, 'Vars', {x});
    [X, max, exitflag] = fminsearch(f_max, X0);
else
    f_min = matlabFunction(q, 'Vars', {x});
    [X, min, exitflag] = fminsearch(f_min, X0);
end

err = [100, 100];
%update x0 with the value at which unconstrained optimization occurs
    
%% find the gradient of q and find x*(c)

pass = 1;   %Since f = 0 should not be considered in the first pass
c = 10000;  %some large initial value
alpha = 10; %set the multiplier value

%while (all(err > tol) || logical(double(f(X(1), X(2)) > tol)))
while (logical(double(f(X(1), X(2)) > tol)) || pass == 1)    
    syms x1 x2
    g(x1, x2) = gradient(q(x1, x2), [x1, x2]);
    %[G1, G2, G3] = gradient(q);
    %g = [G1; G2; G3];

    syms x1 x2
    J(x1, x2) = jacobian(g, [x1, x2]); %using the Jacobian matrix method to solve the system of non-linear equations

    iterations = 0;
    
    while (iterations < 100)    %iterations required to solve the equation (grad(q) = 0)
        X_new = transpose(X) - inv(J(X(1), X(2)))*g(X(1), X(2));
        if (abs(X_new - transpose(X)) < tol2)
            break
        end
        X = transpose(X_new);       %gets back the row vector
        iterations = iterations + 1;
    end
    %inv(J(X(1), X(2)))*g(X(1), X(2))
    
    %err = abs(transpose(X_new) - X);
    
    [q, f] = sympenfunc(X,c);
    
    %X
    c = alpha.*c;
    pass = 0;
    
    %err = f(X(1), X(2));    %the optimization should stop when the value of f is 0 ideally (here it is given by tol)
end


