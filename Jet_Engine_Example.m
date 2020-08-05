%% This script searches for V for a given input ODE 
% Code found: http://control.asu.edu/Classes/MAE598/598Lecture16.pdf
clear all
close all
clc

% Set up YALMIP symbols
sdpvar x y

% This structure contains each ODE per row
f = [-1*y - 1.5*x^2 - 0.5*x^3 ; 3*x - y];

% Generates a polynomial with degree 4
% V is polynomial
% Vc stores coefficients of each term
[V, Vc] = polynomial([x y],4);

% Setting constant term to 0
F = [Vc(1) == 0];

% This ensures V is positive definite as V >= eps*(x^2 + y^2)
F = [F;sos(V-0.00001*(x^2 + y^2))];

% Calculates the gradient of the cost function
gradV = jacobian(V,[x,y]);

% Creates sos instance for both V and -V_dot
F = [F;sos(-1*gradV*f)];

% Calculates V s.t V and -V_dot are sos
solvesos(F,[],[],[Vc]);

% Construct V and display results
V = replace(V,Vc,value(Vc)); 
sdisplay(V)