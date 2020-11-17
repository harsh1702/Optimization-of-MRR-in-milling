%% Here we have to declare whether we are maximizing or minimizing the function, not needed for the final project
%uncooment the variable input parameters later
type = 'min';
n = 2;
%type = input('enter whether you would maximize or minimize');
%n = input('enter the number of variables');

%% Decalring the tolerance

tol = 10^-12;

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
    [X, max, exitflag] = fminsearch(f_min, X0);
end

err = 100;
%update x0 with the value at which unconstrained optimization occurs
    
%% find the gradient of q and find x*(c)

c = 10000;  %some large initial value
alpha = 10; %set the multiplier value

while (err > tol)
    [q, f] = sympenfunc(X,c);
    syms x1 x2
    g(x1, x2) = gradient(q(x1, x2), [x1, x2]);
    %[G1, G2, G3] = gradient(q);
    %g = [G1; G2; G3];

    syms x1 x2
    J(x1, x2) = jacobian(g, [x1, x2]); %using the Jacobian matrix method to solve the system of non-linear equations

    %unsure about the transposes that are required here, because I haven't
    %defined x yet, according to what has been writen x should be a row vector
    X_new = transpose(X) - inv(J(X(1), X(2)))*g(X(1), X(2));
    %inv(J(X(1), X(2)))*g(X(1), X(2))
    
    err = abs(X_new - X);
    
    X = transpose(X_new);  %gets back the row vector
    %X
    c = alpha.*c;
    
    %err = f(X(1), X(2));    %the optimization should stop when the value of f is 0 ideally (here it is given by tol)
end


