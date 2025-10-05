%% calculate T given h bar
% works for temperatures between 300K, 3000K

function T = TcalcH(hb)

err = 1;
Tmin = 250;
Tmax = 1800;

while err > 1e-3
    T = (Tmin+Tmax)/2;
    hcalc = valInterp(T, 1);
    err = abs(hb-hcalc);
    if hb > hcalc
        Tmin = T;
    elseif hb < hcalc
        Tmax = T;
    end    
end

end