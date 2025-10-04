%% calculate h bar given T
function hb = hbarcalc(T, yN2, yO2)

hb = valInterp(T, 1, yN2, yO2);

% a1 = .0027;
% b1 = 27.13;
% c1 = 332.81;
% a2 = .0028;
% b2 = 28.726;
% c2 = -232.2;
% 
% hb = yN2*(a1*T^2+b1*T+c1) + yO2*(a2*T^2+b2*T+c2);