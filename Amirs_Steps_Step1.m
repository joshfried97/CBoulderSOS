% Constructing algorithmic approach to satisfy that V and -grad(V)f_dot(x)
% are both SOS.

clc
clear all
close all

% % Ask user for number of input var
% var = input('Enter number of variables (2 or 3) in p: ');
% 
% % Ensuring correct input set
% while (var ~= 2) && (var ~= 3)
%     disp('Please use valid input')
%     var = input('Enter number of variables (2 or 3) in p: ');
% end;
% 
% % Define # of symbols based on var
% if var == 2
%     syms x;
%     syms y;
% elseif var == 3
%     syms x;
%     syms y;
%     syms z;
% end

% User inputs p ** For now it's fixed **
%p = input('Enter p without coefficents: ')
syms x;
syms y;

% Defining initial coefficient values
a = 0.01;
b = 0.01;
c = 0.01;
d = 0.01;
e = 0.01;

% Resetting solved flag
solved = 0;

% Main loops
% Stops either when a solution is found or max coeff is reached
disp('Main Loop Running')
cnt = 0;
while (~solved)||(a <= 2)
    % Determines which coefficient to increase
    switch(mod(cnt,5))
        case 0
            a = a + 0.01;
        case 1
            b = b + 0.01;
        case 2
            c = c + 0.01;
        case 3
            d = d + 0.01;
        case 4
            e = e + 0.01;
    end
    
    fun = a*x^4 + b*x^3*y - c*x^2*y^2 - d*x*y^3 + e*y^4
    gradFun = gradient(fun);
    
    % Determine if there is SOS for both the function and its grad
    funBool = sosYalmip(fun);
    gradFunBool1 = sosYalmip(gradFun(1));
    gradFunBool2 = sosYalmip(gradFun(2));
    
    solved = funBool & gradFunBool1 & gradFunBool2;
    cnt = cnt + 1;
end

%% Function Definitions
function [solved_flag] = sosYalmip(fun)
fprintf("Solving SOS for:\n");
fun
yalmip('clear');
x = sdpvar(1,1);
y = sdpvar(1,1);

% Converts symbolic expression to YALMIP polynomial
p = eval(char(fun));
F = sos(p); 
solvesos(F);

if isempty(sosd(F))
    fprintf("\nNo SOS exists, stopping script run.\n");
    solved_flag = false;
else
    solved_flag = true;
end
fprintf("\n\n");
end