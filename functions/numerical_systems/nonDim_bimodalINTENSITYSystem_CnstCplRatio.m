function [ f ] = nonDim_bimodalINTENSITYSystem_CnstCplRatio(  ...
    Es, EsTau, Iw, IwTau, rho, n, ...
    feed_phaseMatrix, feed_ampliMatrix, ... 
    kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, ...
    beta, J_p, eta, ...
    tau_r, S_in, V, Z_QD, n_bg, ...
    tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
    feed_phase, feed_ampli, tau_fb, ...
    epsi0, hbar, e0, ...
    alpha_par )
%Non-Dimensional, human-friendly, bimodal, phase-amplitude coupled system
%of differential equations. The matrix inputs determine the relative
%coupling values for feed_phase, feed_ampli and tau_fb in the following
%manner. A value of '1' in the matrix implies 100% scaling of the relevant
%feedback parameter to that particular coupling.
%
%Note: In this function, the weak field is in terms of intensity!! Also,
%the matrix values are fixed. alpha_par = 0.
%
%   value * [ss = 1, sw = 0; ws = 0, ww = 0]
%
%   The non-dim values go as follows:
%       E_j(t) = sqrt(epsi_ss*epsi_tilda)^(-1) * E_j(q)
%       rho(t) = rho(q)
%       n_r(t) = (S_in * tau_sp)^(-1) * n_r(q)
%       t = tau_sp * q
%
%   Input:
%     Es, EsTau, Iw, IwTau, rho, n, ...
%     feed_phaseMatrix, feed_ampliMatrix, ...
%     kappa_s, kappa_w, mu_s, mu_w, epsi_ss, epsi_ww, epsi_sw, epsi_ws, ...
%     beta, J_p, eta, ...
%     tau_r, S_in, V, Z_QD, n_bg, ...
%     tau_sp, T_2, A, hbar_omega, epsi_tilda, J, ...
%     feed_phase, feed_ampli, tau_fb, ...
%     epsi0, hbar, e0, ...
%     alpha_par
%
%   Output:
%       [real(EsDot);imag(EsDot);IwDot;rhoDot;nDot]

%% Calculate, organize useful vals
epsi_bg = n_bg^2;

% FIXED FEEDBACK MATRIX
alpha_par = 0;
feed_ampliMatrix = [1, 0; 0, 0];

% Set coupling ratios
feed_phase = feed_phase*feed_phaseMatrix;
feed_ampli = feed_ampli*feed_ampliMatrix;

% Organize
css = feed_phase(1,1);
csw = feed_phase(1,2);
cws = feed_phase(2,1);
cww = feed_phase(2,2);

kss = feed_ampli(1,1);
ksw = feed_ampli(1,2);
kws = feed_ampli(2,1);
kww = feed_ampli(2,2);

gs = ((norm(mu_s)^2)*T_2/(2*hbar^2)) ...
    * ( ...
    1 ...
    + epsi_ss/epsi_ss*Es.*conj(Es) ...
    + epsi_sw/epsi_ss*Iw ...
    ).^(-1);

gw = ((norm(mu_w)^2)*T_2/(2*hbar^2)) ...
    * ( ...
    1 ...
    + epsi_ws/epsi_ss*Es.*conj(Es) ...
    + epsi_ww/epsi_ss*Iw ...
    ).^(-1);

%% Differential Eqns

EsDot = (1 - 1.0i*alpha_par) ...
    *( ...
    ( tau_sp ...
    * (hbar_omega/(epsi0*epsi_bg)) * (2*Z_QD/V) ...
    * gs ...
    .* (2*rho-1) ...
    .* Es ) ...
    - tau_sp * kappa_s * Es ... 
    ) ...
    + tau_sp * kappa_s * exp(1.0i*css) * kss * EsTau ... + tau_sp * kappa_s * exp(1.0i*csw) * ksw * EwTau ...
    + epsi_ss * epsi_tilda * beta * hbar_omega / (epsi0*epsi_bg) ...
    * (2*Z_QD/V) * rho.*(Es./(Es.*conj(Es)) ...
    );

IwDot = (1 - 1.0i*alpha_par) ...
    *( ...
    ( tau_sp ...
    * (hbar_omega/(epsi0*epsi_bg)) * (2*Z_QD/V) ...
    * gw ...
    .* (2*rho-1) ...
    .* (2*Iw) ) ...
    - tau_sp * kappa_w * 2*Iw ... 
    ) ... + tau_sp * kappa_w * exp(1.0i*cww) * kww * EwTau ... + tau_sp * kappa_w * exp(1.0i*cws) * kws * EsTau ...
    + epsi_ss * epsi_tilda * beta * hbar_omega / (epsi0*epsi_bg) ...
    * (2*Z_QD/V) * rho * 2;

rhoDot = ( ...
    - (tau_sp/(epsi_ss * epsi_tilda)) * gs.*(2*rho-1).*(Es.*conj(Es)) ...
    - (tau_sp/(epsi_ss * epsi_tilda)) * gw.*(2*rho-1).*Iw ...
    - rho ...
    + n.*(1-rho) ...
    );

nDot = ( ...
    tau_sp^2 * S_in * eta / (e0*A) * (J-J_p) ...
    - tau_sp * S_in * (2*Z_QD/A)*n.*(1-rho) ...
    - tau_sp * n/tau_r ...
    );

f = cat(1, ...
    real(EsDot), imag(EsDot), ...
    real(IwDot), ...
    real(rhoDot), ...
    real(nDot) );


end
