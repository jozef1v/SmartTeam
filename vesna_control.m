%==========================================================================
%{
    NAVRHY
    - vsetky udaje sa budu musiet nacitavat z Cloudu
        - nacitanie bude musiet byt robene v kazdom cykle
        - App Team tam bude posielat z webstranky po prihlaseni admina
          akcne zasahy, zmeny limitov parametrov, ziadene veliciny,
          setpointy, konstanty PID regulatorov, casy ventilacii ...
        - budeme musiet dorobit nove premenne na Cloude, kam App Team budu
          zasielat svoje data
        - cela Initialization okrem 'count','e_p','u_p'
    - prerobit PID regulator do tvaru diskretneho riadenia
    u(k) = (Kp + Ki*Δt + Kd/Δt) * e(k) - (Kp + 2*Kp/Δt) * e(k-1) +
            + Kd/Δt * e(k-2) + u(k-1)
%}

%{
    STAHOVANIE VACSIEHO MNOZSTVA DAT

    options = reconnect;
    data = webread("https://api2.arduino.cc/iot/v2/things/" + ...
        "{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/" + ...
        "{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}/timeseries?" + ...
        "from=2022-10-03T00:00:00Z&interval=300&to=2022-10-06T00:00:00Z", ...
        options);
    casy = datetime(cell2mat({data.data.time}'),'InputFormat', ...
        'yyyy-MM-dd''T''HH:mm:ssxxx', 'TimeZone','Europe/Bratislava', ...
        'Format','yyyy-MM-dd HH:mm:ss');
    hodnoty = [data.data.value]';

    interval - casovy usek medzi 2 meraniami (udavany v sekundach)
    - maximalny pocet dat, ktore vie na jedno spustenie prikazu webread
    stiahnut je 1000
%}
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% vesna_control
%
% Vesna intelligent greenhouse control script. The M-file provides
% comprehensive management of several measured variables of the system,
% including diagnostics of problems, detection of emerging anomalies,
% or providing support to the user.
% 
% Variables control in the code is decentralized. Each controlled variable
% (temperature, humidity, lighting), including door position detection and
% greenhouse ventilation, is based on external functions, creating
% individual control sections of Vesna. They download (measured) data from
% the Arduino Cloud, where the values of control output are subsequently
% sent. In the event of a malfunction, the user is informed by e-mail.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

% Ventilation cycle counter
count = 0;

% Control error e(k-1) and control output e(k-1) at previous sample
e_p = 0;
u_p = 0;

%% Control loop
while(true)

% Current time
t_h = datetime('now').Hour;

% Load data from Arduino API Cloud
[time_up,time_down,light_on,light_off,light_int,t_max,w_day,w_night, ...
    fan_on,fan_off,h_max,h_min,hum_on,hum_off,samp,door_val,light_val, ...
    T_top,T_bot,hum_bme,hum_dht] = load_data;

%% Door management

% Door position control function
skip = doorM(door_val);

% Skips control loop
if skip
    continue
end

%% Light management

% Light intensity control function
light_S = lightM(light_val,time_up,time_down,light_int,light_on, ...
                light_off,t_h);

%% Temperature management

% Temperature heating control function
[t_val,u_p,e_p] = heatM(T_top,T_bot,time_up,time_down,w_day,w_night, ...
                        e_p,u_p,t_h);

%% Humidity management

% Humidity control function
[hum_val,hum_S] = humidM(hum_bme,hum_dht,h_max,h_min,hum_on,hum_off);

%% Fan management

% Fan control function
[fan_S,count] = fanM(t_val,t_max,fan_on,fan_off,count);

%% Control anomalies

% Anomalies detection function
anomalies(t_val,t_max,fan_S,fan_on,fan_off,count,hum_val,h_max,h_min, ...
    hum_S,hum_on,hum_off,t_h,time_up,time_down,light_val,light_int, ...
    light_S,light_on,light_off);

%% Loop settings

% Sampling period time
pause(samp)

% Number of sampling periods
count = count + 1;

end
