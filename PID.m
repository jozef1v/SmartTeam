
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PID
%
% PID temperature controller of the Vesna greenhouse. M-file containing
% the external function contains the values of the current 'e' and
% the previous 'e_p' control error, as well as the previous value of
% the control output 'u_p' as an input argument. The output from this
% function is the actual controlled output 'u' for the given signal
% sampling period.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u = PID(e,e_p,u_p)

    % Controller constants
    Z_r = 45;
    T_i = 6;
    T_s = 1;

    % Control output
    u_d = Z_r*(e-e_p)+ Z_r/T_i*T_s*e;
    u = u_p+u_d;
end