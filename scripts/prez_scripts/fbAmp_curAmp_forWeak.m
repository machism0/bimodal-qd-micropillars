%% fbAmp_curAmp given weak only feedback
% This script generates a bifurcation diagram with fbAmplitude on the y
% axis and current Amplitude on the x axis. It shows the region of
% bistability. (Where both the strong mode and the weak mode have a stable
% solution which dominates the intensity output.) Specifically, this one is
% used for the case where the weak mode feedsback into the weak mode.

feedPhaseMat = [1, 1; 1, 1];
feedAmpMat = [0, 0; 0, 1];

% SetupParams
param = setup_params_nonDim_CnstCplRatio(...
    'save',0, ...
    'populate_wrkspc',0, ...
    'alpha_par',0, ...
    'feed_ampli', 0, ...
    'feed_ampliMatrix', feedAmpMat, ...
    'feed_phase',0, ...
    'feed_phaseMatrix', feedPhaseMat, ...
    'clear',0,...
    'J',120e-6,...
    'tau_fb', 0.8);

%% solver
sys_4solver = @(x)nonDim_bimodalINTENSITYSystem_CnstCplRatio_StrIsInt(...
    x(1,1,:), x(1,2,:) ,... % Is, IsTau
    x(2,1,:) + 1i*x(3,1,:), x(2,2,:) + 1i*x(3,2,:),... % Ew, EwTau
    x(4,1,:), ... % rho
    x(5,1,:), ... % n
    param.cplPar.feed_phaseMatrix, param.cplPar.feed_ampliMatrix, ...
    param.values(1),param.values(2),param.values(3),param.values(4), ...
    param.values(5),param.values(6),param.values(7),param.values(8), ...
    param.values(9),param.values(10),param.values(11),param.values(12), ...
    param.values(13),param.values(14),param.values(15),param.values(16), ...
    param.values(17),param.values(18),param.values(19),param.values(20), ...
    param.values(21),param.values(22),param.values(23),param.values(24), ...
    param.values(25),param.values(26),param.values(27),param.values(28), ...
    param.values(29)); % Leave out omega

lags = param.values(param.tau_fb.index);
hist = [1e-9, 1e-9, 0, 0, 0];
timeSpan = [0, 15];

dde23_soln = dde23( ...
    @(t,y,z)sys_4solver([y,z]),...
    lags,hist,timeSpan,ddeset('RelTol',10^-8, 'OutputFcn', @odeplot));

%% branch
aRot=...
    [0,0, 0,0,0;...
     0,0,-1,0,0;...
     0,1, 0,0,0;...
     0,0, 0,0,0;...
     0,0, 0,0,0];
expRot = @(phi)[...
    1,0,0,0,0; ...
    0,cos(phi),-sin(phi),0,0; ...
    0,sin(phi),cos(phi),0,0; ...
    0,0,0,1,0; ...
    0,0,0,0,1];

rhs = @(x,p)nonDim_bimodalINTENSITYSystem_CnstCplRatio_StrIsInt( ...
    x(1,1,:), x(1,2,:) ,... % Is, IsTau
    x(2,1,:) + 1i*x(3,1,:), x(2,2,:) + 1i*x(3,2,:),... % Ew, EwTau
    x(4,1,:), ... % rho
    x(5,1,:), ... % n
    param.cplPar.feed_phaseMatrix, param.cplPar.feed_ampliMatrix, ...
    p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10),p(11),...
    p(12),p(13),p(14),p(15),p(16),p(17),p(18),p(19),p(20),p(21),...
    p(22),p(23),p(24),p(25),p(26),p(27),p(28),p(29)); % Leave out omega

opt_inputs = {'extra_condition',1,'print_residual_info',0};

funcs = set_rotfuncs( ...
    'sys_rhs',rhs, ... 
    'rotation',aRot, ...
    'exp_rotation',expRot, ... 
    'sys_tau',@()bimodal_sys_tau, ...
    'x_vectorized',true);

stepBoundFBamp = {'step',0.003, ...
    'max_step',[param.feed_ampli.index,0.003], ...
    'newton_max_iterations',10, ...
    'max_bound',[param.feed_ampli.index,2], ...
    'min_bound', [param.feed_ampli.index,-2], ...
    'halting_accuracy',1e-10, ...
    'minimal_accuracy',1e-8};

[branchSTST,~]=SetupStst(funcs, ...
    'contpar',[param.feed_ampli.index, param.omega1.index], ...
    'corpar',[param.omega1.index],...
    'x', dde23_soln.y(:,end), ...
    'parameter',param.values(1:end-1),...
    opt_inputs{:},...
    stepBoundFBamp{:});

branch_length = 150;

figure;
[branchSTST,~,~,~] = br_contn(funcs,branchSTST,branch_length);
% branchSTST = br_rvers(branchSTST);
% [branchSTST,~,~,~] = br_contn(funcs,branchSTST,5);

[branchSTST.nunst,~,~,branchSTST.point] = GetRotStability(branchSTST, ...
    funcs, 1);
branchSTST.indFold = find(abs(diff(branchSTST.nunst))==1);
branchSTST.indHopf = find(abs(diff(branchSTST.nunst))==2);

%% Follow FoldOne

stepBoundFold = { ...
    'step',0.003, ...
    'max_step',[param.feed_ampli.index,0.003], ...
    'newton_max_iterations',10, ...
    'max_bound',[param.feed_ampli.index,2], ...
    'min_bound', [param.feed_ampli.index,-2], ...
    'halting_accuracy',1e-10, ...
    'minimal_accuracy',1e-8};

[foldfuncs,foldOne,~]= SetupRWFold( ...
        funcs, ...
        branchSTST, ...
        branchSTST.indFold(1),...
        'contpar',[param.feed_ampli.index,param.J.index,param.omega1.index], ...
        'dir',param.feed_ampli.index, ...
        opt_inputs{:},...
        stepBoundFold{:}); 

foldBranchLength = 150;
    
foldOne = br_contn(foldfuncs,foldOne,foldBranchLength);
% foldOne = br_rvers(foldOne);
% foldOne = br_contn(foldfuncs,foldOne,foldBranchLength);
% foldOne = br_rvers(foldOne);
% foldOne = br_contn(foldfuncs,foldOne,foldBranchLength);