%% calculate T given s bar
% works for temperatures between 300K, 3000K

function T = TcalcS(sb, yN2, yO2)

a1 = -9e-6;
b1 = .0553;
c1 = 180.19;
a2 = -1e-5;
b2 = .0583;
c2 = 192.88;

a = yN2*a1 + yO2*a2;
b = yN2*b1 + yO2*b2;
c = yN2*c1 + yO2*c2 - sb;

T1 = (-b + sqrt(b^2-4*a*c))/(2*a);
T2 = (-b - sqrt(b^2-4*a*c))/(2*a);

if (300 <= T1) && (T1 <= 3000)
    T = T1;
else
    T = T2;
end
