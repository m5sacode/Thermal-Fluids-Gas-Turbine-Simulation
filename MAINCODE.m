%% MAIN CODE TO OUTPUT PLOTS

clear all
close all
clc

global Temps N2hi N2so O2hi O2so
yN2 = .79;
yO2 = .21;

data = readtable('polynomial calcs.xlsx');
Temps = table2array(data(:,"TempK"));
N2hi = table2array(data(:,"N2hi"));
N2so = table2array(data(:,"N2so"));
O2hi = table2array(data(:,"O2hi"));
O2so = table2array(data(:,"O2so"));


% gather turbine efficiencies
[nT1, nT2] = phase1_basecase();


%%

% test interp at 425
% T = 291.83;
% idx = findvalue(Temps,T);
% sbar = valInterp(T,0,yN2,yO2)
% 
% sbarpoly = sbarcalc(T,yN2, yO2)