%% calculate T given h bar
% works for temperatures between 300K, 3000K

function T = TcalcH(hb, yN2, yO2)

a1 = .0016;
b1 = 29.365;
c1 = -553.696;
a2 = .0017;
b2 = 31.041;
c2 = -1123.8;

a = yN2*a1 + yO2*a2;
b = yN2*b1 + yO2*b2;
c = yN2*c1 + yO2*c2 - hb;

T1 = (-b + sqrt(b^2-4*a*c))/(2*a);
T2 = (-b - sqrt(b^2-4*a*c))/(2*a);

if (300 <= T1) && (T1 <= 3000)
    T = T1;
else
    T = T2;
end