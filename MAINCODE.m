%% MAIN CODE TO OUTPUT PLOTS

clear all
close all
clc

global Temps N2hi N2so O2hi O2so yN2 yO2
yN2 = .79;
yO2 = .21;

data = readtable('polynomial calcs.xlsx');
Temps = table2array(data(:,"TempK"));
N2hi = table2array(data(:,"N2hi"));
N2so = table2array(data(:,"N2so"));
O2hi = table2array(data(:,"O2hi"));
O2so = table2array(data(:,"O2so"));

% gather base case info
[nT1, nT2, Vdot1] = phase1_basecase(0);

% varying inlet temps



% varying fuel flow rate
[WdotELEC, mdotin, mdotout, nTH, T4, T6, SFC, HR] = phase1_calcs(nT1, nT2, 65, 14585, Vdot1);