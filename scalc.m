% calculate s given T using the property calc

function s = scalc(T, p, yO2, yN2, yH2O, yCO2, M)

[~, ~, ~, ~, ~, ~, ~, ~, s1] = propertycalc(T, p, yO2, yN2, yH2O, yCO2);
[~, ~, ~, ~, ~, ~, ~, ~, s2] = propertycalc(298, p, yO2, yN2, yH2O, yCO2);

s = (s1 - s2)*M;
