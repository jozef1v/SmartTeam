
% email 1x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% doorM
%
% Vesna greenhouse door position detection file. M-file consists of
% an external function that provides the current door position value
% 'door_val'. It requires a series of input parameters that are used to
% send a notification e-mail, alerting the admin of a faulty (anomalous)
% position of the door. In this case, the control is switched to stand-by
% mode - temperature, humidity and ventilation control are switched off,
% lighting is switched on.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [door_val,skip,optionsN] = doorM(hum_off,fan_off,options)

% Load door position data
options.RequestMethod = 'auto';
try
    door = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        device('sensor'),"}/properties/{",d_type('door'),"}"),options);
catch
    options = errors('door');
end
door_val = door.last_value;

% Security during the open house (only light is functioning)
if door_val == 1

    % Send heating off data
    options.RequestMethod = 'put';
    propertyValue = struct('value', 0);
    try
        webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device('actuator'),"}/properties/{",d_type('heating'),"}/publish"), ...
            propertyValue,options);
    catch
        options = errors('heating');
    end

    % Send pump off data
    options.RequestMethod = 'put';
    propertyValue_h = struct('value',hum_off);
    try
        webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device('actuator'),"}/properties/{",d_type('pump'),"}/publish"), ...
            propertyValue_h,options);
    catch
        options = errors('pump');
    end
    
    % Send fan off data
    options.RequestMethod = 'put';
    propertyValue = struct('value',fan_off);
    try
        webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device('actuator'),"}/properties/{",d_type('fan'),"}/publish"), ...
            propertyValue,options);
    catch
        options = errors('fan');
    end

    % Send notification email
    try
        email2('door');
    catch
        options = errors('email');
    end

    % Skip control loop
    skip = 1;

else
    
    % Unskip control loop
    skip = 0;

end

% Rewrite options
optionsN = options;

end
