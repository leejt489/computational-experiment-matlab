function [f,ax] = plotGroupedBar(data,metricLabels,treatmentLabels)
%PLOTGROUPEDBAR Plot a stacked bar chart of data with error bars
%   'data': A cell array of length(N). Each cell must contain a 2-D array
%   with M columns and O rows. The cell corresponds to a metric and will
%   be given a bar in each cluster of bars. The column corresponds to a
%   treatment, and the column values are the outcome for that treatment
%   across trials. Each row is trial. There will be M clusters of N bars.
%   The height of the bar is the mean of that metric over treatments for
%   that trial, while the error bar is the standard deviation.

N = length(data);
if (N < 1)
    warning('No data provided');
    return
end
M = size(data{1},2);

y = nan(M,N);
err = nan(size(y));

% Compute mean and standard deviation
for i = 1:N
    y(:,i) = mean(data{i})';
    err(:,i) = std(data{i});
end

f = figure;
bar(y);
hold on;

if (nargin >= 3)
    set(gca,'XTickLabel',treatmentLabels);
end

% Add error bars; thanks to https://www.mathworks.com/matlabcentral/answers/438514-adding-error-bars-to-a-grouped-bar-plot

nGroups = size(y,1); nBars = size(y,2);
groupwidth = min(0.8, nBars/(nBars + 1.5));
for i = 1:nBars
    x = (1:nGroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nBars);
    errorbar(x, y(:,i), err(:,i),'.k');
end

legend(metricLabels{:},'Std. Dev.','Location','NorthWest');
ax = gca;
end

