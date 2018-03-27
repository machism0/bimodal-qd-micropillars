function [ system ] = set_ddesys( param )
%return ddesys function
system = @(x)nonDim_bimodalINTENSITYSystem_CnstCplRatio(...
    x(1,1,:) + 1i*x(2,1,:), x(1,2,:) + 1i*x(2,2,:),... % Es, EsTau
    x(3,1,:), x(3,2,:),... % Iw, IwTau
    x(4,1,:), ... % rho
    x(5,1,:), ... % n
    param.cplPar.feed_phaseMatrix, ...
    param.cplPar.feed_ampliMatrix, ...
    param.values(1),param.values(2), ...
    param.values(3),param.values(4), ...
    param.values(5),param.values(6), ...
    param.values(7),param.values(8), ...
    param.values(9),param.values(10), ...
    param.values(11),param.values(12), ...
    param.values(13),param.values(14), ...
    param.values(15),param.values(16), ...
    param.values(17),param.values(18), ...
    param.values(19),param.values(20), ...
    param.values(21),param.values(22), ...
    param.values(23),param.values(24), ...
    param.values(25),param.values(26), ...
    param.values(27),param.values(28), ...
    param.values(29)); % Leave out omega


end
