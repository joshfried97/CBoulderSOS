% Test script designed to show the automation of taking output of YALMIP
% toolbox and converting the char expressions into a symbolic ones which
% MATLAB can use with functions such as diff().
clc
clear all
close all

% Ask user for number of input var
var = input('Enter number of variables (2 or 3) in p: ');

% Ensuring correct input set
while (var ~= 2) && (var ~= 3)
    disp('Please use valid input')
    var = input('Enter number of variables (2 or 3) in p: ');
end;

% Define YALMIP symbols based on var
if var == 2
    x = sdpvar(1,1);
    y = sdpvar(1,1);
elseif var == 3
    x = sdpvar(1,1);
    y = sdpvar(1,1);
    z = sdpvar(1,1);
end

% User inputs p
p = input('Enter p: ')
%p = 4*x^4 + 4*(x^3)*y - 7*(x^2)*(y^2) - 2*x*(y^3) + 10*y^4;

% Turning pre and post-processing on
options = sdpsettings('sos.newton',1,'sos.congruence',1,'sos.numblkdg',1e-6);

% Create SOS model and run it
F = sos(p);
solvesos(F);
yalmipOutput = sdisplay(sosd(F));

% Create syms equivalent to YALMIP symbols based on var
if var == 2
    syms x;
    syms y;
elseif var == 3
    syms x;
    syms y;
    syms z;
end

symsExpression = 0;

% Converts and stores new sym expressions in new array
for i = 1:size(yalmipOutput, 1)
    tempExp = str2sym(yalmipOutput{i});
    symsExpression = symsExpression + tempExp^2;
end

% Printing expression
fprintf("Accurate result:\n")
symsExpression
fprintf("\n2 d.p result:\n")
vpa(symsExpression,2)

% 3D plotting on expression only if var = 2
if var == 2
    fsurf(symsExpression)
    title("SOS Plot")
    xlabel("x")
    ylabel("y")
    zlabel("z")
end
