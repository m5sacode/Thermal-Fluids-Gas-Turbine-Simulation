%% calculate T given s bar
% works for temperatures between 300K, 3000K

function T = TcalcS2(sb, yO2, yN2, yH2O, yCO2, M)

err = 1;
Tmin = 0;
Tmax = 3500;

while err > 1e-3
    T = (Tmin+Tmax)/2;
    sc = scalc(T, yO2, yN2, yH2O, yCO2, M);
    err = abs(sb-sc);
    if sb > sc
        Tmin = T;
    elseif sb < sc
        Tmax = T;
    end    
end

end