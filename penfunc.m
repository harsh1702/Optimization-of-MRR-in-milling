%% function used in penalty function method
%% f1, f2, f3 are the constraint functions
function [q, f] = penfunc(x,c)
    f1 = -x(1) + x(2);
    f2 = x(1) + x(2) - 1;
    f3 = -x(2);
    f = c/2.*((max(0, f1)).^2 + (max(0, f2)).^2 + (max(0, f3).^2));       % R * constraint function
    q = 0.5.*((x(1)-3).^2 + (x(2)-2).^2) + f;  % Objective function
end
