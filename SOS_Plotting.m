clc
close all
clear all

% Creating mesh for 3D plotting
hold on
grid on
[x,y] = meshgrid(1:0.5:10,1:20);
p = 4*x.^4 + 4*(x.^3).*y - 7*(x.^2).*(y.^2) - 2*x.*(y.^3) + 10*y.^4;
sos = (2*x.*y + y.^2).^2 + (2*x.^2 + x.*y - 3*y.^2).^2;
sos_yalmip =(-1.96851860633*x.*y - 0.306566415906*x.^2 - 0.666178917329*y.^2).^2 ...
    + (1.94330599954*x.^2 + 0.741378798638*x.*y - 3.08501254135*y.^2).^2 ...
    + (0.35997058877*x.^2 - 0.122808814087*x.*y + 0.197239118354*y.^2).^2;
surf(x,y,sos, 'FaceColor', 'g');
surf(x,y,sos_yalmip, 'FaceColor', 'r');
legend("sos", "sos_yalmip")
title("Comparison of Perfect SOS Decomposition with Unrounded Yalmip Output Using")
xlabel("x")
ylabel("y")
zlabel("z")