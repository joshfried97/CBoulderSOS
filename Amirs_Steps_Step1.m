% Constructing algorithmic approach to satisfy that V and -grad(V)f_dot(x)
% are both SOS.
clc
clear all
close all

sdpvar x y a b c d e
fun = a*x^4 + b*x^3*y - c*x^2*y^2 - d*x*y^3 + e*y^4
gradFun = jacobian(fun,[x y]);
%options = sdpsettings('debug',1);
%F = [sos(fun), a == 1]
F = [sos(fun),sos(gradFun), a == 1]

solvesos(F,[],[],[a b c d e])

value(a)
value(b)
value(c)
value(d)
value(e)

h = sosd(F)
sdisplay(h)