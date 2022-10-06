
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% anomalies
%
% File for detecting the anomalies that have arisen. M-file consists of
% an external function that provides 'options' as an output parameter. It
% requires a series of input parameters that are used to detect unexpected
% errors (anomalies) associated with Vesna control.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function optionsN = anomalies(T_avg,t_max,fan_act,fan_on,fan_off,count, ...
                   HUM_avg,h_max,h_min,hum_act,hum_on,hum_off, ...
                   t_h,time_up,time_down,intensity_of_light,light_int, ...
                   light_act, light_on,light_off,options)

%% FAN CONTROL ANOMALIES

% Internal temperature of Vesna is increased, the fan does not respond.
if T_avg >= t_max && fan_act == fan_off && count < 120
    try
        email2('fan1');
    catch
        options = errors('email');
    end
end
% Internal temperature of Vesna is normal, the fan does respond.
if T_avg < t_max && fan_act == fan_on && count < 120
    try
        email2('fan2');
    catch
        options = errors('email');
    end
end
% Vesna ventilation is malfunctioning.
if count >= 120 && count < 135 && fan_act == fan_off
    try
        email2('vent');
    catch
        options = errors('email');
    end
end

%% PUMP CONTROL ANOMALIES

% Internal humidity of Vesna is increased, the pump does respond.
if HUM_avg >= h_max && hum_act == hum_on && count < 120
    try
        email2('pump1');
    catch
        options = errors('email');
    end
end
% Internal humidity of Vesna is decreased, the pump does not respond.
if HUM_avg <= h_min && hum_act == hum_off && count < 120
    try
        email2('pump2');
    catch
        options = errors('email');
    end
end

%% LIGHTING CONTROL ANOMALIES

% Lighting is switched on during the day with sufficient light intensity.
if t_h >= time_down && t_h < time_up && intensity_of_light > light_int && light_act == light_on
    try
        email2('light1');
    catch
        options = errors('email');
    end
end
% Lighting is switched off during the day with insufficient light intensity.
if t_h >= time_down && t_h < time_up && intensity_of_light <= light_int && light_act == light_off
    try
        email2('light2');
    catch
        options = errors('email');
    end
end
% Lighting is switched off during the day with insufficient light intensity.
if (t_h < time_down && t_h >= time_up) && light_act == light_on
    try
        email2('night');
    catch
        options = errors('email');
    end
end

% Rewrite options
optionsN = options;

end
