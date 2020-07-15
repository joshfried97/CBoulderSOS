clc
clear all
close all

%% Examples of Functions which don't have a SOS decomposition
x = sdpvar(1,1); % defines Yalmips symbolic decision vars
y = sdpvar(1,1);

% Using the Motzkin Polynomial as an example as it is non-negative but
% isn't SOS
p_mot = x^4*(y^2) + x^2*(y^4) - 3*x^2*(y^2) + 1;

% Attempts decomp
F_mot = sos(p_mot);
solvesos(F_mot)
h_mot = sosd(F_mot);

fprintf("Calculation of p - h'*h to determine accuracy of SOS decomp:\n\n")

fprintf("Motzkin Polynomial:\n")
p_mot-h_mot'*h_mot
