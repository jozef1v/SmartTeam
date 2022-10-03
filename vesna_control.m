%==========================================================================
%{
    NAVRHY

    - dorobenie servisneho rezimu - ak padne connection/wifi pripojenie
    pocas riadenia, pripadne prud, nech vypne vsetky pristroje (skusim sa
    Peta spytat, ci by sa tam nedalo nainstalovat nejake cervene svetielko
    na baterku, ktore by pocas toho blikalo)
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
    - treba najst ten retardovany subor, ktory sa kryje s MATLAB builtinom

%}

%{
    STAHOVANIE VACSIEHO MNOZSTVA DAT

    reconnect
    data = webread("https://api2.arduino.cc/iot/v2/things/" + ...
        "{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/" + ...
        "{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}/timeseries?" + ...
        "from=2019-01-01T00:00:00Z&interval=100&to=2022-09-30T00:00:00Z", ...
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

% Ventilation cycle counter & control period
count = 0;
sampling = 60;

% Initialization of control error e(k-1) and control output e(k-1)
% at previous sample
e_p = 0;
u_p = 0;

%% Control loop
while(true)

% Current time
t_h = datetime('now').Hour;

%% Door management

% Door position control function
[door_val,skip,options] = doorM(hum_off,fan_off,options);

% Skips control loop
if skip == 1
    continue
end

%% Light management

% Light intensity control function
[light_val,light_act,options] = lightM(t_h,time_up,time_down,light_int, ...
                                        light_on,light_off,options);

%% Temperature management

% Temperature heating control function
[t_val,t_act,u_p,e_p,options] = heatM(t_h,time_up,time_down,w_day, ...
                                      w_night,e_p,u_p,options);

%% Humidity management

% Humidity control function
[HUM_avg,hum_act,options] = humidM(h_max,h_min,hum_on,hum_off,options);

%% Fan management

% Fan control function
[fan_act,count,options] = fanM(t_val,t_max,fan_on,fan_off,count,options);

%% Control anomalies

% Anomalies detection function
options = anomalies(t_val,t_max,fan_act,fan_on,fan_off,count, ...
                    HUM_avg,h_max,h_min,hum_act,hum_on,hum_off, ...
                    t_h,time_up,time_down,intensity_of_light,light_int, ...
                    light_act, light_on,light_off,options);

%% Loop settings

% Sampling period time
pause(sampling)

% Number of sampling periods
count = count + 1;

end
