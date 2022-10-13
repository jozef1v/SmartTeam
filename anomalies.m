
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ANOMALIES
%
% File for detecting the anomalies that have arisen. M-file consists of
% a function that does not provide any output parameter. It requires 
% a series of input parameters that are used to detect unexpected
% errors (anomalies) associated with Vesna control.
%
% List of used functions
%   anomaly_d     - send notification e-mail. It requires specific error
%                   identificator.
%
% List of input variables
%   count         - iteration cycle number.
%   t_h           - current time hour.
%   time_up       - time to switch off daylight lighting and switch to
%                   night temperature control.
%   time_down     - time to switch on daylight lighting and switch to day
%                   temperature control.
%   light_on      - turn on the light.
%   light_off     - turn off the light.
%   light_int     - minimum permitted light intensity.
%   t_max         - maximum permitted temperature in the greenhouse
%                   (regulated by a fan).
%   fan_on        - turn on the fan.
%   fan_off       - turn off the fan.
%   h_max         - maximum permitted humidity in the greenhouse
%                   (regulated by humidifier).
%   h_min         - minimum permitted humidity in the greenhouse
%                   (regulated by humidifier).
%   hum_on        - turn on the humidifier.
%   hum_off       - turn off the humidifier.
%   light_val     - light intensity.
%   light_S       - control input for on/off lighting control.
%   t_val         - average value of the temperature in th greenhouse.
%   hum_S         - control input for on/off humidity control.
%   hum_val       - average value of the humidity in the greenhouse.
%   fan_S         - control input for on/off ventilation control.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function anomalies(T_avg,t_max,fan_S,fan_on,fan_off,count,HUM_avg, ...
                  h_max,h_min,hum_S,hum_on,hum_off,t_h,time_up, ...
                  time_down,light_val,light_int,light_S,light_on,light_off)

% Extract a number from structure
fan_act = fan_S.value;
hum_act = hum_S.value;
light_act = light_S.value;

%% FAN CONTROL ANOMALIES

% Internal temperature of Vesna is increased, the fan does not respond.
if T_avg >= t_max && fan_act == fan_off && count < 120
    anomaly_d('fan1');
end

% Internal temperature of Vesna is normal, the fan does respond.
if T_avg < t_max && fan_act == fan_on && count < 120
    anomaly_d('fan2');
end

% Vesna ventilation is malfunctioning.
if count >= 120 && count < 135 && fan_act == fan_off
    anomaly_d('vent');
end

%% PUMP CONTROL ANOMALIES

% Internal humidity of Vesna is increased, the pump does respond.
if HUM_avg >= h_max && hum_act == hum_on && count < 120
    anomaly_d('pump1');
end

% Internal humidity of Vesna is decreased, the pump does not respond.
if HUM_avg <= h_min && hum_act == hum_off && count < 120
    anomaly_d('pump2');
end

%% LIGHTING CONTROL ANOMALIES

% Lighting is switched on during the day with sufficient light intensity.
if t_h >= time_down && t_h < time_up && light_val > light_int && ...
        light_act == light_on
    anomaly_d('light1');
end

% Lighting is switched off during the day with insufficient light intensity.
if t_h >= time_down && t_h < time_up && light_val <= light_int && ...
        light_act == light_off
    anomaly_d('light2');
end

% Lighting is switched off during the day with insufficient light intensity.
if (t_h < time_down && t_h >= time_up) && light_act == light_on
    anomaly_d('night');
end

end
