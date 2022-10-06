
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lightM
%
% Vesna greenhouse lighting control file. M-file consists of an external
% function that provides the value of the light intensity 'light_val' and
% the control output of the lighting controller 'light_act' as output
% parameters. It requires a series of input parameters that are used to
% perform a control output (settings) of the lighting of the greenhouse
% interior. The system control is two-position (on/off).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [light_val,light_act,optionsN] = lightM(t_h,time_up,time_down, ...
                                       light_int,light_on,light_off, ...
                                       options)

% Load light intensity value
options.RequestMethod = 'auto';
try
    light = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('sensor'),"}/properties/{",d_type('light'),"}"),options);
catch
    options = errors('light');
end
light_val = light.last_value;

% Set light control (on/off)
if t_h >= time_down && t_h < time_up
    if light_val > light_int
        propertyValue = struct('value',light_off);
    else
        propertyValue = struct('value',light_on);
    end
else
    propertyValue = struct('value',light_off);
end

% Send light control data
options.RequestMethod = 'put';
try
    light_act = propertyValue.value;
    webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('actuator'),"}/properties/{",d_type('lighting'),"}/publish"), ...
        propertyValue,options);
catch
    options = errors('lighting');
end

% Rewrite options
optionsN = options;

end
