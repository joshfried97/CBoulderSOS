% Running through function calls in SOSTOOL Book
clear all 
close all
clc

% Following (https://yalmip.github.io/tutorial/sumofsquaresprogramming/)
x = sdpvar(1,1); % defines Yalmips symbolic decision vars
y = sdpvar(1,1);

% Stanford slides, slide 6 example
p1 = 4*x^4 + 4*(x^3)*y - 7*(x^2)*(y^2) - 2*x*(y^3) + 10*y^4;

% Calculates and outputs decomp
F = sos(p1);
solvesos(F);
h1 = sosd(F);

% Stanford slides, slide 10 example
p2 = 2*x^4 + 2*(x^3)*y - (x^2)*(y^2) + 5*y^4;

% Calculates and outputs decomp
F = sos(p2);
solvesos(F);
h2 = sosd(F);

fprintf("Calculation of p - h'*h to determine accuracy of SOS decomp:\n\n")

fprintf("Stanford slides; slide 6 example:\n")
p1-h1'*h1
fprintf("\nStanford slides; slide 10 example:\n")
p2-h2'*h2


