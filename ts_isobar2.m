function ts = ts_isobar2(P, T0, T1, pref, yO2, yN2, yH2O, yCO2, Mmix, Tstart)

    % Temperature sweep
    Ts = linspace(T0, T1, 50)';

    % Reference entropy at T0 (kJ/kg-K)
    s0 = scalc(T0, yO2, yN2, yH2O, yCO2, Mmix);

    % Mixture gas constant (kJ/kg-K)
    R = 8.314/(Mmix*1000);   % 8.314 J/molK → kJ/kgK

    % Allocate output
    s_rel = zeros(size(Ts));

    % Loop through temperature range
    for i = 1:length(Ts)
        T = Ts(i);

        % Absolute entropy at pref
        sT = scalc(T, yO2, yN2, yH2O, yCO2, Mmix);

        % Relative entropy on isobar P
        s_rel(i) = sT - s0 - R*log(P/pref);
    end

    % Output array [s T]
    ts = [s_rel, Ts];

    % Trim to T >= Tstart
    ts = ts(Ts >= Tstart, :);

end
