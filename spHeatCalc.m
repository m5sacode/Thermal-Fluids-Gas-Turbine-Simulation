% compute cp, cv, k
% assumes T input is in K

function [cp, cv, k] = spHeatCalc(T, M, Avec)
    
    % convert T
    TZ = T/1000;

    % calculate cp
    cp = Avec(1) + Avec(2)*TZ + Avec(3)*TZ^2 + Avec(4)*TZ^3 + Avec(5)*TZ^4 + Avec(6)*TZ^5 + Avec(7)*TZ^6 + Avec(8)*TZ^7 + Avec(9)*TZ^8;

    % determine cv
    R = 8.314/M;
    cv = cp-R;

    k = cp/cv;

end
