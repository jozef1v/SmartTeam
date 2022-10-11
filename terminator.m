
function terminator

% Connect to Arduino Cloud
options = reconnect;

% Send heating off data
write_data('actuator','heating',struct('value',0),'heating',options);

% Send pump off data
write_data('actuator','pump',struct('value',0),'pump',options);

% Send fan off data
write_data('actuator','fan',struct('value',0),'fan',options);

% Send light off data
write_data('actuator','lighting',struct('value',0),'lighting',options);

imshow('terminator.jpg')

end