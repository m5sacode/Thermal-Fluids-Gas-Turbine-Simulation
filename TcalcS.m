%% calculate T given s bar
% works for temperatures between 300K, 3000K

function T = TcalcS(sb, yN2, yO2)

% a1 = 5e-9;
% b1 = -3e-5;
% c1 = .0892;
% d1 = 168.24;
% a2 = 5e-9;
% b2 = -4e-5;
% c2 = .0932;
% d2 = 180.66;

a1 = -3e-12;
b1 = 2e-8;
c1 = -8e-5;
d1 = .1207;
e1 = 161.29;
a2 = -3e-12;
b2 = 2e-8;
c2 = -7e-5;
d2 = .123;
e2 = 174.07;

err = 1;
T = 272;
while err > 1e-4
    T = T+.0001;
    sbest = yN2*(a1*T^4+b1*T^3+c1*T^2+d1*T+e1) + yO2*(a2*T^4+b2*T^3+c2*T^2+d2*T+e2);
    % sbest = yN2*(a1*T^3+b1*T^2+c1*T+d1) + yO2*(a2*T^3+b2*T^2+c2*T+d2);
    err = abs(sbest-sb);
end

