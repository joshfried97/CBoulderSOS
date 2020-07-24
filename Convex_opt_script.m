clc
close all
clear all

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

%% Trying Multidimensional Local Min Search (NA pg 28)
syms x;
syms y;

J = 4*x^4 + 4*(x^3)*y - 7*(x^2)*(y^2) - 2*x*(y^3) + 10*y^4;

% Setting threshold (TOL)
TOL = 1e-5;

% Setting upper and lower bounds of search
upperX = 5;
lowerX = -5;

% Define recip Golden ratio
tau = 2/(1+sqrt(5));

% Search loop
itrCnt = 0;
