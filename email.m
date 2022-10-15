
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EMAIL
%
% File for sending error e-mail messages. M-file consists of a function
% that does not provide an output parameter. It requires an 'id' input
% parameter that is used to detect errors associated with Vesna control.
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
%   id            - identifier of the emerged error. Specifies the type of
%                   e-mail to send about the corresponding error.
%
% List of local variables
%   subj          - type of the detected error (e-mail subject).
%   msg           - description of the detected error (e-mail message).
%   source        - sender's e-mail address.
%   destination   - recipient's e-mail address.
%   password      - sender's password.
%   setpref       - set preference of Outlook SMTP.
%   props         - set Outlook server properties.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function email(id)

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
keySet = {'connect', ...
          'email', ...
          'light', ...
          'lighting', ...
          'door', ...
          'heating', ...
          'pump', ...
          'fan', ...
          'tempT', ...
          'tempB', ...
          'bmmeH', ...
          'dhtH'};
valueSet1 = {'Arduino Cloud Connection Error', ... 
    '...', ...
    'Light Error', ...
    'Lighting Error', ...
    'Door Error', ...
    'Heating Error', ...
    'Pump Error', ...
    'Fan Error', ...
    'Top Temperature Error', ...
    'Bottom Temperature Error', ...
    'BMME Humidity Error', ...
    'DHT Humidity Error'};
valueSet2 = {'Connection to Arduino Cloud failed - no server response. New connection to the server is required.', ...
    '...', ...
    'Unable to load/send light intensity data from/to Cloud. Check connection, Arduino Cloud or lighting power supply.', ...
    'Unable to load/send lighting power supply data from/to Cloud. Check connection, Arduino Cloud or lighting power supply.', ...
    'Unable to load/send door position data from/to Cloud. Check connection, Arduino Cloud or door sensor.', ...
    'Unable to load/send heating power supply data from/to Cloud. Check connection, Arduino Cloud or heating power supply.', ...
    'Unable to load/send pump power supply data from/to Cloud. Check connection, Arduino Cloud or pump power supply.', ...
    'Unable to load/send fan power supply data from/to Cloud. Check connection, Arduino Cloud or fan power supply.', ...
    'Unable to load/send top temperature data from/to Cloud. Check connection, Arduino Cloud or temperature sensor.', ...
    'Unable to load/send bottom temperature data from/to Cloud. Check connection, Arduino Cloud or temperature sensor.', ...
    'Unable to load/send BMME humidity data from/to Cloud. Check connection, Arduino Cloud or BMME sensor.', ...
    'Unable to load/send DHT humidity data from/to Cloud. Check connection, Arduino Cloud or DHT sensor.'};

subj = containers.Map(keySet,valueSet1);
msg = containers.Map(keySet,valueSet2);

% Send notification e-mail
for spec = 1:5
    try
        sendmail(destination,subj(id),msg(id));
        fprintf(strcat('Error notification e-mail was sent to your mail address (', ...
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
