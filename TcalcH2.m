%% calculate T given h bar
% works for temperatures between 250K, 3200K

function T = TcalcH2(hb, yO2, yN2, yH2O, yCO2, M)

err = 1;
Tmin = 250;
Tmax = 3500;

while err > 1e-3
    T = (Tmin+Tmax)/2;
    hc = hcalc(T, yO2, yN2, yH2O, yCO2, M);
    err = abs(hb-hc);
    if hb > hc
        Tmin = T;
    elseif hb < hc
        Tmax = T;
    end    
end

end