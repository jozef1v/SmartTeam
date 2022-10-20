
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
%   source        - sender's e-mail address.
%   destination   - recipient's e-mail address.
%   password      - sender's password.
%   setpref       - set preference of Outlook SMTP.
%   props         - set Outlook server properties.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function email2(id)

%{
    Outlook credentials
    - requires:
        - source        - sender's email
        - password      - sender's password
        - destination   - recipient's email
%}
source = 'controlvesna2022@outlook.com';
destination = 'xvarganj@stuba.sk';
password = '22Vcontrol';

% Set up Outlook SMTP
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp-mail.outlook.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',password);

% Outlook server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable', 'true' );
props.setProperty('mail.smtp.socketFactory.port','587');

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
    'Fan control problem was detected. The temperature in Vesna is over the maximal recommended value, but the fan power supply is turned off. Check the functionality of the temperature sensor or the fan.', ...
    'Fan control problem was detected. The temperature in Vesna is bellow the maximal recommended value, but the fan power supply is turned on. Check the functionality of the temperature sensor or the fan.', ...
    'Failing ventilation problem was detected. During the Vesnaʼs ventilation cyclus, the fan power supply was disconnected. Check the functionality of the fan.', ...
    'Pump control problem was detected. The humidity in Vesna is over the maximal recommended value, but the pump power supply is turned on. Check the functionality of the humidity sensor or the pump.', ...
    'Pump control problem was detected. The humidity in Vesna is bellow the minimal recommended value, but the pump power supply is turned off. Check the functionality of the humidity sensor or the pump.', ...
    'Lighting control problem was detected. The light intensity during the daytime lighting mode is sufficient, but the lighting is switched on. Check the functionality of the light sensor or the lighting.', ...
    'Lighting control problem was detected. The light intensity during the daytime lighting mode is insufficient, but the lighting is switched off. Check the functionality of the light sensor or the lighting.', ...
    'Lighting control problem was detected. The lighting in night-time mode should by turned off, but was detected to be turned on. Check the functionality of the lighting.'};

subj = containers.Map(keySet,valueSet1);
msg = containers.Map(keySet,valueSet2);

% Anomaly display
fprintf(2,strcat(subj(id),' (',string(datetime('now')),')\n',msg(id),'\n\n'))

% Send e-mail
for spec = 1:5
    try
        sendmail(destination,subj(id),msg(id));
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
