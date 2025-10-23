%% MAIN CODE TO OUTPUT PLOTS

clear all
close all
clc

% output all plots in full screen
set(groot, 'defaultFigureWindowState', 'maximized');

global Temps N2hi N2so O2hi O2so yN2 yO2
yN2 = .79;
yO2 = .21;

data = readtable('polynomial calcs.xlsx');
Temps = table2array(data(:,"TempK"));
N2hi = table2array(data(:,"N2hi"));
N2so = table2array(data(:,"N2so"));
O2hi = table2array(data(:,"O2hi"));
O2so = table2array(data(:,"O2so"));

%% gather base case info
[nT1, nT2, Vdot1b] = phase1_basecase(0);

%% varying inlet temps
T = [35 65 85 105];
mdotf = [15981 14585 13518 12410];
RPM = [9752 9784 9881 9974];
PNET = zeros(1,4); 
mdotin = zeros(1,4);
mdotout = zeros(1,4);
nTH = zeros(1,4);
T4 = zeros(1,4);
T6 = zeros(1,4);
SFC = zeros(1,4);
HR = zeros(1,4);

for i = 1:4
    [PNET(i), mdotin(i), mdotout(i), nTH(i), T4(i), T6(i), SFC(i), HR(i)] = phase1_calcs(nT1, nT2,T(i), mdotf(i), Vdot1b, RPM(i));
end

% mass flow rate
figure
subplot(2,3,1)
plot(T, mdotin, '.-', MarkerSize = 20)
hold on
plot(T, mdotout, 'k.-', MarkerSize = 20)
xlabel('T1 [ ^{\circ}F ]')
ylabel('Mass Flow Rate [ lbm/hr ]')
title('Mass Flow Rate vs Inlet Temperature')
legend('Inlet','Outlet')
grid on

% process temp
subplot(2,3,2)
plot(T, T4, '.-', MarkerSize = 20)
hold on
plot(T, T6, 'k.-', MarkerSize = 20)
xlabel('T1 [ ^{\circ}F ]')
ylabel('T [ ^{\circ}F ]')
title('Process Temperature vs Inlet Temperature')
legend('Turbine Intlet','Engine Outlet')
grid on

% electrical power output
subplot(2,3,3)
plot(T, PNET, '.-', MarkerSize = 20)
xlabel('T1 [ ^{\circ}F ]')
ylabel('Electrical Power Output [ MW ]')
title('Power Outlet vs Inlet Temperature')
grid on

% thermal efficiency
subplot(2,3,4)
plot(T, nTH, '.-', MarkerSize = 20)
xlabel('T1 [ ^{\circ}F ]')
ylabel('Efficiency [ % ]')
title('Thermal Efficiency vs Inlet Temperature')
grid on

% specific fuel consumption
subplot(2,3,5)
plot(T, SFC, '.-', MarkerSize = 20)
xlabel('T1 [ ^{\circ}F ]')
ylabel('SFC [ lbm/kW-hr ]')
title('Specific Fuel Consumption vs Inlet Temperature')
grid on

% heat rate
subplot(2,3,6)
plot(T, HR, '.-', MarkerSize = 20)
xlabel('T1 [ ^{\circ}F ]')
ylabel('HR [ BTU/kW-hr ]')
title('Heat Rate vs Inlet Temperature')
grid on

%% varying fuel flow rate

T = 65;
percent = [.2 .4 .6 .8 1];
mdotf = 14585 * percent;
RPM = 9784;

PNET = zeros(1,5); 
mdotin = zeros(1,5);
mdotout = zeros(1,5);
nTH = zeros(1,5);
T4 = zeros(1,5);
T6 = zeros(1,5);
SFC = zeros(1,5);
HR = zeros(1,5);

for i = 1:5
    [PNET(i), mdotin(i), mdotout(i), nTH(i), T4(i), T6(i), SFC(i), HR(i)] = phase1_calcs(nT1, nT2,T, mdotf(i), Vdot1b, RPM);
end

% mass flow rate
figure
subplot(2,3,1)
plot(percent * 100, mdotin, '.-', MarkerSize = 20)
hold on
plot(percent * 100, mdotout, 'k.-', MarkerSize = 20)
xlabel('% Base Case Fuel Rate')
ylabel('Mass Flow Rate [ lbm/hr ]')
title('Mass Flow Rate vs Fuel Mass Flow Rate')
legend('Inlet','Outlet')
grid on

% process temp
subplot(2,3,2)
plot(percent * 100, T4, '.-', MarkerSize = 20)
hold on
plot(percent * 100, T6, 'k.-', MarkerSize = 20)
xlabel('% Base Case Fuel Rate')
ylabel('T4 [ ^{\circ}F ]')
title('Process Temperature vs Fuel Mass Flow Rate')
legend('Turbine Intlet','Engine Outlet')
grid on

% electrical power output
subplot(2,3,3)
plot(percent * 100, PNET, '.-', MarkerSize = 20)
xlabel('% Base Case Fuel Rate')
ylabel('Electrical Power Output [ MW ]')
title('Power Outlet vs Fuel Mass Flow Rate')
grid on

% thermal efficiency
subplot(2,3,4)
plot(percent * 100, nTH, '.-', MarkerSize = 20)
xlabel('% Base Case Fuel Rate')
ylabel('Efficiency [ % ]')
title('Thermal Efficiency vs Fuel Mass Flow Rate')
grid on

% specific fuel consumption
subplot(2,3,5)
plot(percent * 100, SFC, '.-', MarkerSize = 20)
xlabel('% Base Case Fuel Rate')
ylabel('SFC [ lbm/kW-hr ]')
title('Specific Fuel Consumption vs Fuel Mass Flow Rate')
grid on

% heat rate
subplot(2,3,6)
plot(percent * 100, HR, '.-', MarkerSize = 20)
xlabel('% Base Case Fuel Rate')
ylabel('HR [ BTU/kW-hr ]')
title('Heat Rate vs Fuel Mass Flow Rate')
grid on


% set back to normal graph plotting
set(groot, 'defaultFigureWindowState', 'normal');