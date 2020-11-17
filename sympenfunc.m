%% function used in penalty function method
%% f1, f2, f3 are the constraint functions
% Symbolic functions were used in MATLAB here
function [q, f] = sympenfunc(X, c)
    numParameters = 2;
    x = sym('x', [1, numParameters]);
    f1 = symfun(-x(1) + x(2), x);
    f2 = symfun(x(1) + x(2) - 1, x);
    f3 = symfun(-x(2), x);
    
    sym_func_f = matlabFunction(f1, f2, f3);
    [F1, F2, F3] = sym_func_f(X(1), X(2));
    
    f = c.*([max(0, F1), max(0, F2), max(0, F3)]*[f1.^2; f2.^2; f3.^2]);
    %f = c/2.*((max(0, f1)).^2 + (max(0, f2)).^2 + (max(0, f3).^2));       % R * constraint function
    q_inter = symfun(0.5.*((x(1)-3).^2 + (x(2)-2).^2), x);
    q = q_inter + f;                                                      % Objective function
end