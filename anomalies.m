
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% anomalies
%
% File for detecting the anomalies that have arisen. M-file consists of
% an external function that provides 'options' as an output parameter. It
% requires a series of input parameters that are used to detect unexpected
% errors (anomalies) associated with Vesna control.
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
    anomaly_D('fan1');
end

% Internal temperature of Vesna is normal, the fan does respond.
if T_avg < t_max && fan_act == fan_on && count < 120
    anomaly_D('fan2');
end

% Vesna ventilation is malfunctioning.
if count >= 120 && count < 135 && fan_act == fan_off
    anomaly_D('vent');
end

%% PUMP CONTROL ANOMALIES

% Internal humidity of Vesna is increased, the pump does respond.
if HUM_avg >= h_max && hum_act == hum_on && count < 120
    anomaly_D('pump1');
end

% Internal humidity of Vesna is decreased, the pump does not respond.
if HUM_avg <= h_min && hum_act == hum_off && count < 120
    anomaly_D('pump2');
end

%% LIGHTING CONTROL ANOMALIES

% Lighting is switched on during the day with sufficient light intensity.
if t_h >= time_down && t_h < time_up && light_val > light_int && light_act == light_on
    anomaly_D('light1');
end

% Lighting is switched off during the day with insufficient light intensity.
if t_h >= time_down && t_h < time_up && light_val <= light_int && light_act == light_off
    anomaly_D('light2');
end

% Lighting is switched off during the day with insufficient light intensity.
if (t_h < time_down && t_h >= time_up) && light_act == light_on
    anomaly_D('night');
end

end
