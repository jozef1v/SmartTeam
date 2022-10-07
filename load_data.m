
function [time_up,time_down,light_on,light_off,light_int,t_max,w_day, ...
          w_night,fan_on,fan_off,h_max,h_min,hum_on,hum_off,samp, ...
          door_val,light_val,T_top,T_bot,HUM_bme,HUM_dht] = load_data

% Connect to Arduino Cloud
options = reconnect;

% Daytime mode
time_down = 6;          % Day start
time_up = 20;           % Day end

% Lighting
light_on = 255;         % Light is on
light_off = 0;          % Light is off
light_int = 1500;       % Min. light intensity

% Temperature
t_max = 31;             % Max. admissible temperature
w_day = 29;             % Daytime temperature setpoint
w_night = 26.5;         % Nighttime temperature setpoint

% Fan
fan_off = 0;            % Fan is on
fan_on = 255;           % Fan is off

% Humidity
h_max = 42;             % Min. humidity
h_min = 38;             % Max. humidity
hum_off = 0;            % Pump is on
hum_on = 255;           % Pump is off

% Sampling period time
samp = 60;

% Load door position data
door_val = read_data('sensor','door','door',options);

% Load light intensity value
light_val = read_data('sensor','light','light',options);

% Load top temperature data
T_top = read_data('sensor','tempT','tempT',options);

% Load bottom temperature data
T_bot = read_data('sensor','tempB','tempB',options);

% Load BMME humidity data
HUM_bme = read_data('sensor','bmmeH','bmmeH',options);

% Load DHT humidity data
HUM_dht = read_data('sensor','dhtH','dhtH',options);

end