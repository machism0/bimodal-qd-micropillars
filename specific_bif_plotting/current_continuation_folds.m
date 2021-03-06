%% Bifurcation continuations in the current direction
%  axes = feedback amp, current, intensity (at a given phase)
%  found in 'current.m' data in 'current.mat'

clear;
load(strcat(specific_bif_data_dir(), ...
    'current_continuation_folds.mat'))

% There was no continuation data at phase = 0
% I believe this is because the two fold bifurcations become transcritical

% plot current continuation at phase = pi/2
figure
for i = 1:2
    plot_branch3( curs_famp0303_phasePi2{i}, ...
        param, ...
        'axes_indParam', {param.feed_ampli.index, param.J.index, 'x1'}, ...
        'nunst_color', curs_famp0303_phasePi2{i}.nunst, ...
        'add_2_gcf', 1)
end

plot_branch3( fold_cur_famp_phasePi2, ...
    param, ...
    'axes_indParam', {param.feed_ampli.index, param.J.index, 'x1'}, ...
    'color', 'r', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)

% plot current continuation at phase = pi/4
figure
for i = 1:2
    plot_branch3( curs_famp0303_phasePi4{i}, ...
        param, ...
        'axes_indParam', {param.feed_ampli.index, param.J.index, 'x1'}, ...
        'nunst_color', curs_famp0303_phasePi4{i}.nunst, ...
        'add_2_gcf', 1)
end

plot_branch3( fold_cur_famp_phasePi4, ...
    param, ...
    'axes_indParam', {param.feed_ampli.index, param.J.index, 'x1'}, ...
    'color', 'r', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)