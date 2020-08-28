% Constructing algorithmic approach to satisfy that V and -grad(V)f_dot(x)
% are both SOS.
% Code found: http://control.asu.edu/Classes/MAE598/598Lecture16.pdf
clc
clear all
close all

disp("Lyapunov Function Solver Utilising SOS");

x = sdpvar(2,1);
f = [-1*x(2) - 1.5*x(1)^2 - 0.5*x(1)^3 ; 3*x(1) - x(2)];

% % Prompt user for required data
% nVar = input('Enter number of variables in system: ');
% nEqn = input('Enter number of equations in system: ');
% fprintf("\n")
% 
% % Set up YALMIP symbols
% x = sdpvar(nVar,1);
% 
% % This structure contains each ODE per row
% f = [];
% disp("Enter equations with variables as x(1), x(2)..");
% disp("For example: -1*x(2) - 1.5*x(1)^2 - 0.5*x(1)^3 and 3*x(1) - x(2)");
% for i = 1 : nEqn
%     fprintf("(Eqn #%d) ",i);
%     f = [f;(input('Enter eqn: '))];
% end
% fprintf("\n")

% % Generates a polynomial with degree 4
% % V is polynomial
% % Vc stores coefficients of each term
% n = input('Enter degree polynomial to search for: ');
% [V, Vc] = polynomial(x,n);
% fprintf("\n")
% 
% % Setting constant term to 0
% F = [Vc(1) == 0];
% 
% % Generate boundary function for defining positive definiteness
% boundFun = 0;
% for i = 1 : nVar
%     boundFun = boundFun + x(i)^2;
% end
% 
% % This ensures V is positive definite
% zeta = input('Enter value for zeta: ');
% F = [F;sos(V-zeta*boundFun^2)];
% 
% % Calculates the gradient of the cost function
% gradV = jacobian(V,x);
% 
% % Creates sos instance for both V and -V_dot
% negGradVfDot = -1*gradV*f;
% F = [F;sos(negGradVfDot)];
% 
% % Calculates V s.t V and -V_dot are sos
% fprintf("\n\n")
% solvesos(F,[],[],[Vc]);
% 
% % Display V and negGradVfDot
% V = sdisplay(replace(V,Vc,value(Vc)));
% V = V{1}
% negGradVfDot = sdisplay(replace(negGradVfDot,Vc,value(Vc)));
% negGradVfDot = negGradVfDot{1}
% 
% % Plot V if it is plottable
% if (nVar <= 2)
%     if (input('Do you want to plot V and -grad(V)f_dot? (1 - Yes, 0 - No): '))
%         V = replace(V,'*','.*');
%         V = replace(V,'^','.^');
%         V = replace(V,'x(1)','x');
%         V = replace(V,'x(2)','y');
%         V = eval(['@(x,y)' V]);
%         subplot(2,1,1);
%         fsurf(V)
%         title('Proposed Lyapunov Function')
%         xlabel("x")
%         ylabel("y")
%         zlabel("V")
%         
%         negGradVfDot = replace(negGradVfDot,'*','.*');
%         negGradVfDot = replace(negGradVfDot,'^','.^');
%         negGradVfDot = replace(negGradVfDot,'x(1)','x');
%         negGradVfDot = replace(negGradVfDot,'x(2)','y');
%         negGradVfDot = eval(['@(x,y)' negGradVfDot]);
%         subplot(2,1,2);
%         fsurf(negGradVfDot)
%         title('Negative Grad Lyapunov Function Multiplied by F')
%         xlabel("x")
%         ylabel("y")
%         zlabel("-grad(V)f")
%     end
% end

V = '4.49643294175*x(1)^2+0.0779080142344*x(1)^3-1.3731453231*x(1)*x(2)+1.68597809038*x(2)^2+2.54800977834*x(1)^2*x(2)-0.249861069647*x(1)*x(2)^2+0.61717217279*x(2)^3+0.525785375548*x(1)^4-0.06905307894*x(1)^3*x(2)+0.499441472178*x(1)^2*x(2)^2+0.0901586549732*x(2)^4';
f = sdisplay(f);
Lyp_gui(f,V)

% if (input('Do you want to plot ROA? (1 - Yes, 0 - No): '))
%     f = char(sdisplay(f))
%     Lyp_gui(f,V)
% end
