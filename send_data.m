
function send_data(light_S,hum_off,fan_off,temp_S,hum_S,fan_S,door_val)

% Connect to Arduino Cloud
options = reconnect;

%% Door open detection
if door_val

% Send heating off data
write_data('actuator','heating',struct('value',0),'heating',options);

% Send pump off data
write_data('actuator','pump',struct('value',hum_off),'pump',options);

% Send fan off data
write_data('actuator','fan',struct('value',fan_off),'fan',options);

%% Data send to Arduino API Cloud
else

% Send light control data
write_data('actuator','lighting',light_S,'lighting',options);

% Send heating control data
write_data('actuator','heating',temp_S,'heating',options);

% Send pump control data
write_data('actuator','pump',hum_S,'pump',options);

% Send fan control data
write_data('actuator','fan',fan_S,'fan',options);

end
