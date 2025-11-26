% calculate h given T using the property calc

function h = hcalc(T, yO2, yN2, yH2O, yCO2, M)

[~, ~, ~, ~, ~, ~, h1] = propertycalc(T, 1, yO2, yN2, yH2O, yCO2);
[~, ~, ~, ~, ~, ~, h2] = propertycalc(25, 1, yO2, yN2, yH2O, yCO2);

h = (h1 - h2)/M;
