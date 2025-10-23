%% calculate T given s bar
% works for temperatures between 300K, 3000K

function T = TcalcS(sb)

err = 1;
Tmin = 0;
Tmax = 3250;

while err > 1e-3
    T = (Tmin+Tmax)/2;
    scalc = valInterp(T, 0);
    err = abs(sb-scalc);
    if sb > scalc
        Tmin = T;
    elseif sb < scalc
        Tmax = T;
    end    
end

end