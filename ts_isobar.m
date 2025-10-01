% Calculate T-s curve for an isobar
function ts_isobar = ts_isobar(P, T0, T1, yN2, yO2, pref, Rbar, Tstart)

    % Temperature range
    Ts = linspace(T0, T1, 2000)'; % column vector (200 points)

    % Reference entropy at T0 (ideal gas entropy at pref)
    sb0 = sbarcalc(T0, yN2, yO2);

    % Allocate entropy array
    s_rel = zeros(size(Ts));

    % Loop over temperatures
    for i = 1:length(Ts)
        T = Ts(i);
        sb = sbarcalc(T, yN2, yO2);
        % Relative entropy at given P
        s_rel(i) = (sb - sb0 - Rbar*log(P/pref));
    end

    % Output two-column array [T, s_rel]
    ts_isobar = [s_rel, Ts];
    % Remove rows with T < Tstart
    ts_isobar = ts_isobar(Ts >= Tstart, :);
end
