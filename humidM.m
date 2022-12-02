
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% humidM
%
% Vesna greenhouse humidity control file. M-file consists of a function
% that provides the mean value of the humidity and the control input as
% output parameters. It requires a series of input parameters that are used
% to perform a control input of humidity control. The system controller is
% two-position (on/off), based on the minimum and maximum permitted
% humidity.
%
% List of input variables
%   HUM_bme       - humidity measured by BME680 sensor.
%   HUM_dht       - humidity measured by DHT11 sensor.
%   h_max         - maximum permitted humidity in the greenhouse.
%   h_min         - minimum permitted humidity in the greenhouse.
%   hum_on        - turn on the humidifier.
%   hum_off       - turn off the humidifier.
%
% List of output variables
%   u             - control input.
%   hum_val       - average value of the humidity in the greenhouse.
%
% List of local variables
%   val           - humidity control input (float type).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,hum_val] = humidM(HUM_bme,HUM_dht,h_max,h_min,hum_on,hum_off)

% Average humidity
hum_val = (HUM_bme + HUM_dht)/2;

% Control output (on/off)
if hum_val >= h_max
   val = hum_off;
elseif hum_val <= h_min
   val = hum_on;
else
   val = hum_off;
end
u = struct('value',val);

end
