%% MAIN CODE TO OUTPUT PLOTS PHASE 2

clear all
close all
clc

% output all plots in full screen
set(groot, 'defaultFigureWindowState', 'maximized');

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

%% gather base case phase 1 info
[nT1, nT2, Vdot1b] = phase1_basecase(0);

%% base case phase 2
[PNET, mdotin, mdotout, nTH, Tturb, Teng, SFC, HR, hMain] = phase2_calcs(nT1, nT2, 65, 14585, Vdot1b, 9784, 1, 0);

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

for i = 1:4
    [PNET_2(i), mdotin_2(i), mdotout_2(i), nTH_2(i), T25_2(i), T3_2(i), T4_2(i), T48_2(i), T6_2(i), SFC_2(i), HR_2(i)] = phase2_calcs(nT1, nT2, T_2(i), mdotf_2(i), Vdot1b, RPM(i), 0, 0);
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

for i = 1:5
    [PNET_m(i), mdotin_m(i), mdotout_m(i), nTH_m(i), T25_m(i), T3_m(i), T4_m(i), T48_m(i), T6_m(i), SFC_m(i), HR_m(i)] = phase2_calcs(nT1, nT2, T, mdotf(i), Vdot1b, RPM, 0, 0);
end

%% plots

% Plot vs To - Generator output Wdotgen for 1 and 2 along with measured values (MW)
figure
plot(T_1, PNET_1, '.-', MarkerSize = 20)
hold on
plot(T_2, PNET_2, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Generator Output [MW]')
ylim([0 40])
legend('Phase 1','Phase 2','Measured Values')
title('Generator Output Comparison')

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

legend([a1 a2],{'Inlet','Fuel'}, Location = 'southeast')
title('Mass Flow Rate Comparison')

%% Plot vs To - T4 for 1 and 2, phase 2 equiv ratio
figure
plot(T_1, T4_1, '.-', MarkerSize = 20)
hold on
plot(T_2, T4_2, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('T4 [^{\circ}F]')
ylim([0 2500])
legend('Phase 1','Phase 2','Phase 2 Equivalence Ratio')
title('Temperature at Stage 4 and Equivalence Ratio')

%% Plot vs To - T25,3,4,48,6 for phase 2 and T3,48,6 from data
figure
plot(T_2, T25_2, '.-', MarkerSize = 20)
hold on
plot(T_2, T3_2, '.-', MarkerSize = 20)
plot(T_2, T4_2, '.-', MarkerSize = 20)
plot(T_2, T48_2, '.-', MarkerSize = 20)
plot(T_2, T6_2, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Temperature [^{\circ}F]')
ylim([0 2500])
legend('Phase 2 T25','Phase 2 T3','Phase 2 T4','Phase 2 T48','Phase 2 T6')
title('Stage Temperature Comparison')

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

%% Plot vs To - SFC (lbm/kWh) and HR (BTU/kWh), two y axis
figure
yyaxis left
plot()
hold on 

% Plot vs %m - Generator output and turbine work ratio


% Plot vs %m - Thermal Efficiencies nTH and T4


%% Plot vs %m - T25, T3, T4, T48, T6
figure
plot(percent*100, T25_m, '.-', MarkerSize = 20)
hold on
plot(percent*100, T3_m, '.-', MarkerSize = 20)
plot(percent*100, T4_m, '.-', MarkerSize = 20)
plot(percent*100, T48_m, '.-', MarkerSize = 20)
plot(percent*100, T6_m, '.-', MarkerSize = 20)
xlabel('Temperature [^{\circ}F]')
ylabel('Temperature [^{\circ}F]')
ylim([0 2500])
legend('T25','T3','T4','T48','T6')
title('Stage Temperature Comparison for Differing Mass Flow Rate Percentages')

% Plot vs To - Wdotgen with and without evap cool


% Plot vs To - Thermal efficiency with and without evap cool


% Plot vs To - T25, T3, T4, T48, T6 with and without evap cool