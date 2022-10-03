
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% heatM
%
% Vesna greenhouse temperature control file. M-file consists of an external
% function that provides the value of the control output of the controller
% 't_act' and the mean value of the temperature 'T_avg' as output
% parameters. It requires a series of input parameters that are used to
% perform an control output (setting) of temperature regulation. System
% uses the PID type of control, and therefore it is important to correctly
% set the discrete values of the previous control errors 'e_p' and
% the control outputs 'u_p'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [T_avg,t_act,u_pN,e_pN,optionsN] = heatM(t_h,time_up,time_down, ...
                                                  w_day,w_night,e_p,u_p, ...
                                                  options)

% Load top temperature data
options.RequestMethod = 'auto';
try
    t_top = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        'sensor',"}/properties/{",type('tempT'),"}"),options);
catch
    options = errors('tempT');
end
T_top = t_top.last_value;

% Load bottom temperature data
options.RequestMethod = 'auto';
try
    t_bot = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
        'sensor',"}/properties/{",type('tempB'),"}"),options);
catch
    options = errors('tempB');
end
T_bot = t_bot.last_value;

% Average temperature
T_avg = (T_top + T_bot)/2;

% Temperature setpoint
if t_h >= time_down && t_h < time_up
    w = w_day;
else 
    w = w_night;
end

% Control error
e =  w-T_avg;

% Control output
u = PID(e,e_p,u_p);

% Control output saturation
if u > 255
    u = 255;
elseif u < 0 
    u = 0;
end 

% Reset control error & output (e(k)->e(k-1) & u(k)->u(k-1))
u_pN = u;
e_pN = e;

% Send heating control data
options.RequestMethod = 'put';
propertyValue = struct('value',u);
try
    webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            'actuator',"}/properties/{",type('heating'),"}/publish"), ...
            propertyValue,options);
catch
    options = errors('heating');
end
t_act = propertyValue.value;

% Rewrite options
optionsN = options;

end
