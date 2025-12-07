%% MAIN CODE TO OUTPUT PLOTS PHASE 2

clear all
close all
clc

% output all plots in full screen
% set(groot, 'defaultFigureWindowState', 'maximized');

global Temps N2hi N2so O2hi O2so yN2 yO2 Temp2 press
yN2 = .79;
yO2 = .21;

data = readtable('polynomial calcs.xlsx');
Temps = table2array(data(:,"TempK"));
N2hi = table2array(data(:,"N2hi"));
N2so = table2array(data(:,"N2so"));
O2hi = table2array(data(:,"O2hi"));
O2so = table2array(data(:,"O2so"));

data2 = readtable('pressuretemps.xlsx');
Temp2 = table2array(data2(:,"TempK"));
press = table2array(data2(:,"PresskPa"));

data3 = readtable('measured data.xlsx');
InTemp = table2array(data3(:,"Inlet_Temperature"));
POUT = table2array(data3(:,"Power_Output_MW"));
T3 = table2array(data3(:,"T3"));
T48 = table2array(data3(:,"T48"));
T6 = table2array(data3(:,"T6"));


%% gather base case phase 1 info
[nT1, nT2, Vdot1b] = phase1_basecase(0);

%% base case phase 2
[PNET, mdotin, mdotout, nTH, Tturb, Teng, SFC, HR, hMain] = phase2_calcs(nT1, nT2, 65, 14585, Vdot1b, 9784, 1, 0, 0);

%% varying inlet temps phase 1
T_1 = [35 65 85 105];
mdotf_1 = [15981 14585 13518 12410];
RPM = [9752 9784 9881 9974];

PNET_1 = zeros(1,4); 
mdotin_1 = zeros(1,4);
mdotout_1 = zeros(1,4);
nTH_1 = zeros(1,4);
T4_1 = zeros(1,4);
T6_1 = zeros(1,4);
SFC_1 = zeros(1,4);
HR_1 = zeros(1,4);

for i = 1:4
    [PNET_1(i), mdotin_1(i), mdotout_1(i), nTH_1(i), T4_1(i), T6_1(i), SFC_1(i), HR_1(i)] = phase1_calcs(nT1, nT2, T_1(i), mdotf_1(i), Vdot1b, RPM(i),0);
end

%% varying inlet temps phase 2
T_2 = [35 65 85 105];
mdotf_2 = [15981 14585 13518 12410];
RPM = [9752 9784 9881 9974];

PNET_2 = zeros(1,4); 
mdotin_2 = zeros(1,4);
mdotout_2 = zeros(1,4);
nTH_2 = zeros(1,4);
T25_2 = zeros(1,4);
T3_2 = zeros(1,4);
T4_2 = zeros(1,4);
T48_2 = zeros(1,4);
T6_2 = zeros(1,4);
SFC_2 = zeros(1,4);
HR_2 = zeros(1,4);
ER_2 = zeros(1,4);
TWR_2 = zeros(1,4);

for i = 1:4
    [PNET_2(i), mdotin_2(i), mdotout_2(i), nTH_2(i), T25_2(i), T3_2(i), T4_2(i), T48_2(i), T6_2(i), SFC_2(i), HR_2(i), ER_2(i), TWR_2(i)] = phase2_calcs(nT1, nT2, T_2(i), mdotf_2(i), Vdot1b, RPM(i), 0, 0, 0);
end

%% varying % mass flow rate

T = 65;
percent = [.2 .4 .6 .8 1];
mdotf = 14585 * percent;
RPM = 9784;

PNET_m = zeros(1,5); 
mdotin_m = zeros(1,5);
mdotout_m = zeros(1,5);
nTH_m = zeros(1,5);
T25_m = zeros(1,4);
T3_m = zeros(1,4);
T4_m = zeros(1,4);
T48_m = zeros(1,4);
T6_m = zeros(1,4);
SFC_m = zeros(1,5);
HR_m = zeros(1,5);
ER_m = zeros(1,4);
TWR_m = zeros(1,4);

% figure('Name','Combined T–S Diagrams','Color','w');
% ax = gca;
% hold(ax, 'on');
% 
% colors = lines(5);
% h = gobjects(1,5); % handles for legend entries
% 
% 
for i = 1:5
    [PNET_m(i), mdotin_m(i), mdotout_m(i), nTH_m(i), T25_m(i), T3_m(i), T4_m(i), T48_m(i), T6_m(i), SFC_m(i), HR_m(i), ER_m(i), TWR_m(i)] = phase2_calcs(nT1, nT2, T, mdotf(i), Vdot1b, RPM, 0, 0, 0);
end
% 
% legend(ax, h, 'Location','best');
% xlabel(ax, 'Specific Entropy s (kJ/kg·K)');
% ylabel(ax, 'Temperature T (K)');
% title(ax, 'Combined Gas Turbine T–S Diagrams');
% grid(ax, 'on');
% hold(ax, 'off');

%% varying inlet temps phase 2 EVAP
T_evap = [50 65 85 105];
mdotf_evap = [15981 14585 13518 12410];
RPM = [9752 9784 9881 9974];

PNET_evap = zeros(1,4); 
mdotin_evap = zeros(1,4);
mdotout_evap = zeros(1,4);
nTH_evap = zeros(1,4);
T25_evap = zeros(1,4);
T3_evap = zeros(1,4);
T4_evap = zeros(1,4);
T48_evap = zeros(1,4);
T6_evap = zeros(1,4);

for i = 1:4
    [PNET_evap(i), mdotin_evap(i), mdotout_evap(i), nTH_evap(i), T25_evap(i), T3_evap(i), T4_evap(i), T48_evap(i), T6_evap(i)] = phase2_calcs(nT1, nT2, T_evap(i), mdotf_evap(i), Vdot1b, RPM(i), 0, 0, 1);
end

%% varying inlet temps phase 2 NO EVAP
T_no = [50 65 85 105];
mdotf_no = [15981 14585 13518 12410];
RPM = [9752 9784 9881 9974];

PNET_no = zeros(1,4); 
mdotin_no = zeros(1,4);
mdotout_no = zeros(1,4);
nTH_no = zeros(1,4);
T25_no = zeros(1,4);
T3_no = zeros(1,4);
T4_no = zeros(1,4);
T48_no = zeros(1,4);
T6_no = zeros(1,4);

for i = 1:4
    [PNET_no(i), mdotin_no(i), mdotout_no(i), nTH_no(i), T25_no(i), T3_no(i), T4_no(i), T48_no(i), T6_no(i)] = phase2_calcs(nT1, nT2, T_no(i), mdotf_no(i), Vdot1b, RPM(i), 0, 0, 0);
end

%% Plots

% Plot vs To - Generator output Wdotgen for 1 and 2 along with measured values (MW)
figure
plot(T_1, PNET_1, '.-', MarkerSize = 20)
hold on
plot(T_2, PNET_2, '.-', MarkerSize = 20)
plot(InTemp, POUT, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Generator Output [MW]')
ylim([0 40])
legend('Phase 1','Phase 2','Measured Values')
title('Generator Output Comparison')
grid on


%% Plot vs To - Inlet mass flow rate and fuel mass flow rate for 1 and 2, two y axis (lbm/h) 
figure

yyaxis left
a1 = plot(T_1, mdotin_1, '.-', MarkerSize = 20);
hold on
ylabel('Inlet Mass Flow Rate [lbm/h]')
ylim([0 7.3E5])

yyaxis right
a2 = plot(T_1, mdotf_1, '.-', MarkerSize = 20);
hold on
ylabel('Fuel Mass Flow Rate [lbm/h]')
ylim([0 1.65E4])
grid on

xlabel('Temperature [^{\circ}F]')
legend([a1 a2],{'Inlet','Fuel'}, Location = 'southeast')
title('Mass Flow Rate Comparison')

%% Plot vs To - T4 for 1 and 2, phase 2 equiv ratio
figure
yyaxis left 
plot(T_1, T4_1, '.-', MarkerSize = 20)
hold on
plot(T_2, T4_2, 'k.-', MarkerSize = 20)
ylabel('T4 [^{\circ}F]')
ylim([0 2500])

yyaxis right
plot(T_2, ER_2, '.-', MarkerSize = 20)
ylabel('Eq Ratio')
ylim([0 .4])
grid on

xlabel('Temperature [^{\circ}F]')
legend('Phase 1','Phase 2','Phase 2 Equivalence Ratio', Location = 'southwest')
title('Temperature at Stage 4 and Equivalence Ratio')

%% Plot vs To - T25,3,4,48,6 for phase 2 and T3,48,6 from data
figure
plot(T_2, T25_2, '.-', MarkerSize = 20)
hold on
plot(T_2, T3_2, 'r.-', MarkerSize = 20)
plot(T_2, T4_2, '.-', MarkerSize = 20)
plot(T_2, T48_2, '.-', 'Color', [0 0.5 0], MarkerSize = 20)
plot(T_2, T6_2, 'b.-', MarkerSize = 20)
plot(InTemp, T3, 'r.--', MarkerSize = 20)
plot(InTemp, T48, '.--', 'Color', [0 0.5 0],MarkerSize = 20)
plot(InTemp, T6, 'b.--', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Temperature [^{\circ}F]')
ylim([0 2500])
legend('Phase 2 T25','Phase 2 T3','Phase 2 T4','Phase 2 T48','Phase 2 T6','Measured T3','Measured T48','Measured T6', NumColumns = 3, Location = 'south')
title('Stage Temperature Comparison')
grid on

%% Plot vs To - Thermal efficiencies nTH for 1 and 2
figure
plot(T_1, nTH_1, '.-', MarkerSize = 20)
hold on
plot(T_2, nTH_2, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('nTH')
ylim([0 .4])
legend('Phase 1','Phase 2', Location = 'southeast')
title('Thermal Efficiency Comparison')
grid on

%% Plot vs To - SFC (lbm/kWh) and HR (BTU/kWh), two y axis
figure
yyaxis left
a1 = plot(T_2, SFC_2, '.-', MarkerSize = 20);
ylabel('SFC [lb/kWh]')
ylim([0 .45])

yyaxis right
a2 = plot(T_2, HR_2, '.-', MarkerSize = 20);
ylabel('HR [BTU/kWh]')
ylim([0 9500])
grid on

title('Phase 2 SFC and HR with Temperature Variation')
xlabel('Temperature [^{\circ}F]')
legend([a1 a2],{'Specific Fuel Consumption','Heat Rate'}, Location = 'southeast')

%% Plot vs %m - Generator output and turbine work ratio
figure
yyaxis left
a1 = plot(percent*100, PNET_m, '.-', MarkerSize = 20);
ylabel('Generator Output [MW]')
ylim([-.1 40])

yyaxis right
a2 = plot(percent*100, TWR_m, '.-', MarkerSize = 20);
ylabel('TR')
ylim([0 1.05])
grid on

title('Power Output and TR, Varying Mass Flow Rate')
xlabel('% Mass Flow Rate')
legend([a1 a2],{'Generator Power Output','Turbine Work Ratio'}, Location = 'north')

%% Plot vs %m - Thermal Efficiencies nTH and T4
figure
yyaxis left
a1 = plot(percent*100, nTH_m, '.-', MarkerSize = 20);
ylabel('nTH')
ylim([0 .4])

yyaxis right
a2 = plot(percent*100, TWR_m, '.-', MarkerSize = 20);
ylabel('Temperature [^{\circ}F')
ylim([0 1.05])
grid on

title('nTH and T4, Varying Mass Flow Rate')
xlabel('% Mass Flow Rate')
legend([a1 a2],{'Thermal Efficiency','T4'}, Location = 'southeast')

%% Plot vs %m - T25, T3, T4, T48, T6
figure
plot(percent*100, T25_m, '.-', MarkerSize = 20)
hold on
plot(percent*100, T3_m, '.-', MarkerSize = 20)
plot(percent*100, T4_m, '.-', MarkerSize = 20)
plot(percent*100, T48_m, '.-', MarkerSize = 20)
plot(percent*100, T6_m, '.-', MarkerSize = 20)
xlabel('% Mass Flow Rate')
ylabel('Temperature [^{\circ}F]')
ylim([0 2500])
legend('T25','T3','T4','T48','T6', Location = 'northwest')
title('Stage Temperature Comparison, Varying Mass Flow Rate')
grid on

%% Plot vs To - Wdotgen with and without evap cool
figure
plot(T_evap, PNET_evap, '.-', MarkerSize = 20)
hold on
plot(T_no, PNET_no, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Generator Output [MW]')
ylim([0 40])
xlim([45 110])
legend('On','Off')
title('Generator Output Evaporative Cooler Comparison')
grid on

%% Plot vs To - Thermal efficiency with and without evap cool
figure
plot(T_evap, nTH_evap, '.-', MarkerSize = 20)
hold on
plot(T_no, nTH_no, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Thermal Efficiency')
ylim([0 .395])
xlim([45 110])
legend('On','Off',Location='southeast')
title('Thermal Efficiency Evaporative Cooler Comparison')
grid on

%% Plot vs To - T25, T3, T4, T48, T6 with and without evap cool
figure
plot(T_evap, T25_evap, '.-', MarkerSize = 20, Linewidth = 1.5)
hold on
plot(T_evap, T3_evap, '.-', MarkerSize = 20, Linewidth = 1.5)
plot(T_evap, T4_evap, '.-', MarkerSize = 20, Linewidth = 1.5)
plot(T_evap, T48_evap, '.-', MarkerSize = 20, Linewidth = 1.5)
plot(T_evap, T6_evap, '.-', MarkerSize = 20, Linewidth = 1.5)
plot(T_no, T25_no, 'k-', Linewidth = 1.5)
plot(T_no, T3_no, 'k-', Linewidth = 1.5)
plot(T_no, T4_no, 'k-', Linewidth = 1.5)
plot(T_no, T48_no, 'k-', Linewidth = 1.5)
plot(T_no, T6_no, 'k-', Linewidth = 1.5)
scatter(T_no, T25_no, 10, 'k', 'filled', 'square')
xlabel('Temperature [^{\circ}F]')
ylabel('Temperature [^{\circ}F]')
ylim([0 2600])
xlim([45 110])
legend('On, T25','On, T3','On, T4','On, T48','On, T6','Off', NumColumns = 2, Location = 'best')
title('Stage Temperature Evaporative Cooler Comparison, Varying Inlet Temperature')
grid on


% set(groot, 'defaultFigureWindowState', 'normal');
