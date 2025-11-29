%% UT Power Plant Gas Turbine Analysis (Phase 2)
%
% assumptions: fuel = natural gas, entire turbine is adiabatic
%
% sb => s bar
% hb => h bar
%
% 

function [PNET, mdotin, mdotout, nTH, Tturb, Teng, SFC, HR, hMain] = phase2_calcs(nT1, nT2, Tin, mdotf, Vdot1b, RPM, table, TSplot)
    %% Set Up

    global yN2 yO2

    % general constants
    Rbar = 8.314; % kJ/kmol*K
    Mair = 28.02*yN2 + 31.999*yO2; % kg/kmol
    Mh2o = 18.01;
    

    % conversion values
    psi2kPa = 6.895;
    R2K = 5/9;
    ft2m = 1/3.281;
    inH2O2kPa = 1/4.019;
    lb2kg = 1/2.205;
    BTUlb2kJkg = 2.326;
    hr2s = 3600;
    
    %% Input Operating Parameters 

    % ambient air conditions
    p0 = 14.417 * psi2kPa; % kPa
    T0 = (Tin + 459.67) * R2K; % K
    RH0 = .6; % percent
    
    % altitude (not used in phase 1)
    ALT = 530 * ft2m; % m
    
    % inlet air mass flow rate
    v0 = (Rbar/Mair)*T0/p0;
    Vdot0 = Vdot1b * RPM/9784;
    mdot0 = Vdot0/v0; % kg/s
    
    % inlet pressure loss
    delPin = 4 * inH2O2kPa; % kPa
    
    % exhaust pressure loss
    delPex = 10 * inH2O2kPa ; % kPa

    % fuel type (percent on a molar basis)
    CH4 = .96;
    C2H6 = .04; 
    
    % lower heating value
    % LHV = 19000 * BTUlb2kJkg; % kJ/kg
    
    % fuel mass flow rate
    mdotf = mdotf * lb2kg * 1/hr2s; % kg/s
    
    
    %% Input Design Parameters
    
    % compressor pressure ratios
    rLPC = 6;
    rHPC = 4;
    
    % bypass air mass flow percent
    mBP = 0;
    
    % HP compressor parasitic bleed air mass flow percent
    mPB = 0;
    
    % compressor efficiencies (percent)
    nLPC = .82;
    nHPC = .84;
    
    % turbine efficiencies (percent)
    nHPT = nT1;
    nLPT = nT2;
    
    % generator efficiency (percent)
    nGEN = .977;
   
    %% state 0 (already set up)
    

    %% state 0 -> 1: inlet
    RH1 = RH0;
    
    p1 = p0 - delPin;
    
    T1 = T0;
    
    sb1 = sbarcalc(T1);
    
    %% state 1 -> 2: evaporative cooler
    p2 = p1;
    
    RH2 = 1;
    
    % enthalpies at state 1
    ha1 = hcalc(T1,yO2,yN2,0,0,Mair);
    hv1 = hcalc(T1,0,0,1,0,Mh2o);
    
    w1 = wcalc(RH1,p1,T1);
    
    h1 = ha1 + w1*hv1;
    
    % iterate to find T2
    err = 1;
    Tmin = 271.01;
    Tmax = 633;
    
    while err > 1e-3
        T2 = (Tmin+Tmax)/2;
        ha2 = hcalc(T2,yO2,yN2,0,0,Mair);
        hv2 = hcalc(T2,0,0,1,0,Mh2o);
        w2 = wcalc(RH2,p2,T2);
        h2 = ha2 + w2*hv2;
        err = abs(h1-h2);
        if h1 > h2
            Tmin = T2;
        elseif h1 < h2
            Tmax = T2;
        end    
    end
    
    % mass and molar flow rates
    Vdot2 = Vdot0;
    ndot2 = (p2*Vdot2)/(Rbar*T2);
    ndota = ndot2/(1+w2*(Mair/Mh2o));
    ndotv2 = ndot2-ndota;
    mdotv2 = ndotv2*Mh2o;
    mdota = ndota*Mair;
    mdotv1 = w1*mdota;
    mdotliq = mdotv2-mdotv1;

    %% state 2 -> 25: LP compressor
    p25 = p2 * rLPC;
    sb2 = sbarcalc(T2);
    sb25s = sb2 + Rbar*log(p25/p2);
    T25s = TcalcS(sb25s);
    hb25s = hbarcalc(T25s);
    h25s = hb25s / Mair;
    h25 = h2 - (h2 - h25s)/nLPC;
    hb25 = h25 * Mair;
    T25 = TcalcH(hb25);
    WdotC1 = mdot0*(h25-h2);
    
    %% state 25 -> 3: HP compressor
    p3 = p25 * rHPC;
    sb25 = sbarcalc(T25);
    sb3s = sb25 + Rbar*log(p3/p25);
    T3s = TcalcS(sb3s);
    hb3s = hbarcalc(T3s);
    h3s = hb3s / Mair;
    h3 = h25 - (h25 - h3s)/nHPC;
    hb3 = h3 * Mair;
    T3 = TcalcH(hb3);
    sb3 = sbarcalc(T3);
    WdotC2 = mdot0*(h3-h25);
    
    %% state 3 -> 4: combustor
    
    % coefficients
    ndotf = mdotf/(CH4*16+C2H6*30);
    Aodot = ndota/4.76;
    A1dot = ndotv2;
    
    % molar enthalpies of formation
    hfCH4 = -74850;
    hfC2H6 = -84680;
    hfH2O = -241920;
    hfCO2 = -393520;
    
    % inlet molar sensible enthalpies (assuming fuel enters at 298K)
    hsO2i = hcalc(T3, 1, 0, 0, 0, 32);
    hsN2i = hcalc(T3, 0, 1, 0, 0, 28.01);
    hsH2Oi = hcalc(T3, 0, 0, 1, 0, 18.02);

    Hdot3 = ndotf*CH4*hfCH4 + ndotf*C2H6*hfC2H6 + Aodot*hsO2i + 3.76*Aodot*hsN2i + A1dot*(hfH2O+hsH2Oi);

    % iterate to find T2
    err = 1;
    Tmin = 500;
    Tmax = 3000;
    
    while err > 1e-3
        T4 = (Tmin+Tmax)/2;

        % outlet molar sensible enthalpies
        hsO2o = hcalc(T4, 1, 0, 0, 0, 32);
        hsN2o = hcalc(T4, 0, 1, 0, 0, 28.01);
        hsH2Oo = hcalc(T4, 0, 0, 1, 0, 18.02);
        hsCO2o = hcalc(T4, 0, 0, 0, 1, 44.01);

        Hdot4 = 1.04*ndotf*(hfCO2+hsCO2o) + ((4.08/2)*ndotf+A1dot)*(hfH2O+hsH2Oo) + (Aodot-1.04*ndotf)*(hsO2o) + 3.76*Aodot*hsN2o;
        
        err = abs(Hdot3-Hdot4);

        if Hdot3 > Hdot4
            Tmin = T4;
        elseif Hdot3 < Hdot4
            Tmax = T4;
        end    
    end
    
    LHV = -(CH4*(hfCO2 + 2*hfH2O - hfCH4) + C2H6*(2*hfCO2 + 3*hfH2O - hfC2H6)) / (CH4*16.04 + C2H6*30.07);
    Qdot = mdotf * LHV;

    % properties downstream of combustor
    sb4 = sbarcalc(T4);
    p4 = p3;

    
    

    %% state 4 -> 48: HP turbine
    WdotT1 = WdotC1 + WdotC2;
    h48 = h4 - (WdotT1/mdot4);
    hb48 = h48 * M;
    T48 = TcalcH(hb48);
    sb48 = sbarcalc(T48);
    wT1 = WdotT1/mdot4;
    h48s = h4 - wT1/nHPT;
    hb48s = h48s * M;
    T48s = TcalcH(hb48s);
    sb48s = sbarcalc(T48s);
    p48 = p4*exp((sb48s-sb4)/Rbar);

    %% state 48 -> 5: LP turbine
    p5 = p0 + delPex;
    sb5s = sb48 + Rbar*log(p5/p48); 
    T5s = TcalcS(sb5s);
    hb5s = hbarcalc(T5s);
    h5s = hb5s / Mair;
    h5 = h48 - nLPT*(h48-h5s);
    hb5 = h5 * Mair;
    T5 = TcalcH(hb5);
    sb5 = sbarcalc(T5);
    WdotT2 = mdot4*(h48 - h5);
    WdotELEC = WdotT2*nGEN;

    %% state 6: after nozzle
    p6 = p0;
    
    T6 = T5;
    sb6 = sbarcalc(T6);
    
    %% Output Performance Parameters
    
    if table == 1
        states = [1 2 25 3 4 48 5 6]';
        allT = 1/R2K*[T1 T2 T25 T3 T4 T48 T5 T6]'- 459.67;
        allp = 1/psi2kPa*[p1 p2 p25 p3 p4 p48 p5 p6]';
        
        data = [states allT, allp];
        
        BaseCaseStates = array2table(data, "VariableNames", ["state", "temp (F)", "pressure (psi)"])
    end

    Tturb = T4 * 1/R2K - 459.67;
    Teng = T6 * 1/R2K - 459.67;
    PNET = WdotELEC / 1000;
    mdotin = mdot0 * 1/lb2kg * hr2s; 
    mdotout = mdot4 * 1/lb2kg * hr2s; 
    nTH = WdotELEC/Qdot;
    SFC = mdotf/WdotELEC * 1/lb2kg * hr2s; 
    HR = SFC*LHV * 1/BTUlb2kJkg;
    
    %% T–s diagram
    hMain = []; % placeholder in case no plot happens
if isa(TSplot, 'matlab.graphics.axis.Axes')
    ax = TSplot;  % Existing axes handle passed in
    hold(ax, 'on');
elseif isequal(TSplot, 1)
    figure;
    ax = gca;
    hold(ax, 'on');
else
    return;
end

% --- Define states
states = [1 2 25 3 4 48 5 6]';

% Reference for real entropy change (T–S diagram)
sbref = 0;

% --- calculate specific entropies
sb1r = sbref;
sb2r   = sb1r + sb2 - sb1 - Rbar*log(p2/p0);
sb25r  = sb2r + sb25 - sb2 - Rbar*log(p25/p2);
sb25rs = sb2r + sb25s - sb2 - Rbar*log(p25/p2);
sb3rs  = sb25r + sb3s - sb25 - Rbar*log(p3/p25);
sb3r   = sb25r + sb3 - sb25 - Rbar*log(p3/p25);
sb4r   = sb3r + sb4 - sb3 - Rbar*log(p4/p3);
sb48r  = sb4r + sb48 - sb4 - Rbar*log(p48/p4);
sb48rs = sb4r + sb48s - sb4 - Rbar*log(p48/p4);
sb5r   = sb48r + sb5 - sb48 - Rbar*log(p5/p48);
sb5rs  = sb48r;
sb6r   = sb5r + sb6 - sb5 - Rbar*log(p6/p5);

% --- Collect specific entropies (kJ/kg·K)
allS = [ ...
    sb1r/Mair
    sb2r/Mair
    sb25r/Mair
    sb3r/Mair
    sb4r/Mair
    sb48r/Mair
    sb5r/Mair
    sb6r/Mair ];

% --- Assign a unique color from the current color order
colorOrder = ax.ColorOrder;
colorIndex = mod(ax.ColorOrderIndex-1, size(colorOrder,1)) + 1;
color = colorOrder(colorIndex, :);

% --- Plot 1–2–25–3
hMain = plot(ax, allS(1:4), [T0 T2 T25 T3], 'o-', ...
    'Color', color, 'LineWidth', 1, 'MarkerSize', 6, ...
    'DisplayName', sprintf('%.0f%% fuel rate', round(100*mdotf/1.8374)));



% --- Plot 4–48–5–6
plot(ax, allS(5:8), [T4 T48 T5 T6], 'o-', 'Color', color, ...
    'LineWidth', 1, 'MarkerSize', 6);

xlabel(ax, 'Specific Entropy s (kJ/kg·K)');
ylabel(ax, 'Temperature T (K)');
title(ax, ['Gas Turbine T–s Diagram at fuel mass flow: ', ...
           num2str(round(100*mdotf/1.8374)), '%']);
grid(ax, 'on');

% --- Label states
text(ax, allS, [T0 T2 T25 T3 T4 T48 T5 T6], string(states), ...
    'VerticalAlignment','bottom', 'HorizontalAlignment','right');

% --- Isentropic points
S_iso = [sb25rs/Mair, sb3rs/Mair, sb48rs/Mair, sb5rs/Mair];
T_iso = [T25s,     T3s,     T48s,    T5s];
labels_iso = {'25s','3s','48s','5s'};

scatter(ax, S_iso, T_iso, 60, [0.5 0.5 0.5], 'x', 'LineWidth', 1.5);
text(ax, S_iso, T_iso, labels_iso, ...
    'VerticalAlignment','top', 'HorizontalAlignment','left', ...
    'Color', [0.5 0.5 0.5],'FontSize',6);

% --- Connect turbine inlets to isentropic outlets
S_in = [sb2r/Mair, sb25r/Mair, sb4r/Mair, sb48r/Mair];
T_in = [T2,     T25,     T4,     T48];

for k = 1:length(S_iso)
    plot(ax, [S_iso(k) S_iso(k)], [T_in(k) T_iso(k)], ...
        '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.8);
end

% --- Example isobars
iso_curve_25s_25 = ts_isobar(p25, T0, T25, p0, Rbar, T25s);
plot(ax, iso_curve_25s_25(:,1)/Mair, iso_curve_25s_25(:,2), ...
    '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);

iso_curve_3s_3 = ts_isobar(p3, T0, T3, p0, Rbar, T3s);
plot(ax, iso_curve_3s_3(:,1)/Mair, iso_curve_3s_3(:,2), ...
    '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);

iso_curve_3_4 = ts_isobar(p3, T0, T4, p0, Rbar, T3);
plot(ax, iso_curve_3_4(:,1)/Mair, iso_curve_3_4(:,2), ...
    '-', 'Color', color, 'LineWidth', 1);

iso_curve_48s_48 = ts_isobar(p48, T0, T48, p0, Rbar, T48s);
plot(ax, iso_curve_48s_48(:,1)/Mair, iso_curve_48s_48(:,2), ...
    '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);

iso_curve_5s_5 = ts_isobar(p5, T0, T5, p0, Rbar, T5s);
plot(ax, iso_curve_5s_5(:,1)/Mair, iso_curve_5s_5(:,2), ...
    '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);

iso_curve_1_6 = ts_isobar(p6, T0, T6, p0, Rbar, T0);
plot(ax, iso_curve_1_6(:,1)/Mair, iso_curve_1_6(:,2), ...
    '--', 'Color', color, 'LineWidth', 1);

hold(ax, 'off');

end