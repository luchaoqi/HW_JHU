function plotParameters(B,stats)
% Plots parameters and its confidence intervals
numCoeff = numel(B);
df = stats.dfe;
SE = stats.se;

CIadd = 2 * tinv(0.95,df) * SE;

figure
X = 0:(numCoeff-1);
Y = B;
scatter(X,Y);
hold on
errorbar(X,Y, CIadd, 'LineStyle','none');
hold off
end

