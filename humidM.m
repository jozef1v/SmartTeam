
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% humidM
%
% Vesna greenhouse humidity control file. M-file consists of an external
% function that provides the mean value of the humidity 'HUM_avg' and
% the control output of the humidity controller (pump) 'pump_act' as output
% parameters. It requires a series of input parameters that are used to
% perform a control output (settings) of the humidity of the greenhouse
% interior. The system control is two-position (on/off).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [HUM_avg,pump_act,optionsN] = humidM(h_max,h_min,hum_on, ...
                                              hum_off,options)

% Load BMME humidity data
options.RequestMethod = 'auto';
try
    hum_bme = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('sensor'),"}/properties/{",d_type('bmmeH'),"}"),options);
catch
    options = errors('bmmeH');
end
HUM_bme = hum_bme.last_value;

% Load DHT humidity data
options.RequestMethod = 'auto';
try
    hum_dht = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('sensor'),"}/properties/{",d_type('dhtH'),"}"),options);
catch
    options = errors('dhtH');
end
HUM_dht = hum_dht.last_value;

% Average humidity
HUM_avg = (HUM_bme + HUM_dht)/2;

% Set humidity control (on/off)
if HUM_avg >= h_max
   propertyValue = struct('value',hum_off);
elseif HUM_avg <= h_min
   propertyValue = struct('value',hum_on);
end

% Send pump control data
options.RequestMethod = 'put';
try
    pump_act = propertyValue.value;
    webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('actuator'),"}/properties/{",d_type('pump'),"}/publish"), ...
        propertyValue,options);
catch
    options = errors('pump');
end

% Rewrite options
optionsN = options;

end
