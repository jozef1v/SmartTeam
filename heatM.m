
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% heatM
%
% Vesna greenhouse temperature control file. M-file consists of an external
% function that provides the value of the control output of the controller
% 't_act' and the mean value of the temperature 't_val' as output
% parameters. It requires a series of input parameters that are used to
% perform an control output (setting) of temperature regulation. System
% uses the PID type of control, and therefore it is important to correctly
% set the discrete values of the previous control errors 'e_p' and
% the control outputs 'u_p'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [temp_S,t_val,u_pN,e_pN] = heatM(T_top,T_bot,time_up,time_down, ...
                                    w_day,w_night,e_p,u_p,t_h)

% Average temperature
t_val = (T_top + T_bot)/2;

% Temperature setpoint
if t_h >= time_down && t_h < time_up
    w = w_day;
else 
    w = w_night;
end

% Control error
e =  w-t_val;

% Control output
[u,u_pN,e_pN] = PID_con(e,e_p,u_p);
temp_S = struct('value',u);

end
