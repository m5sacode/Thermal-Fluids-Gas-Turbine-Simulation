%% MAIN CODE TO OUTPUT PLOTS PHASE 2

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
[nT1, nT2, Vdot1b] = phase1_basecase(1);

%% varying inlet temps phase 1
T = [35 65 85 105];
mdotf = [15981 14585 13518 12410];
RPM = [9752 9784 9881 9974];

PNET1 = zeros(1,4); 
mdotin1 = zeros(1,4);
mdotout1 = zeros(1,4);
nTH1 = zeros(1,4);
T41 = zeros(1,4);
T61 = zeros(1,4);
SFC1 = zeros(1,4);
HR1 = zeros(1,4);

for i = 1:4
    [PNET1(i), mdotin1(i), mdotout1(i), nTH1(i), T41(i), T61(i), SFC1(i), HR1(i)] = phase1_calcs(nT1, nT2,T(i), mdotf(i), Vdot1b, RPM(i),0);
end