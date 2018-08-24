%% Tau seperation
%  axes = feedback amp, feedback phase, intensity
%  found in 'vfolds.m' (I think) data in 'folds_main.mat'
%  found in 'folds_low_tau.m' data in 'tau06.mat'
%  found in 'folds_low_tau.m' data in 'tau04.mat'

%% Standard tau (0.8 ns)
clear;
load(strcat(specific_bif_data_dir(), ...
    'folds_main.mat'))

figure;
for i = 1:numel(folds)
    plot_branch3( folds{i}, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'color', 'k', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)
end

%% lower tau (0.6 ns)
clear;
load(strcat(specific_bif_data_dir(), ...
    'folds_tau06.mat'))

figure;
for i = 1:numel(hopf_branches)
    plot_branch3( hopf_branches{i}, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'color', 'c', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)
end

plot_branch3( phase_famp05, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'nunst_color', phase_famp05.nunst, ...
    'add_2_gcf', 1)


for i = 1:numel(folds)
    plot_branch3( folds{i}, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'color', 'b', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)
end

%% lowest tau (0.4 ns)
clear;
load(strcat(specific_bif_data_dir(), ...
    'folds_tau04.mat'))


figure;
for i = 1:numel(hopf_branches)
    plot_branch3( hopf_branches{i}, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'color', 'c', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)
end

plot_branch3( phase_famp05, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'nunst_color', phase_famp05.nunst, ...
    'add_2_gcf', 1)

for i = 1:numel(folds)
    plot_branch3( folds{i}, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'color', 'r', ...
    'PlotStyle', { 'LineStyle', '-', 'Marker', '.' }, ...
    'add_2_gcf', 1)
end

%% plotting

key = {'k', 'b', 'r'};
hold on
h = zeros(numel(key), 1);
for i = 1:numel(h)
    h(i) = plot(NaN, NaN, strcat('o', key{i}));
end
lgd = legend(h, '0.8 ns', '0.6 ns', '0.4 ns','Location','southeast');
title(lgd,'\tau_{fb}');

zlabel('Strong Field Intensity')
title('Fold Continuations')
saveas(gca, strcat(data_directory(), 'tau_fb_seperation.png'))

%% for finding the hopfs, used on the altered paramters

% %% find hopfs
% hopf_branches = cell(2,1);
% inds_hopf = [phase_famp05.indHopf(1), phase_famp05.indHopf(end)]; 
% 
% [amp,~] = SetupStst( ...
%     funcs, ...
%     'contpar',[param.feed_ampli.index, param.omega1.index], ...
%     'corpar',[param.omega1.index],...
%     'x', phase_famp05.point(inds_hopf(1) + 5).x, ...
%     'parameter', phase_famp05.point(inds_hopf(1) + 5).parameter,...
%     opt_inputs{:},...
%     st_amp{:});
% 
% amp = bcont( funcs, amp, 1, 40 );
% amp = branch_stability(funcs, amp);
% 
% [hopf_branches{1}, ~]=SetupHopf( ...
%     funcs, ...
%     amp, ...
%     amp.indHopf(1), ...
%     'contpar', ...
%     [param.feed_phase.index, param.feed_ampli.index, param.omega1.index], ...
%     'dir', param.feed_ampli.index, ...
%     opt_inputs{:},...
%     st_bif{:}); 
% 
% hopf_branches{1} = bcont(funcs, hopf_branches{1}, 50, 300);
% 
% % This might not be following cuz the starting index is shifted? idk 
% [amp,~] = SetupStst( ...
%     funcs, ...
%     'contpar',[param.feed_ampli.index, param.omega1.index], ...
%     'corpar',[param.omega1.index],...
%     'x', phase_famp05.point(inds_hopf(2)).x, ...
%     'parameter', phase_famp05.point(inds_hopf(2)).parameter,...
%     opt_inputs{:},...
%     st_amp{:});
% 
% amp = bcont( funcs, amp, 1, 40 );
% amp = branch_stability(funcs, amp);
% 
% [hopf_branches{2}, ~]=SetupHopf( ...
%     funcs, ...
%     amp, ...
%     amp.indHopf(1), ...
%     'contpar', ...
%     [param.feed_phase.index, param.feed_ampli.index, param.omega1.index], ...
%     'dir', param.feed_ampli.index, ...
%     opt_inputs{:},...
%     st_bif{:}); 
% 
% [amp,~] = SetupStst( ...
%     funcs, ...
%     'contpar',[param.feed_ampli.index, param.omega1.index], ...
%     'corpar',[param.omega1.index],...
%     'x', phase_famp05.point(inds_hopf(2) - 9).x, ...
%     'parameter', phase_famp05.point(inds_hopf(2) - 9).parameter,...
%     opt_inputs{:},...
%     st_amp{:});
% 
% amp = bcont( funcs, amp, 1, 40 );
% amp = branch_stability(funcs, amp);
% 
% [hopf_branches{3}, ~]=SetupHopf( ...
%     funcs, ...
%     amp, ...
%     amp.indHopf(1), ...
%     'contpar', ...
%     [param.feed_phase.index, param.feed_ampli.index, param.omega1.index], ...
%     'dir', param.feed_ampli.index, ...
%     opt_inputs{:},...
%     st_bif{:}); 
% 
% hopf_branches{3} = bcont(funcs, hopf_branches{3}, 300, 50);
% 
% hopf_branches{2}.point(end).x(1);
% hopf_branches{3}.point(end-32).x(1);
% 
% for i = 1:32
%     hopf_branches{3}.point(end) = [];
% end
% 
% hopf_branches{3} = br_rvers(hopf_branches{3});
% 
% for i = 1:numel(hopf_branches{3}.point)
%     hopf_branches{2}.point(end+1) = hopf_branches{3}.point(i);
% end