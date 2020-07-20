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

% Create SOS model and run it
F = sos(p);
solvesos(F);
yalmipOutput = sdisplay(sosd(F));

% Create syms equivalent to YALMIP symbols
syms x;
syms y;

% Determines how many expressions need to be converted
numExp = size(yalmipOutput, 1);

% Converts and stores new sym expressions in new array
for i = 1:numExp
    symsArray(i) = str2sym(yalmipOutput{i})
end
