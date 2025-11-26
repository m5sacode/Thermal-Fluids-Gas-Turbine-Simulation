% calculate w given a RH, p, and T

    
function w = wcalc(RH, p, T)
    global Temp2 press

    idx = findvalue(Temp2, T);

    Ta = Temp2(idx-1);
    Tb = Temp2(idx);

    pa = press(idx-1);
    pb = press(idx);

    pg = pa + (pb-pa)*(T-Ta)/(Tb-Ta);


    w = .622*(RH*pg)/(p-RH*pg);
end