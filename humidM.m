
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% humidM
%
% Vesna greenhouse humidity control file. M-file consists of an external
% function that provides the mean value of the humidity 'hum_val' and
% the control output of the humidity controller (pump) 'pump_act' as output
% parameters. It requires a series of input parameters that are used to
% perform a control output (settings) of the humidity of the greenhouse
% interior. The system control is two-position (on/off).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hum_val,hum_S] = humidM(HUM_bme,HUM_dht,h_max,h_min,hum_on,hum_off)

% Average humidity
hum_val = (HUM_bme + HUM_dht)/2;

% Set humidity control (on/off)
if hum_val >= h_max
   propertyValue = struct('value',hum_off);
elseif hum_val <= h_min
   propertyValue = struct('value',hum_on);
end
hum_S = propertyValue;

end
