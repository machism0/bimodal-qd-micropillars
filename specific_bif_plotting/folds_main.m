%% Fold continuations
%  axes = feedback amp, feedback phase, intensity
%  found in 'vfolds.m' (I think) data in 'folds_main.mat'

clear;
load(strcat(specific_bif_data_dir(), ...
    'folds_main.mat'))

% % plot just folds
% figure;
% for i = 1:numel(folds)
%     plot_branch3( folds{i}, ...
%     param, ...
%     'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
%     'color', 'r', ...
%     'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
%     'add_2_gcf', 1)
% end

key = {'m', 'y', 'r', 'g', 'b', 'k'};
h = zeros(numel(folds), 1);

figure;
for i = 1:numel(folds)
    plot_branch3( folds{i}, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'color', key{i}, ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)
end

hold on
for i = 1:numel(h)
    h(i) = plot(NaN, NaN, strcat('o', key{i}));
end
legend(h, 'f1', 'f2', 'f3', 'f4', 'f5', 'f6');

view(3)
zlabel('Strong Field Intensity')
title('Fold Continuations')
saveas(gca, strcat(data_directory(), 'folds_main_color.png'))

% %% Fold continuations given different mode seperations
% %  axes = feedback amp, feedback phase, intensity
% %  found in 'fold_mode_sep.m' data in 'kappaw45b.mat'
% 
% clear;
% load(strcat(specific_bif_data_dir(), ...
%     'folds_kappaw45.mat'))
% 
% % plot just folds
% figure;
% for i = 1:numel(folds)
%     plot_branch3( folds{i}, ...
%     param, ...
%     'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
%     'color', 'r', ...
%     'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
%     'add_2_gcf', 1)
% end
% 
% %% Fold continuations given different mode seperations
% %  axes = feedback amp, feedback phase, intensity
% %  found in 'fold_mode_sep.m' data in 'kappaw47b.mat'
% 
% clear;
% load(strcat(specific_bif_data_dir(), ...
%     'folds_kappaw47.mat'))
% 
% % plot just folds
% figure;
% for i = 1:numel(folds)
%     plot_branch3( folds{i}, ...
%     param, ...
%     'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
%     'color', 'r', ...
%     'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
%     'add_2_gcf', 1)
% end