function value = valInterp(T, type, yN2, yO2)
    global N2so O2so N2hi O2hi Temps

    if type == 0
        N2 = N2so;
        O2 = O2so;
    elseif type == 1 
        N2 = N2hi;
        O2 = O2hi;
    else
        fprintf('invalid type')
    end

    idx = findvalue(Temps, T);

    Ta = Temps(idx-1);
    Tb = Temps(idx);

    % N2
    valA = N2(idx-1);
    valB = N2(idx);
    valueN2 = valA + (valB-valA)*(T-Ta)/(Tb-Ta);

    % O2
    valA = O2(idx-1);
    valB = O2(idx);
    valueO2 = valA + (valB-valA)*(T-Ta)/(Tb-Ta);

    value = yN2*valueN2 + yO2*valueO2;
