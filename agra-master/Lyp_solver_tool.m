% Constructing algorithmic approach to satisfy that V and -V_dot
% are both SOS.
clc
clear all
close all
fopen('trajData.txt','w');
fopen('roaData.txt','w');
fclose('all');

disp("Lyapunov Function Solver Utilising SOS");

% Prompt user for required data
nVar = input('Enter number of variables in system: ');
nEqn = input('Enter number of equations in system: ');
fprintf("\n")

% Set up YALMIP symbols
x = sdpvar(nVar,1);

% This structure contains each ODE per row
f = [];
disp("Enter equations with variables as x(1), x(2)..");
disp("For example: -1*x(2) - 1.5*x(1)^2 - 0.5*x(1)^3 and 3*x(1) - x(2)");
for i = 1 : nEqn
    fprintf("(Eqn #%d) ",i);
    f = [f;(input('Enter eqn: '))];
end
fprintf("\n")

% Starting degree of V
n = input('Enter positive, non-zero starting value for degree of V: ');

% Ensuring valid value for n is entered
while n <= 0
    disp("Invalid value for n. Value must be positive and non-zero.")
    n = input('Enter starting value for degree of V: ');
end
fprintf("\n")

% Ask user for number of constraints
conNum = input('Enter number of constraints you wish to enter: ');

% Process constraints from user input
% ** Potential for future development **
constraints = [];
if conNum > 0
    disp("Enter constraints for the system.");
    disp("For example: sum(x) <= 10, x(1) == 0, 0.5 <= x(2) <= 1.5");
    for i = 1 : conNum
        fprintf("(Con #%d) ",i);
        constraints = [constraints;(input('Enter constraint: '))];
    end
end
fprintf("\n")

% Main loop
while 1
    
    % Run solver
    fprintf("Searching for V with degree = %d...\n",n);
    [V,neg_V_dot] = sosFun(f,x,n,constraints);
    
    % If the solver returns nothing then it's infeasible
    if V == '0'
        disp("")
        disp("**** Infeasible solution -> Searching for higher order V ****")
        disp("")
    else
        % If the solver doesn't return nothing then it's found something
        disp("")
        disp("**** Solver returned expression for V ****")
        disp("Do you wish to do another run? ")
        if (input("Recommended if Problem and Solution status show UNKNOWN (1 - Yes, 0 - No): "))
            % Increase the degree of V by 2
            n = n + 2;
            
            % Run solver
            fprintf("Searching for V with degree = %d...\n",n);
            [V,neg_V_dot] = sosFun(f,x,n);
        end
        break;
    end
    
    % Increase the degree of V by 2
    n = n + 2;
end
fprintf("\n")

% Utilising Agra toolbox for plotting ROA
if (input('Do you want to plot ROA? (1 - Yes, 0 - No): '))
    f = sdisplay(f);
    Lyp_gui(f,V,nVar,nEqn)
end
fprintf("\n")

% Plot V and -V_dot if it is plottable
% ** Potential for future expansion **
if (nVar <= 2)
    if (input('Do you want to plot V and -V_dot? (1 - Yes, 0 - No): '))
        plotFun(V, neg_V_dot)
    end
end

%% Function Declarations
function [V,neg_V_dot] = sosFun(f,x,n,constraints)
% Generates a polynomial with degree n
% V is polynomial
% Vc stores coefficients of each term
[V, Vc] = polynomial(x,n);

% Generate boundary function for defining positive definiteness
boundFun = sum(x.^2);
zeta = 0.00001;

% Calculates the gradient of the cost function
gradV = jacobian(V,x);
neg_V_dot = -1*gradV*f;

% Creates sos instance for both V and -V_dot
F = [constraints;Vc(1) == 0;sos(V-zeta*boundFun^2);sos(neg_V_dot)];

% Turning on pre-processing to reduce computational load
options = sdpsettings('sos.newton',1,'sos.congruence',1);

% Calculates V s.t V and -V_dot are sos
solvesos([F],[],options,[Vc]);

% Cleans expression up by removing coefficients < 1e-6
V = replace(V,Vc,value(Vc));
V = clean(V, 1e-6);
neg_V_dot = replace(neg_V_dot,Vc,value(Vc));
neg_V_dot = clean(neg_V_dot, 1e-6);

% Prepare expressions for displaying
V = sdisplay(V);
V = V{1}
neg_V_dot = sdisplay(replace(neg_V_dot,Vc,value(Vc)));
neg_V_dot = neg_V_dot{1};
end

function Lyp_gui(f_in,V_in,nVar,nEqn)
delete trajData.txt
delete roaData.txt
delete mDimRoaData.txt

x=mpolyfun.singles(nVar);
f =[];
for i = 1 : nEqn
    % Converts f into form that AGRA can read
    f = [f;eval(f_in{i})];
end

% Converts V into form that AGRA can read
V = eval(V_in);

sos=agrasys(f,V);
sos.max_level();

sos_gui=agragui(sos);
sos_gui.set_simulation(30,0.05);

% Calculate all var pairings
varCombo = combnk(1:nVar,2);

% Storing ROA for each var pair
if (input('Do you want to store ROA for each var pair? (1 - Yes, 0 - No): '))
    for m = 1 : size(varCombo,1)
        fprintf("Calculating ROA for variable pair #%d out of %d\n", m, size(varCombo,1));
        i = varCombo(m,1);
        j = varCombo(m,2);
        sos_gui.set_plane(i,j,[-5 5],[-5 5]);
        
        fprintf("ROA for x%d and x%d\n", i, j);
        sos_gui.store_mdim_ROA()
    end
end

% Gives usr choice of which 2 variables to plot if sys has > 2
if nVar > 2
    i = input('Enter number of 1st var (i.e 1 for x1): ');
    j = input('Enter 2nd var: ');
    sos_gui.set_plane(i,j,[-5 5],[-5 5]);
end

% Starts up the GUI window
sos_gui.window();
end

function plotFun(V, neg_V_dot)
V = replace(V,'*','.*');
V = replace(V,'^','.^');
V = replace(V,'x(1)','x');
V = replace(V,'x(2)','y');
V = eval(['@(x,y)' V]);
%subplot(2,1,1);
fsurf(V)
hold on

% Adds trajectories onto 3D plot
[x,y,trajNum] = trajFinder();
traj_plot = feval(V,x,y);
for i = 1:trajNum
    plot3(x(i,:),y(i,:),traj_plot(i,:),'-*');
end
hold on

% Adds ROA onto 3D plot
[map, xticks, yticks] = roaFinder();
roa = [];
m=length(yticks);
n=length(xticks);
for i=2:m-1
    for j=2:n-1
        if map(i,j)
            plot3(xticks(j),yticks(i),feval(V,xticks(j),yticks(i)),...
                'o', 'MarkerSize',8, 'Color', 'g', 'LineWidth', 2);
        end
    end
end

title('Proposed Lyapunov Function (V)')
xlabel("x")
ylabel("y")
zlabel("V")

% ** Uncomment if you want to see V_dot
% neg_V_dot = replace(neg_V_dot,'*','.*');
% neg_V_dot = replace(neg_V_dot,'^','.^');
% neg_V_dot = replace(neg_V_dot,'x(1)','x');
% neg_V_dot = replace(neg_V_dot,'x(2)','y');
% neg_V_dot = eval(['@(x,y)' neg_V_dot]);
% subplot(2,1,2);
% fsurf(neg_V_dot)
% title('Vdot')
% xlabel("x")
% ylabel("y")
% zlabel("Vdot")
end

% Retrieves x and y coordinates of drawn trajectories in order to plot onto
% surface plot of V
function [x,y,trajNum] = trajFinder()
fileID = fopen('trajData.txt', 'r');
formatSpec = '%f';
data = fscanf(fileID, formatSpec);

% Calc # trajectories
trajNum = sum(data(:) == 100);

% Calc max traj size
Xindexes = find(data == 100);
Yindexes = find(data == 101);
indices = sort([Xindexes; Yindexes]);
indexDist = diff(indices);
maxDist = max(indexDist);

% Storage for x & y vectors
x = zeros(trajNum, maxDist);
y = zeros(trajNum, maxDist);

x_vec = [];
y_vec = [];
x_flag = 1;
traj = 1;

for d = 1:length(data)
    val = data(d);
    
    if x_flag
        if val ~= 100
            x_vec = [x_vec;val];
        else
            x(traj,1:size(x_vec,1)) = x_vec;
            x_vec = [];
            x_flag = 0;
        end
    else
        if val ~= 101
            y_vec = [y_vec;val];
        else
            y(traj,1:size(y_vec,1)) = y_vec;
            y_vec = [];
            x_flag = 1;
            traj = traj + 1;
        end
    end
end
end

function [map, xticks, yticks] = roaFinder()
fileID = fopen('roaData.txt', 'r');
formatSpec = '%f';
data = fscanf(fileID, formatSpec);

% 1st 4 rows contain # elements in all structures
mapRow = data(1);
mapCol = data(2);
xlen = data(3);
ylen = data(4);

% Storing index points for each different data structure
mapEnd = mapRow*mapCol + 4;
xBegin = mapEnd + 1;
xEnd = xBegin + xlen - 1;
yBegin = xEnd + 1;
yEnd = yBegin + ylen - 1;

% Creating structures to store read data
map = data(5:mapEnd);
xticks = data(xBegin:xEnd);
yticks = data(yBegin:yEnd);

map = reshape(map, [mapRow, mapCol]);
end
