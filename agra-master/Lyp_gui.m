function Lyp_gui(f,V)
fprintf("Please re-enter the system questions and V.");
f
V
% Simple GUI demonstration
x=mpolyfun.singles(2);
f=[];
fprintf("(Eqn #1) ");
f = [f;(input('Enter eqn: '))];
fprintf("(Eqn #2) ");
f = [f;(input('Enter eqn: '))];

V = input('Enter V: ');

sos=agrasys(f,V);
sos.max_level();

sos_gui=agragui(sos);
sos_gui.set_simulation(30,0.05);
sos_gui.window();
end