% Constructing algorithmic approach to satisfy that V and -grad(V)f_dot(x)
% are both SOS.
% Code found: http://control.asu.edu/Classes/MAE598/598Lecture16.pdf
clc
clear all
close all

disp("Lyapunov Function Solver Utilising SOS");

% Prompt user for required data
nVar = input('Enter number of variables in system: ');
nEqn = input('Enter number of equations in system: ');
fprintf("\n")

% Set up YALMIP symbols
x = sdpvar(nVar,1);

% This structure contains each ODE per row
f = [];
disp("Enter equations with variables as x(1), x(2)..");
disp("For example: -1*x(2) - 1.5*x(1)^2 - 0.5*x(1)^3");
for i = 1 : nEqn
    fprintf("(Eqn #%d) ",i);
    f = [f;(input('Enter eqn: '))];
end
fprintf("\n")

% Generates a polynomial with degree 4
% V is polynomial
% Vc stores coefficients of each term
n = input('Enter degree polynomial to search for: ');
[V, Vc] = polynomial(x,n);
fprintf("\n")

% Setting constant term to 0
F = [Vc(1) == 0];

% Generate boundary function for defining positive definiteness
boundFun = 0;
for i = 1 : nVar
    boundFun = boundFun + x(i)^2;
end

% This ensures V is positive definite
zeta = input('Enter value for zeta: ');
F = [F;sos(V-zeta*boundFun^2)];

% Calculates the gradient of the cost function
gradV = jacobian(V,x);

% Creates sos instance for both V and -V_dot
F = [F;sos(-1*gradV*f)];

% Calculates V s.t V and -V_dot are sos
fprintf("\n\n")
solvesos(F,[],[],[Vc]);

% Construct V and display results
V = replace(V,Vc,value(Vc))
fprintf("V:\n")
sdisplay(V)