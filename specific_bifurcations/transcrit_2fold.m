%% Setup General
clear;

% Laser/FB settings
current = 560e-6;
fbAmp = 0.2;
fbPhase = 0;
alpha_par = 0;
tau_fb_par = 0.8;

% feedback matrix settings
feedAmpMat = [1, 0; 0, 0];
feedPhaseMat = [1, 1; 1, 1];

% parameter setup
param = setup_params_nonDim_CnstCplRatio(...
    'save',0, ...
    'J', current, ...
    'feed_ampli',fbAmp, ...
    'feed_ampliMatrix', feedAmpMat, ...
    'feed_phase',fbPhase, ...
    'feed_phaseMatrix', feedPhaseMat, ...
    'tau_fb', tau_fb_par, ...
    'alpha_par',alpha_par, ...
    'clear',0,...
    'populate_wrkspc', 0);

% get funcs
funcs = set_biffuncs(feedPhaseMat, feedAmpMat);
opt_inputs = {'extra_condition',1,'print_residual_info',0, ...
              'plot', 0, 'plot_progress', 0};

% get starting points
weak_time_series = turn_on(param, [1e-9, 0, 1e-9, 0, 0]);
str_time_series = turn_on(param, [0.9^2, 0, 0.01, 0.6, 14]);

% steps
st_amp = steps_amp(param);
st_phase = steps_phase(param);

%% WeakDom init amp
[init_amp_WeakDom,~] = SetupStst( ...
    funcs, ...
    'contpar',[param.feed_ampli.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', weak_time_series.y(:,end), ...
    'parameter',param.values(1:end-1),...
    opt_inputs{:},...
    st_amp{:});

% continue
[init_amp_WeakDom,~,~,~] = br_contn(funcs,init_amp_WeakDom,150);
init_amp_WeakDom = br_rvers(init_amp_WeakDom);
[init_amp_WeakDom,~,~,~] = br_contn(funcs,init_amp_WeakDom,150);

% stability analysis
init_amp_WeakDom = branch_stability(funcs, init_amp_WeakDom);

%% WeakDom phase, short
[short_phase_WeakDom,~] = SetupStst( ...
    funcs, ...
    'contpar',[param.feed_phase.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', init_amp_WeakDom.point(end/2).x, ...
    'parameter',init_amp_WeakDom.point(end/2).parameter,...
    opt_inputs{:},...
    st_phase{:});

% continue
[short_phase_WeakDom,~,~,~] = br_contn(funcs,short_phase_WeakDom,10);

%% WeakDom amp2
[second_amp_WeakDom,~] = SetupStst( ...
    funcs, ...
    'contpar',[param.feed_ampli.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', short_phase_WeakDom.point(5).x, ...
    'parameter', short_phase_WeakDom.point(5).parameter,...
    opt_inputs{:},...
    st_amp{:});

% continue
[second_amp_WeakDom,~,~,~] = br_contn(funcs,second_amp_WeakDom,150);
second_amp_WeakDom = br_rvers(second_amp_WeakDom);
[second_amp_WeakDom,~,~,~] = br_contn(funcs,second_amp_WeakDom,150);

% stability analysis
second_amp_WeakDom = branch_stability(funcs, second_amp_WeakDom);

%% StrDom init amp
[init_amp_StrDom,~] = SetupStst( ...
    funcs, ...
    'contpar',[param.feed_ampli.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', str_time_series.y(:,end), ...
    'parameter',param.values(1:end-1),...
    opt_inputs{:},...
    st_amp{:});

% continue
[init_amp_StrDom,~,~,~] = br_contn(funcs,init_amp_StrDom,100);
init_amp_StrDom = br_rvers(init_amp_StrDom);
[init_amp_StrDom,~,~,~] = br_contn(funcs,init_amp_StrDom,100);

% stability analysis
init_amp_StrDom = branch_stability(funcs, init_amp_StrDom);

% %% Fold from init StrDom
% % Cannot be followed 
% st_bif = steps_bif(param, ...
%     'max_bound', [param.feed_ampli.index,0.5], ...
%     'min_bound', [param.feed_ampli.index,-0.9]);
% 
% [foldfuncs,fold_init_amp_StrDom,~]=SetupRWFold( ...
%     funcs, ...
%     init_amp_StrDom, ...
%     init_amp_StrDom.indFold(2),...
%     'contpar', ...
%     [param.feed_phase.index, param.feed_ampli.index, param.omega1.index], ...
%     'dir',param.feed_ampli.index, ...
%     opt_inputs{:},...
%     st_bif{:}); 
% 
% fold_init_amp_StrDom = bcont( foldfuncs, fold_init_amp_StrDom, 50, 50 );

%% StrDom phase, short
[short_phase_StrDom,~] = SetupStst( ...
    funcs, ...
    'contpar',[param.feed_phase.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', init_amp_StrDom.point(round(end/2)).x, ...
    'parameter',init_amp_StrDom.point(round(end/2)).parameter,...
    opt_inputs{:},...
    st_phase{:});

% continue
[short_phase_StrDom,~,~,~] = br_contn(funcs,short_phase_StrDom,10);

%% StrDom amp2
[second_amp_StrDom,~] = SetupStst( ...
    funcs, ...
    'contpar',[param.feed_ampli.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', short_phase_StrDom.point(5).x, ...
    'parameter', short_phase_StrDom.point(5).parameter,...
    opt_inputs{:},...
    st_amp{:});

% continue
[second_amp_StrDom,~,~,~] = br_contn(funcs,second_amp_StrDom,110);
second_amp_StrDom = br_rvers(second_amp_StrDom);
[second_amp_StrDom,~,~,~] = br_contn(funcs,second_amp_StrDom,110);

% stability analysis
second_amp_StrDom = branch_stability(funcs, second_amp_StrDom);

%% save?
if 1
    % save location
    datadir = strcat(data_directory(), 'specific_bifurcations/');
    while isdir(datadir) == 0
        mkdir(datadir);
    end
    
    save(strcat(datadir, 'transcrit_2fold'))
end


%% Plot Weak
plot_branch3( init_amp_WeakDom, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'nunst_color', init_amp_WeakDom.nunst )

plot_branch3( second_amp_WeakDom, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
     'nunst_color', second_amp_WeakDom.nunst, ...
    'add_2_gcf', 1)

%% Plot Strong
% this one is on the same as the init_amp_WeakDom solution
plot_branch3( init_amp_StrDom, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
    'nunst_color', init_amp_StrDom.nunst, ...
    'add_2_gcf', 1)

plot_branch3( second_amp_StrDom, ...
    param, ...
    'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
     'nunst_color', second_amp_StrDom.nunst, ...
    'add_2_gcf', 1)
