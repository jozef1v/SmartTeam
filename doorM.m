
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

function skip = doorM(door_val)

% Security during the open house (only light is functioning)
if door_val

    % Interrupt control loop
    send_data(0,hum_off,fan_off,0,0,0,door_val);

    % Send notification email
    try
        email2('door');
    catch
        errors('email');
    end

    % Skip control loop
    skip = 1;

else
    
    % Unskip control loop
    skip = 0;

end

end
