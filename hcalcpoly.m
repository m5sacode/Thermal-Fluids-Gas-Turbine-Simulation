function hb = hcalcpoly(T)

a1 = 3e-12;
b1 = -5e-7;
c1 = .0039;
d1 = 26.352;
e1 = 447.29;

a2 = 2e-10;
b2 = -2e-6;
c2 = .0063;
d2 = 26.257;
e2 = 283.76;

hb1 = a1*T^4 + b1*T^3 + c1*T^2 + d1*T + e1;

hb2 = a2*T^4 + b2*T^3 + c2*T^2 + d2*T + e2;

hb = .79*hb1 + .21*hb2;