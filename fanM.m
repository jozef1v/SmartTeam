
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fanM
%
% Vesna greenhouse cooling and ventilation control file. M-file consists of
% an external function that provides the value of the control output of
% the controller 'fan_act' and the current value of the sampling period
% 'countN' as output parameters. It requires a series of input parameters
% that are used to perform an control output (setting) of temperature
% reduction and ventilation. The system control is two-position (on/off).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fan_act,countN,optionsN] = fanM(T_avg,t_max,fan_on,fan_off, ...
                                          count,options)

% Set fan control (on/off)
if T_avg >= t_max
    propertyValue = struct('value',fan_on);
    count = 0;
else
    propertyValue = struct('value',fan_off);
end
if count >= 120
    propertyValue = struct('value',fan_on);
    if count == 135
        count = 0;
    end
end

% Send fan control data
options.RequestMethod = 'put';
try
    fan_act = propertyValue.value;
    webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('actuator'),"}/properties/{",d_type('fan'),"}/publish"), ...
        propertyValue,options);
catch
    options = errors('fan');
end

% Rewrite options and count
optionsN = options;
countN = count;

end
