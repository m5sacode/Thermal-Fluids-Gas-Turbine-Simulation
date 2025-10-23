function sb = scalcpoly(T)

a1 = -2e-11;
b1 = 1e-7;
c1 = -.0003;
d1 = 0.3059;
e1 = 109.4;

a2 = -2e-11;
b2 = 1e-7;
c2 = -.0003;
d2 = 0.3238;
e2 = 117.83;

sb1 = a1*T^4 + b1*T^3 + c1*T^2 + d1*T + e1;

sb2 = a2*T^4 + b2*T^3 + c2*T^2 + d2*T + e2;

sb = .79*sb1 + .21*sb2;

