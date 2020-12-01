%% function used in penalty function method
%% f1, f2, f3 are the constraint functions
% Symbolic functions were used in MATLAB here
function [q, f] = sympenfunc(X, c)
%     r = ;
%     N_f = ;
    
%     numParameters = 3;
    numParameters = 2;
    x = sym('x', [1, numParameters]);
    
    f1 = symfun(-x(1) + x(2), x);
    f2 = symfun(x(1) + x(2) - 1, x);
    f3 = symfun(-x(2), x);


%   Here x(1) is the axial doc, x(2) is the feed per tooth and 
%   x(3) is the spindle speed
%     f1 = symfun(-x(1), x);
%     f2 = symfun(-x(1), x);
%     f3 = symfun(-x(1), x);
%     f4 = symfun(x(1)-1, x);
%     f5 = symfun(x(2)-1, x);
%     f6 = symfun(x(3)-1, x);

     sym_func_f = matlabFunction(f1, f2, f3);
     [F1, F2, F3] = sym_func_f(X(1), X(2));

%     sym_func_f = matlabFunction(f1, f2, f3, f4, f5, f6);
%     [F1, F2, F3, F4, F5, F6] = sym_func_f(X(1), X(2), X(3));
    
    %Vectors for chatter and deflection penalties
%     for i = 1:N_p
%         P_ck = symfun(-(x(3) - 1.5).^2 - (x(1) - 2.25), x);
%         P_dk = exp(-50*x(2)/x(1));
%     end

%     f = c.*([max(0, F1), max(0, F2), max(0, F3), max(0, F4), max(0, F5), max(0, F6)]*[f1.^2; f2.^2; f3.^2; f4.^2; f5.^2; f6.^2]);
    f = c.*([max(0, F1), max(0, F2), max(0, F3)]*[f1.^2; f2.^2; f3.^2]);        % R * constraint function
     q_inter = symfun(0.5.*((x(1)-3).^2 + (x(2)-2).^2), x);                 % Objective function
%     q_inter = symfun(0.5.*((x(1)-3).^2 + (x(1)*x(2) - 2)), x);             % x*y term is also included here
%     q_inter = symfun((1 - N_p*sum(P_ck+P_dk).^2), x);
    q = q_inter + f;
end
