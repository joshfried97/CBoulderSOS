% Constructing algorithmic approach to satisfy that V and -V_dot
% are both SOS.
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
disp("For example: -1*x(2) - 1.5*x(1)^2 - 0.5*x(1)^3 and 3*x(1) - x(2)");
for i = 1 : nEqn
    fprintf("(Eqn #%d) ",i);
    f = [f;(input('Enter eqn: '))];
end
fprintf("\n")

% Starting degree of V
n = input('Enter positive, non-zero starting value for degree of V: ');

% Ensuring valid value for n is entered
while n <= 0
    disp("Invalid value for n. Value must be positive and non-zero.")
    n = input('Enter starting value for degree of V: ');
end

% MATLAB equivalent of do-while loop
while 1
  
    % Run solver
    fprintf("Searching for V with degree = %d...\n",n);
    [V,neg_V_dot] = sosFun(f,x,n);
    
    % If the solver returns nothing then it's infeasible
    if V == '0'
        disp("")
        disp("**** Infeasible solution -> Searching for higher order V ****")
        disp("")
    else
        % If the solver doesn't return nothing then it's found something
        disp("")
        disp("**** Solver returned expression for V ****")
        disp("Do you wish to do another run? ")
        if (input("Recommended if Problem and Solution status show UNKNOWN (1 - Yes, 0 - No):"))
            % Increase the degree of V by 2
            n = n + 2;
            
            % Run solver
            fprintf("Searching for V with degree = %d...\n",n);
            [V,neg_V_dot] = sosFun(f,x,n);
        end
        break;
    end
        
    % Increase the degree of V by 2
    n = n + 2;
end

% Utilising Agra toolbox for plotting ROA
if (input('Do you want to plot ROA? (1 - Yes, 0 - No): '))
    f = sdisplay(f);
    Lyp_gui(f,V,nVar,nEqn)
end

% Plot V and -V_dot if it is plottable
if (nVar <= 2)
    if (input('Do you want to plot V and -V_dot? (1 - Yes, 0 - No): '))
       plotFun(V, neg_V_dot)
    end
end

%% Function Declarations
function plotFun(V, neg_V_dot)
V = replace(V,'*','.*');
V = replace(V,'^','.^');
V = replace(V,'x(1)','x');
V = replace(V,'x(2)','y');
V = eval(['@(x,y)' V]);
subplot(2,1,1);
fsurf(V)
title('Proposed Lyapunov Function')
xlabel("x")
ylabel("y")
zlabel("V")

neg_V_dot = replace(neg_V_dot,'*','.*');
neg_V_dot = replace(neg_V_dot,'^','.^');
neg_V_dot = replace(neg_V_dot,'x(1)','x');
neg_V_dot = replace(neg_V_dot,'x(2)','y');
neg_V_dot = eval(['@(x,y)' neg_V_dot]);
subplot(2,1,2);
fsurf(neg_V_dot)
title('Negative Grad Lyapunov Function Multiplied by F')
xlabel("x")
ylabel("y")
zlabel("-grad(V)f")
end

function [V,neg_V_dot] = sosFun(f,x,n)
% Generates a polynomial with degree n
% V is polynomial
% Vc stores coefficients of each term
[V, Vc] = polynomial(x,n);

% Generate boundary function for defining positive definiteness
boundFun = sum(x.^2);
zeta = 0.00001;

% Calculates the gradient of the cost function
gradV = jacobian(V,x);
neg_V_dot = -1*gradV*f;

% Creates sos instance for both V and -V_dot
F = [Vc(1) == 0;sos(V-zeta*boundFun^2);sos(neg_V_dot)];

% Turning on pre & post processing to reduce computational load
options = sdpsettings('sos.newton',1,'sos.congruence',1);

% Calculates V s.t V and -V_dot are sos
solvesos([F],[],options,[Vc]);

% Cleans expression up by removing coefficients < 1e-6
V = replace(V,Vc,value(Vc));
V = clean(V, 1e-6);
neg_V_dot = replace(neg_V_dot,Vc,value(Vc));
neg_V_dot = clean(neg_V_dot, 1e-6);

% Prepare expressions for displaying
V = sdisplay(V);
V = V{1}
neg_V_dot = sdisplay(replace(neg_V_dot,Vc,value(Vc)));
neg_V_dot = neg_V_dot{1}
end
