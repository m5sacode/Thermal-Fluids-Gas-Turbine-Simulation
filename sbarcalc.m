%% calculate s bar given T
function sb = sbarcalc(T, yN2, yO2)


sb = valInterp(T, 0, yN2, yO2);

% a1 = 2e-8;
% b1 = -7e-5;
% c1 = .1186;
% d1 = 161.96;
% a2 = 2e-8;
% b2 = -7e-5;
% c2 = .1204;
% d2 = 174.82;
% 
% sb = yN2*(a1*T^3+b1*T^2+c1*T+d1) + yO2*(a2*T^3+b2*T^2+c2*T+d2);
