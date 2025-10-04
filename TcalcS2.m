function T = TcalcS2(sb, yN2, yO2)

a1 = 5e-9;
b1 = -3e-5;
c1 = .0846;
d1 = 170.29;
a2 = 5e-9;
b2 = -3e-5;
c2 = .0889;
d2 = 182.55;

err = 1;
T = 272;
while err > 1e-4
    T = T+.001;
    sbest = yN2*(a1*T^3+b1*T^2+c1*T+d1) + yO2*(a2*T^3+b2*T^2+c2*T+d2);
    err = abs(sbest-sb);
end