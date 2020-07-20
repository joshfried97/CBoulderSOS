% Test script designed to show the automation of taking output of YALMIP
% toolbox and converting the char expressions into a symbolic ones which
% MATLAB can use with functions such as diff().
clc
clear all
close all

% Define YALMIP symbols
x = sdpvar(1,1);
y = sdpvar(1,1);

% Define polynomial p (using Stanford slide 6 example)
p = 4*x^4 + 4*(x^3)*y - 7*(x^2)*(y^2) - 2*x*(y^3) + 10*y^4;

% Turning pre and post-processing on
options = sdpsettings('sos.newton',1,'sos.congruence',1,'sos.numblkdg',1e-6);

% Create SOS model and run it
F = sos(p);
solvesos(F);
yalmipOutput = sdisplay(sosd(F));

% Create syms equivalent to YALMIP symbols
syms x;
syms y;

% Determines how many expressions need to be converted
numExp = size(yalmipOutput, 1);
symsExpression = 0;

% Converts and stores new sym expressions in new array
for i = 1:numExp
    tempExp = str2sym(yalmipOutput{i});
    symsExpression = symsExpression + tempExp^2;
end

% Printing expression
fprintf("Accurate result:\n")
symsExpression
fprintf("\n2 d.p result:\n")
vpa(symsExpression,2)

% 3D plotting on expression
fsurf(symsExpression)