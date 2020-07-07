% Running through function calls in SOSTOOL Book
clear all 
close all
clc

syms x y;

% Construct p(x,y)
p = 2*x^2 + 3*x*y + 4*y^4;

% Differentiate p wrt x
dpdx = diff(p,x);

% Initiate SOSTOOL function
Program1 = sosprogram([x;y]);

% Declaring polynomial var
[Program1, v] = sospolyvar(Program1, [x^2; x*y; y^2]);
v

% Creating vector of monomials
vec = monomials([x;y], [1 2 3]);

% Declaring an SOS var
%[Program1, p] = sossosvar(Program1, [x;y])
