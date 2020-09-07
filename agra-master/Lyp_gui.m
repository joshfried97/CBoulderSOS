function Lyp_gui(f,V,nVar,nEqn)
fprintf("Please re-enter the system questions and V.");
f
V

x=mpolyfun.singles(nVar);
f=[];
for i = 1 : nEqn
    fprintf("(Eqn #%d) ",i);
    f = [f;(input('Enter eqn: '))];
end

V = input('Enter V: ');

sos=agrasys(f,V);
sos.max_level();

sos_gui=agragui(sos);
sos_gui.set_simulation(30,0.05);
sos_gui.window();
end