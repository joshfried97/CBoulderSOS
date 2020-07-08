% Running through function calls in SOSTOOL Book
clear all 
close all
clc

% Following (https://yalmip.github.io/tutorial/sumofsquaresprogramming/)
x = sdpvar(1,1); % defines Yalmips symbolic decision vars
y = sdpvar(1,1);

%p = (1 + x)^4 + (1 - y)^2; % polynomial to decompose
p = 4*x^4 + 4*(x^3)*y - 7*(x^2)*(y^2) - 2*x*(y^3) + 10*y^4; % Testing poly from Stanford slides

% Calculates and outputs decomp
F = sos(p);
solvesos(F);
h = sosd(F);
sdisplay(h)

% Verifies whether decomp was successful 
% clean() is used to zero any coeffs < 1e-6
clean(p-h'*h,1e-6)

% Doing same decomp but with p = v'Qv format
F = sos(p);
[sol,v,Q] = solvesos(F);
sdisplay(v{1})
sdisplay(Q{1})
clean(p-v{1}'*Q{1}*v{1},1e-6)

