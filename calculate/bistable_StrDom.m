%% Parameters and DDE Solver

clear;

feedPhaseMat = [1, 1; 1, 1];
feedAmpMat = [1, 0; 0, 1];

param = setup_params_nonDim_CnstCplRatio(...
    'save', 0, ...
    'populate_wrkspc', 0, ...
    'alpha_par', 0, ...
    'feed_ampli', 0.15, ...
    'feed_ampliMatrix', feedAmpMat, ...
    'feed_phase', 0, ...
    'feed_phaseMatrix', feedPhaseMat, ...
    'clear', 0,...
    'J', 560e-6,...
    'tau_fb', 0.8);

dde23_soln = solver([1e-9;0;1e-9;0;0;0], ...
    [0,10], ...
    param, ...
    'plot', 1, ...
    'dde23_options', ddeset('RelTol', 10^-8)); %  'OutputFcn', @odeplot

%% Path Continuation

funcs = init_funcs(param);

[phase_stst, nunst_phase_stst, ind_fold_phase_stst, ind_hopf_phase_stst] = ... 
    init_branch(funcs, ...
    dde23_soln.y(:,end), ...
    param.feed_phase.index, 225, ...
    param, ...
    'max_step',[param.feed_phase.index, (1)*pi/32], ...
    'minimal_real_part', -1, ...
    'reverse', 1, ...
    'plot_prog', 0);

% phase_stst = br_rvers(phase_stst);
% phase_stst = br_contn(funcs, ...
%     phase_stst, ...
%     branch_length, ...
%     'plotaxis',AX_branch_stst);

%% Fold Continuation
fold_branches = containers.Map('KeyType', 'double', 'ValueType', 'any');

for i = 1:length(ind_fold_phase_stst)
    try
        fold_branches(ind_fold_phase_stst(i)) = bifurContin_FoldHopf( ...
            funcs, ... 
            phase_stst, ...
            ind_fold_phase_stst(i), ...
            [param.feed_phase.index, param.feed_ampli.index], 100, ...
            param,...
            'plot_prog', 0, ...
            'save',0);
    catch ME
        switch ME.identifier
            case 'br_contn:start'
                warning(ME.message);
                warning(strcat('During branch=',fold_active_branch_name));
                fold_branches(ind_fold_phase_stst(i)) = ME;
            otherwise
                rethrow(ME)
        end
    end
end


%% Plot all
figure
for k = fold_branches.keys
    i = k{1};
    plot_branch(fold_branches(i), param, 'add_2_gcf', 1, 'color','r');
end

