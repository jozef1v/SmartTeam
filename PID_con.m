
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PID_con
%
% PID temperature controller of the Vesna greenhouse. M-file consists of
% a function that provides a new value of control input 'u', as well as
% values of control input input and error in k-1 period (including control
% error in k-2 period) as output parameters. It requires a series of input
% parameters to set-up current temperature control input.
%
% List of input variables
%   e             - current control error.
%   e_p1          - control error in in k-1 sampling period.
%   e_p2          - control error in in k-2 sampling period.
%   u_p1          - control input in in k-1 sampling period.
%   Z_r           - proportional gain of the PID controller.
%   T_i           - integral gain of the PID controller.
%   T_d           - derivative gain of the PID controller.
%   T_s           - sampling period (in minutes).
%
% List of output variables
%   u             - current control input.
%   u_pN1         - new control input in in k-1 sampling period.
%   e_pN1         - new control error in in k-1 sampling period.
%   e_pN2         - new control error in in k-2 sampling period.
%
% List of local variables
%   u_d           - control input difference (control increase).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,u_pN1,e_pN1,e_pN2] = PID_con(e,e_p1,e_p2,u_p1,Z_r,T_i,T_d,T_s)

% Reset control error & output
u_pN1 = u_p1;
e_pN2 = e_p1;
e_pN1 = e_p;

% Control output
u_d = Z_r*(e-e_p1 + T_s/T_i*e + T_d/T_s*(e-2*e_p1+e_p2));
u = u_p1 + u_d;

% Control output saturation
if u > 255
    u = 255;
elseif u < 0
    u = 0;
end

end
