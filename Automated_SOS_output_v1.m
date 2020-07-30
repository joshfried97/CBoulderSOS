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
% 4*x^4 + 4*(x^3)*y - 7*(x^2)*(y^2) - 2*x*(y^3) + 10*y^4;
% 4.5819*x^2 - 1.5786*x*y + 1.7834*(y^2) - 0.12739*(x^3) + 2.5189*(x^2)*y - 0.34069*x*(y^2) + 0.61188*(y^3) + 0.47537*(x^4) - 0.052424*(x^3)*y + 0.44289*(x^2)*(y^2) + 0.0000018868*x*(y^3) + 0.090723*y^4

% Turning pre and post-processing on
options = sdpsettings('sos.newton',1,'sos.congruence',1,'sos.numblkdg',1e-6);

% Create SOS model and run it
F = sos(p); 
solvesos(F);

if isempty(sosd(F))
    fprintf("\nNo SOS exists, stopping script run.\n");
    return;
else
    yalmipOutput = sdisplay(sosd(F));
end

% Create syms equivalent to YALMIP symbols based on var
if var == 2
    syms x;
    syms y;
    vars = {[x,y]};
elseif var == 3
    syms x;
    syms y;
    syms z;
    vars = {[x,y,z]};
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
symsExpression2dp = vpa(symsExpression,2)


%% Trying Multidimensional Local Min Search Using MATLAB's fminsearch
% Using https://uk.mathworks.com/help/optim/ug/banana-function-minimization.html
fun = matlabFunction(symsExpression2dp, 'vars', vars) % Converts symbolic function to function handle
options = optimset('Display','iter', 'plotFcns','optimplotfval','TolX',1e-3); % Setting display options
x0 = randi(5,1,2) % Starting coords of search
[x,fval,eflag,output] = fminsearch(fun,x0,options)
title 'Rosenbrock solution via fminsearch'

% Plot results if there are only 2 inputs
if var == 2
    figure
    newfun = @(varargin)fun([varargin{:}]); %This conversion ensures we can use fsurf to plot it
    fsurf(newfun)
    hold on
    title('Cost Function with start point and solution')
    xlabel("x")
    ylabel("y")
    zlabel("Cost function")
    plot3(x0(1),x0(2),fun([x0(1),x0(2)]),'ko','MarkerSize',15,'LineWidth',2);
    text(x0(1),x0(2),fun([x0(1),x0(2)]),'   Start','Color',[0 0 0]);
    plot3(x(1),x(2),fun([x(1),x(2)]),'ko','MarkerSize',15,'LineWidth',2);
    text(x(1),x(2),fun([x(1),x(2)]),'   Solution','Color',[0 0 0]);
    drawnow
end
