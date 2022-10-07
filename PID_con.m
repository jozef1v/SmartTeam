
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PID_con
%
% PID_con temperature controller of the Vesna greenhouse. M-file containing
% the external function contains the values of the current 'e' and
% the previous 'e_p' control error, as well as the previous value of
% the control output 'u_p' as an input argument. The output from this
% function is the actual controlled output 'u' for the given signal
% sampling period.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,u_pN,e_pN] = PID_con(e,e_p,u_p)

    % Controller constants
    Z_r = 45;
    T_i = 6;
    T_s = 1;

    % Control output
    u_d = Z_r*(e-e_p)+ Z_r/T_i*T_s*e;
    u = u_p+u_d;

    % Control output saturation
    if u > 255
        u = 255;
    elseif u < 0 
        u = 0;
    end

    % Reset control error & output (e(k)->e(k-1) & u(k)->u(k-1))
    u_pN = u;
    e_pN = e;

% u(k) = (Kp + Ki*Δt + Kd/Δt) * e(k) - (Kp + 2*Kp/Δt) * e(k-1) +
%             + Kd/Δt * e(k-2) + u(k-1)

end