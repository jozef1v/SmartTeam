
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% heatM
%
% Vesna greenhouse temperature control file. M-file consists of a function
% that provides the value of the control input and error in current and
% previous sampling pariod (control error even in k-2 period) and the mean
% value of the measured temperature. It requires a series of input
% parameters that are used to perform a control input of temperature
% regulation. System uses the PID type of controller.
%
% List of used functions
%   PID_con       - incremental proportional-integral-derivative type of
%                   controller.
%
% List of input variables
%   T_top         - temperature at the top of the greenhouse.
%   T_bot         - temperature at the bottom of the greenhouse.
%   time_up       - time to switch off daylight lighting and switch to
%                   night temperature control.
%   time_down     - time to switch on daylight lighting and switch to
%                   day temperature control.
%   w_day         - daytime temperature setpoint.
%   w_night       - night-time temperature setpoint.
%   e_p           - control error in previous time sampling.
%   u_p           - control input in previous time sampling.
%   t_h           - current time hour.
%
% List of output variables
%   u             - current control input.
%   e             - current control error.
%   u_pN1         - new control input in in k-1 sampling period.
%   e_pN1         - new control error in in k-1 sampling period.
%   e_pN2         - new control error in in k-2 sampling period.
%   t_val         - average value of the temperature in the greenhouse.
%
% List of local variables
%   w             - current temperature setpoint.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,e,u_pN1,e_pN1,e_pN2,t_val] = heatM(T_top,T_bot,time_up, ...
    time_down,w_day,w_night,e_p1,e_p2,u_p1,t_h,Z_r,T_i,T_d,T_s)

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
[u,u_pN1,e_pN1,e_pN2] = PID_con(e,e_p1,e_p2,u_p1,Z_r,T_i,T_d,T_s);
u = struct('value',u);
e = struct('value',e);
u_pN1 = struct('value',u_pN1);
e_pN1 = struct('value',e_pN1);
e_pN2 = struct('value',e_pN2);

end
