%% Here we have to declare whether we are maximizing or minimizing the function, not needed for the final project
type = input('enter whether you would maximize or minimize');
n = input('enter the number of constraints');

%% Decalring the tolerance

tol = 10^-3;    %consider reducing the value of tol

%% first we do an unconstrained optimization for the initial point

x0 = zeros(1:n);
[q, f] = penfunc(x0, 0);    %need to check once if this is valid
if (type == 'max')
    invpenfunc = 1/q;
    val = fminsearch(invpenfunc, x0);
    max = penfunc(x, 0);
else
    val = fminsearch(q, x0);
    max = penfunc(x, 0);
end
%update x0 with the value at which unconstrained optimization occurs
    
%% find the gradient of q and find x*(c)

c = 10000;  %some large initial value
alpha = 10; %set the multiplier value

while (err > tol)
    [q, f] = penfunc(x,c);
    [G1, G2, G3] = gradient(q);
    g = [G1; G2; G3];

    J = jacobian([G1, G2, G3], [x(1), x(2), x(3)]); %using the Jacobian matrix method to solve the system of non-linear equations

    %unsure about the transposes that are required here, because I haven't
    %defined x yet, according to what has been writen x should be a row vector
    x = tr(x) - g/J;
    x = tr(x);  %gets back the row vector
    c = alpha.*c;
    
    err = f;    %the optimization should stop when the value of f is 0 ideally (here it is given by tol)
end


