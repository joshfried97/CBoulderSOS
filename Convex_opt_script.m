clc
close all

%% Golden section line search as per NA notes pg 27
% syms x;
% J = 4*x^4 + 4*x^3 - 7*x^2 - 2*x + 10;
% 
% % Setting threshold (TOL)
% TOL = 1e-5;
% 
% % Setting upper and lower bounds of search
% upperX = 5;
% lowerX = -5;
% 
% % Define recip Golden ratio
% tau = 2/(1+sqrt(5));
% 
% % Search loop
% itrCnt = 0;
% 
% while (upperX - lowerX) > TOL
%     itrCnt = itrCnt + 1;
%     xDiff = upperX - lowerX;
%     upperTest = lowerX + tau * xDiff;
%     lowerTest = lowerX + (1 - tau) * xDiff;
%     
%     % Evaluting symbolic expressions
%     x = upperTest;
%     JUpper = subs(J);
%     x = lowerTest;
%     JLower = subs(J);
%     
%     if JUpper > JLower
%         upperX = upperTest;
%     else
%         lowerX = lowerTest;
%     end
% end
% 
% itrCnt
% vpa(JUpper,5)
% 
% % Plot Cost function
% figure
% hold on
% fplot(J)
% title('Cost function')
% xlabel('x')
% ylabel('J')
% plot(upperTest,JUpper, 'r*')

%% Trying Multidimensional Local Min Search Using MATLAB's fminsearch
% Using https://uk.mathworks.com/help/optim/ug/banana-function-minimization.html
fun = @(x)(4*x(1)^4 + 4*(x(1)^3)*x(2) - 7*(x(1)^2)*(x(2)^2) - 2*x(1)*(x(2)^3) + 10*x(2)^4);
options = optimset('Display','iter', 'plotFcns','optimplotfval','TolX',1e-3); % Setting display options
x0 = randi(5,1,2) % Starting coords of search
[x,fval,eflag,output] = fminsearch(fun,x0,options)
title 'Rosenbrock solution via fminsearch'

% Plot Results
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



