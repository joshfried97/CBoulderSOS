function Lyp_gui(f_in,V_in,nVar,nEqn)
delete trajData.txt

x=mpolyfun.singles(nVar);
f =[];
for i = 1 : nEqn
    f = [f;eval(f_in{i})];
end

V = eval(V_in);

sos=agrasys(f,V);
sos.max_level();

sos_gui=agragui(sos);
sos_gui.set_simulation(30,0.05);

if nVar > 2
    answer = inputdlg({'Enter number of 1st var (i.e 1 for x1):','Enter 2nd var:'}, 'Plotting Variables', [1 50]);
    i = str2num(answer{1});
    j = str2num(answer{2});
    sos_gui.set_plane(i,j,[-5 5],[-5 5]);
end

sos_gui.window();
end