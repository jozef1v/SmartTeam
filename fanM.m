
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fanM
%
% Vesna greenhouse cooling and ventilation control file. M-file consists of
% a function that provides the value of the control input and the current
% value of the sampling period as output parameters. It requires a series
% of input parameters that are used to perform an control input of
% temperature decrease and ventilation. The system controller is
% two-position (on/off), based on maximum permitted temperature,
% respectively ventilation cycle.
%
% List of input variables
%   T_avg         - average value of the temperature in the greenhouse.
%   t_max         - maximum permitted temperature in the greenhouse.
%   fan_on        - turn on the fan.
%   fan_off       - turn off the fan.
%   count         - iteration cycle number.
%
% List of output variables
%   u             - control input.
%   countN        - 'count' variable update.
%
% List of local variables
%   val           - ventilation control input (float type).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,countN] = fanM(T_avg,t_max,fan_on,fan_off,count)

% Control output (on/off)
if count >= 120
    val = fan_on;
    if count >= 135
        count = -1;
        if T_avg >= t_max
            val = fan_on;
        else
            val = fan_off;
        end
    end
elseif T_avg >= t_max
    val = fan_on;
else
    val = fan_off;
end
u = struct('value',val);

% Rewrite count
countN = count;

end
