% Constructing algorithmic approach to satisfy that V and -grad(V)f_dot(x)
% are both SOS.
clc
clear all
close all

sdpvar x y

% Prompt user for ODEs and V in terms of x and y
x_dot = input('Enter x_dot in terms of x and y: ');
y_dot = input('Enter y_dot in terms of x and y: ');
V = input('Enter V in terms of x and y: ');
fprintf("\n\n")

gradVXdot = jacobian(V,[x y]);
gradVXdot(1) = -1*x_dot * gradVXdot(1); 
gradVXdot(2) = -1*y_dot * gradVXdot(2);

% Check V is sos
F = [sos(V)]

fprintf("\n*** Checking V is SOS ***\n")
solvesos(F)

h = sosd(F)
sdisplay(h)

% Check -V_dot is sos
F = [sos(gradVXdot)]

fprintf("\n*** Checking -V_dot is SOS ***\n")
solvesos(F)

h = sosd(F)
sdisplay(h)