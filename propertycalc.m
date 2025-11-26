% calculates properties of an ideal gas
% input T, p, molar comp
% print and return properties

function [T, P, cp, cv, k, u, h, so, s] = propertycalc(T, P, yO2, yN2, yH2O, yCO2, print)
    
    if nargin < 7
        print = 0;
    end

    % initialize molar masses 
    MO2 = 32.00; 
    MN2 = 28.01; 
    MH2O = 18.02;
    MCO2 = 44.01;

    % define polynomial coefficients
    
    [O2, N2, H2O, CO2] = coeffs();
     
    % compute cpi, cvi, ki
    
    [cpO2, cvO2, kO2] = spHeatCalc(T, MO2, O2);
    [cpN2, cvN2, kN2] = spHeatCalc(T, MN2, N2);
    [cpH2O, cvH2O, kH2O] = spHeatCalc(T, MH2O, H2O);
    [cpCO2, cvCO2, kCO2] = spHeatCalc(T, MCO2, CO2);
    
    
    % compute ui, hi, soi, si
    
    [uO2, hO2, soO2, sO2] = propCalc(T, P, MO2, O2);
    [uN2, hN2, soN2, sN2] = propCalc(T, P, MN2, N2);
    [uH2O, hH2O, soH2O, sH2O] = propCalc(T, P, MH2O, H2O);
    [uCO2, hCO2, soCO2, sCO2] = propCalc(T, P, MCO2, CO2);
    
    % calculate molar mass
    M = yO2*MO2 + yN2*MN2 + yH2O*MH2O + yCO2*MCO2;
    
    % calculate mass fractions
    xO2 = yO2*MO2/M;
    xN2 = yN2*MN2/M;
    xH2O = yH2O*MH2O/M;
    xCO2 = yCO2*MCO2/M;
    
    % calculate cp
    cp = xO2*cpO2 + xN2*cpN2 + xH2O*cpH2O + xCO2*cpCO2;
    
    % calculate cv
    cv = xO2*cvO2 + xN2*cvN2 + xH2O*cvH2O + xCO2*cvCO2;
    
    % calculate k
    k = cp/cv;
    
    % calculate u
    u = xO2*uO2 + xN2*uN2 + xH2O*uH2O + xCO2*uCO2;
    
    % calculate h
    h = xO2*hO2 + xN2*hN2 + xH2O*hH2O + xCO2*hCO2;
    
    % calculate so
    so = xO2*soO2 + xN2*soN2 + xH2O*soH2O + xCO2*soCO2;
    
    % calculate s
    s = xO2*sO2 + xN2*sN2 + xH2O*sH2O + xCO2*sCO2;
    
    
    % print T, P, cp, cv, k, u, h, so, s
    if print == 1
        properties = table(T, P, cp, cv, k, u, h, so, s, 'VariableNames', {'T','p','Cp','Cv','k','u','h','so','s'})
    end

end