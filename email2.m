
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EMAIL2
%
% File for sending anomaly e-mail messages. M-file consists of a function
% that does not provide an output parameter. It requires an 'id' input
% parameter that is used to detect unexpected faults (anomalies) associated
% with Vesna control.
%
% List of used functions
%   errors        - check the type of error that occurred. If an error
%                   occurs, it tries to resolve it and informs the user. It
%                   requires error 'id' and 'spec' parameters.
%   sendolmail    - specifies the structure of sending an e-mail. It
%                   requires parameters 'to' (recipient's e-mail address),
%                   'subject' (e-mail subject), 'body' (e-mail message).
%
% List of input variables
%   id            - identifier of the emerged fault (anomaly). Specifies
%                   the type of e-mail to send about the corresponding
%                   anomaly.
%
% List of local variables
%   subj          - type of the detected anomaly (e-mail subject).
%   msg           - description of the detected anomaly (e-mail message).
%   destination   - recipient's e-mail address.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function email2(id)

%{
    Outlook credentials
    - requires:
        - destination   - recipient's outlook e-mail
%}
destination = 'jozefvargan1234@outlook.com';

% Message description
keySet = {'door', ...
          'fan1', ...
          'fan2', ...
          'vent', ...
          'pump1', ...
          'pump2', ...
          'light1', ...
          'light2', ...
          'night'};
valueSet1 = {'Opened Door', ...
    'Fan Control Anomaly', ...
    'Fan Control Anomaly', ...
    'Ventilation Anomaly', ...
    'Pump Control Anomaly', ...
    'Pump Control Anomaly', ...
    'Lighting Control Anomaly', ...
    'Lighting Control Anomaly', ...
    'Night Mode Anomaly'};
valueSet2 = {'Vesna door was detected as open. For the sake of the quality of the control, it is recommended to check and close them.', ...
    'Fan control problem was detected. The temperature in Vesna rises, but the fan power supply is turned off. To reduce the temperature, it is recommended to check the functionality of the temperature sensor and the fan.', ...
    'Fan control problem was detected. The temperature in Vesna is within the normal ange, but the fan power supply is turned on. To prevent Vesna overheating, it is recommended to check the functionality of the temperature sensor and the fan.', ...
    'Failing ventilation problem was detected. During the Vesnaʼs 15-minute ventilation cyclus at 2-hour intervals, the fan power supply was disconnected. With regard to the quality of the control, it is recommended to check the functionality of the fan.', ...
    'Pump control problem was detected. The humidity in Vesna rises, but the pump power supply is turned on. To prevent Vesna overmoistering, it is recommended to check the functionality of the humidity sensor and the pump.', ...
    'Pump control problem was detected. The humidity in Vesna decreases, but the pump power supply is turned off. To prevent Vesna undermoistering, it is recommended to check the functionality of the humidity sensor and the pump.', ...
    'Lighting control problem was detected. The light intensity during the daytime lighting mode is sufficient, but the lighting is switched on. To reduce the load on the power supply, it is recommended to check the functionality of the light sensor and the lighting.', ...
    'Lighting control problem was detected. The light intensity during the daytime lighting mode is insufficient, but the lighting is switched off. To increase the lighting in Vesna, it is recommended to check the functionality of the light sensor and the lighting.', ...
    'Nighttime lighting control problem was detected. The lighting in nighttime mode is turned off, but the light intensity was detected. To eliminate the error, it is recommended to check the functionality of the light sensor and the lighting.'};

subj = containers.Map(keySet,valueSet1);
msg = containers.Map(keySet,valueSet2);

% Anomaly display
fprintf(2,strcat(subj(id),' (',string(datetime('now')),')\n',msg(id),'\n\n'))

% Send e-mail
for spec = 1:5
    try
        sendolmail(destination,subj(id),msg(id));
        fprintf(strcat('Anomaly notification e-mail was sent to your mail address (', ...
            string(datetime('now')),').\n\n'))
        break
    catch
        pause(3)
        % Terminates after 5 attempts
        if spec == 5
            errors('email',spec);
            break
        end
    end
end

end

% Create e-mail function
function sendolmail(to,subject,body)

% Create object and set parameters using MS Outlook
h = actxserver('outlook.Application');
mail = h.CreateItem('olMail');
mail.Subject = subject;
mail.To = to;
mail.BodyFormat = 'olFormatHTML';
mail.HTMLBody = body;

% Send message and release object
mail.Send;
h.release;

end
