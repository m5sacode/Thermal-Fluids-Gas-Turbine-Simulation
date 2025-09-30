%% calculate s bar given T
function sb = sbarcalc(T, yN2, yO2)

a1 = -9e-6;
b1 = .0553;
c1 = 180.19;
a2 = -1e-5;
b2 = .0583;
c2 = 192.88;

sb = yN2*(a1*T^2+b1*T+c1) + yO2*(a2*T^2+b2*T+c2);