%% fbAmp_curAmp given weak only feedback

feedPhaseMat = [1, 1; 1, 1];
feedAmpMat = [0, 0; 0, 1];

% SetupParams
param = setup_params_nonDim_CnstCplRatio(...
    'save',0, ...
    'populate_wrkspc',0, ...
    'alpha_par',0, ...
    'feed_ampli', 0.15, ...
    'feed_ampliMatrix', feedAmpMat, ...
    'feed_phase',0, ...
    'feed_phaseMatrix', feedPhaseMat, ...
    'clear',0,...
    'J',560e-6,...
    'tau_fb', 0.8);

%% solver
sys_4solver = @(x)nonDim_bimodalINTENSITYSystem_CnstCplRatio_StrIsInt(...
    x(1,1,:) , x(1,2,:) ,... % Is, IsTau
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