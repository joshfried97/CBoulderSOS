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
%A = [0 3 ; -1 -1];
%Q = eye(size(A));

%X = lyap(A, Q);

% Find eigenvalues of output as this will determine stability
%k = eig(X);

%% Deriving Lyapunov function for above system
% The problem we're trying to solve!!
% Found this example in: https://pdf.sciencedirectassets.com/314898/1-s2.0-S1474667016X60624/1-s2.0-S1474667016391376/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEC4aCXVzLWVhc3QtMSJHMEUCIQDbSjPeQ1Cm7cbZza%2FueLShyz40hbJAumXPiI6P6r3MuAIgZc4np%2BNpH5hUAoaIsSR5%2F%2BD8SGUL1dP1aO%2BDSONYI14qvQMI1%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARADGgwwNTkwMDM1NDY4NjUiDC4l3wFRMaN1Vt3CICqRAx25tOXJetDLHofxOVjXO1AvY%2BMbldKxN22yYpZ8B09q6UDyIvAYuqb8CLSPAhWXTUTaCGYzWGpr%2FIEYG%2F1AP3BoiffOZF%2BdRnMZhMP6v8rv5jVu2ku4%2BKvtihSINrLMY0KMbNn90%2F6%2FdEhsA5UPQFa8EY%2B%2Bzv4KGlzMAS9wOSAOwyLkbDGdzcWU0bVAz5eJLntfLwWZ9ebx0QlNPvQfD9abSnyMVVsycDrc7EZunsacsRBIRI6uLPEbC8wUu6T8LcO3fQa5TySJ0V7c%2BEqqbT2iKpKL5rWw6LRP5dsW56AeXcpGyqH9uK42r%2F1RH4i2FNmbnlWpFEy5DGy0JABcY0mOsVxHGFEA3uzcjIzKDl6ZVG8m4uCapVdGW%2BjYSSJH9WD7A%2Bx9wOrNyTt4yoczEDYuAxPaGFRbuUNA96tQK0p%2FtzeZ2559nvFa1Nifu8gn2UcZ3DcsXB9hrP0ta607VMAcLnPegktBAzYxfA3cV2aKvx98NK9%2FBgF%2FGk6RQaigEr2VkBp7U6cgPwNnGoUw2UvoMJ7WxvgFOusBDKOaWlEynBImmj12d1CN4F0%2BRzn4DgFguA4OdHap4HtEo06ct4A3j39fG1lFbudj2yhyY9FPS3gVRmr%2F%2BN2MpzhKkYWKXRGidtw5RuhMfgYV7lrqR0096xDrtvmlFLC7XgZq6mZlMqz19%2FP1Q%2BijE485TU6yH6DLLh12quTC6Tt0EUMUiicLXH%2B13ulGSe2yRKVv1KFmIpBFv4qWSdvYKpeS0GDNRB7dWrBq3%2F2lvtyliBoeKLLYok%2Fr%2FM05nbGCngwzoQ6t0TxxCJQMK0kqZF3HWv2BwH0Gw%2BlV%2BmUZq1LXZ4t0I%2FPyW%2Fbb2Q%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20200717T150040Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYTTCTEGML%2F20200717%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=a981913755c0e7a0c92347f8265052ad4736e29c7701d29b2c495e74ac23c820&hash=814ab030a2ef695968e867f0318d9d7bc0ca7c54acb42254ffad48df7a5fce06&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S1474667016391376&tid=spdf-57efffa6-4719-4f9d-9f20-b383cb7b6756&sid=1247d65b15825941a02927e592cdf712c7f0gxrqb&type=client
% It is showing that for all w in [3,5], this non-linear system is stable:
% x_1_dot = (-3/2)x_1^3-(1/2)x_1^2 - x_2
% x_2_dot = 6x_1 - wx_2

sdpvar x1 x2 w
f = [-1.5*x1^2-0.5*x1^3-x2; 6*x1-w*x2];
x = [x1;x2];
[V,c] = polynomial(x,4);
dVdt = jacobian(V,x)*f;
r = x'*x;

C = [uncertain(w),3<=w<=5];
C = [C,sos(V-r),sos(-dVdt-r)];
solvesdp(C,[],[],c);


