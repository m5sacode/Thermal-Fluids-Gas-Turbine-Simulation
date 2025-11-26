% computes u, h, so, s
% assumes T input is in C

function [ui, hi, soi, si] = propCalc(T, p, Mi, Avec)
    
    % set reference values and constants
    Tref = 0.5; % [K]
    uref = 0;
    href = 0;
    soref = 0;
    pref = 101; % [kPa]
    R = 8.314/Mi;

    TK = T + 273;

    % create functions
    cpFun = @(T) Avec(1) + Avec(2)*(T/1000) + Avec(3)*(T/1000).^2 + Avec(4)*(T/1000).^3 + Avec(5)*(T/1000).^4 + Avec(6)*(T/1000).^5 + Avec(7)*(T/1000).^6 + Avec(8)*(T/1000).^7 + Avec(9)*(T/1000).^8;
    cvFun = @(T) cpFun(T) - R;
    cpTFun = @(T) cpFun(T) ./ T;
    
    % integrate for u
    ui = integral(cvFun, Tref, TK) + uref;

    % integrate for h
    hi = integral(cpFun, Tref, TK) + href;

    % integrate for so
    soi = integral(cpTFun, Tref, TK) + soref;

    % calculate s
    si = soi - R*log(p/pref);

end

