%% Setup General
clear;

% Load and find the relevant phases
load(strcat(data_directory(), 'specific_bifurcations/rephases.mat'))

% make compatible
phases = rephases;

% steps
st_cur = { ...
    'step', 0.003, ...
    'max_step', [param.J.index,0.006, param.omega1.index,0.1], ...
    'newton_max_iterations', 10, ...
    'max_bound', [param.J.index,1], ...
    'min_bound', [param.J.index,], ...
    'halting_accuracy', 1e-10, ...
    'minimal_accuracy', 1e-8};
st_amp = steps_amp(param, ...
    'step', 0.002, ...
    'max_step', [param.feed_ampli.index,0.002, param.omega1.index,0.1], ...
    'max_bound', [param.feed_ampli.index, 0.5]);
st_bif_cur_amp = steps_bif(param, ...
    'step', 0.001, ...
    'max_step', [param.feed_ampli.index, 0.003, param.J.index,0.003, param.omega1.index,0.01], ...
    'max_bound', [param.feed_ampli.index,0.5, param.J.index, 1400e-6], ...
    'min_bound', [param.feed_ampli.index,-0.1, param.J.index, 180e-6]);
st_phase = steps_phase(param, ...
    'max_step', [param.feed_phase.index,pi/16, param.omega1.index,0.1]);

%% Feedback Amplitude Cont, phase 0, find nearby points
famp_cur560_phase0 = cell(1,6);

for i = 1:numel(famp_cur560_phase0)
    argval = 0;
    ind = branch_pts_near_param_at_unique_intensity(phases{i}, param.feed_phase.index, argval, 0.05, 3e-3);
    
    for j = 1:numel(ind)
        ptx = phases{i}.point(ind(j)).x;
        ptpar = phases{i}.point(ind(j)).parameter;
        ptpar(param.feed_phase.index) = argval;

        [famp_cur560_phase0{j, i},~] = SetupStst( ...
            funcs, ...
            'contpar',[param.feed_ampli.index, param.omega1.index], ...
            'corpar',[param.omega1.index],...
            'x', ptx, ...
            'parameter', ptpar,...
            opt_inputs{:},...
            st_amp{:});
    end
end

shape = size(famp_cur560_phase0);
for i = 1:shape(1)
    for j = 1:shape(2)
        if ~isempty(famp_cur560_phase0{i,j})
            famp_cur560_phase0{i, j} = bcont( funcs, ...
                                              famp_cur560_phase0{i, j}, ...
                                              200, ...
                                              200 );
            famp_cur560_phase0{i, j} = branch_stability(funcs, ...
                                                        famp_cur560_phase0{i, j});
        end
    end
end



%% Feedback Amplitude Cont, phase pi/2
famp_cur560_phasePi2 = cell(1,6);

for i = 1:numel(famp_cur560_phasePi2)
    argval = pi/2;
    ind = branch_pts_near_param(phases{i}, param.feed_phase.index, argval, 0.1);
    ptx = phases{i}.point(ind(1)).x;
    ptpar = phases{i}.point(ind(1)).parameter;
    ptpar(param.feed_phase.index) = argval;
    
    for j = 1:numel(ind)
        ptx = phases{i}.point(ind(j)).x;
        ptpar = phases{i}.point(ind(j)).parameter;
        ptpar(param.feed_phase.index) = argval;

        [famp_cur560_phasePi2{j, i},~] = SetupStst( ...
            funcs, ...
            'contpar',[param.feed_ampli.index, param.omega1.index], ...
            'corpar',[param.omega1.index],...
            'x', ptx, ...
            'parameter', ptpar,...
            opt_inputs{:},...
            st_amp{:});
    end
end

shape = size(famp_cur560_phasePi2);
for i = 1:shape(1)
    for j = 1:shape(2)
        if ~isempty(famp_cur560_phasePi2{i,j})
            famp_cur560_phasePi2{i, j} = bcont( funcs, ...
                                              famp_cur560_phasePi2{i, j}, ...
                                              200, ...
                                              200 );
            famp_cur560_phasePi2{i, j} = branch_stability(funcs, ...
                                                        famp_cur560_phasePi2{i, j});
        end
    end
end


%% Feedback Amplitude Cont, phase pi
famp_cur560_phasePi = cell(1,6);

for i = 1:numel(famp_cur560_phasePi)
    argval = pi;
    ind = branch_pts_near_param(phases{i}, param.feed_phase.index, argval, 0.1);
    ptx = phases{i}.point(ind(1)).x;
    ptpar = phases{i}.point(ind(1)).parameter;
    ptpar(param.feed_phase.index) = argval;
    
    [famp_cur560_phasePi{i},~] = SetupStst( ...
        funcs, ...
        'contpar',[param.feed_ampli.index, param.omega1.index], ...
        'corpar',[param.omega1.index],...
        'x', ptx, ...
        'parameter', ptpar,...
        opt_inputs{:},...
        st_amp{:});
    
    famp_cur560_phasePi{i} = bcont( funcs, famp_cur560_phasePi{i}, ...
                            200, 200 );
    famp_cur560_phasePi{i} = branch_stability(funcs, famp_cur560_phasePi{i});
end

%% save
if 1
    save(strcat(data_directory(), 'specific_bifurcations/ecms'), ...
    'funcs', ...
    'famp_cur560_phase0', ...
    'param', ...
    'st_amp', ...
    'st_bif_cur_amp', ...
    'st_cur', ...
    'st_phase', ...
    'opt_inputs')
end


%% plot phase 0
figure;
shape = size(famp_cur560_phase0);
for i = 1:shape(1)
    for j = 1:shape(2)
        if ~isempty(famp_cur560_phase0{i,j})
            plot_branch3( famp_cur560_phase0{i,j}, ...
                param, ...
                'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
                'nunst_color', famp_cur560_phase0{i,j}.nunst, ...
                'add_2_gcf', 1)
        end
    end
end

%% plot phase pi/2
figure;
shape = size(famp_cur560_phasePi2);
for i = 1:shape(1)
    for j = 1:shape(2)
        if ~isempty(famp_cur560_phasePi2{i,j})
            plot_branch3( famp_cur560_phasePi2{i,j}, ...
                param, ...
                'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
                'nunst_color', famp_cur560_phasePi2{i,j}.nunst, ...
                'add_2_gcf', 1)
        end
    end
end


%% plot phase pi
figure;
shape = size(famp_cur560_phasePi);
for i = 1:shape(1)
    for j = 1:shape(2)
        if ~isempty(famp_cur560_phasePi{i,j})
            plot_branch3( famp_cur560_phasePi{i,j}, ...
                param, ...
                'axes_indParam', {param.feed_phase.index, param.feed_ampli.index, 'x1'}, ...
                'nunst_color', famp_cur560_phasePi{i,j}.nunst, ...
                'add_2_gcf', 1)
        end
    end
end

