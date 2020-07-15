% Testing Lyapunov function in MATLAB 
% Using jet engine example in slide 20 of Stanford slides
clc
clear all
close all 

%% Following methodology using https://matlabexamples.wordpress.com/tag/lyapunov-stability/
% as a reference.

% Given dx/dt = -y - (3/2)x^2 - (1/2)x^3
% Given dy/dt = 3x - y
% Finding the equilibium point (x,y) = (0,0) means we can construct A and Q
% as the following:
A = [0 3 ; -1 -1];
Q = eye(size(A));

X = lyap(A, Q);

% Find eigenvalues of output as this will determine stability
k = eig(X);

%% Deriving Lyapunov function for above system
% The problem we're trying to solve!!


