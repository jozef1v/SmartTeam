
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% email2
%
% File for sending e-mail messages. M-file consists of an external function
% that does not provide an output parameter. It requires the input
% parameter 'id' which contains the identifier of the identified anomaly
% message being sent.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function email2(id)

%{
    Gmail credentials
    - requires:
        - source        - sender's email
        - password      - sender's password
        - destination   - recipient's email
%}
source = 'Vesna.STU.2021@gmail.com';
destination = 'dodoodod1221@gmail.com';
password = 'Sklenik2022';

% Set up Gmail SMTP
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',password);

% Gmail server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

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

% Initialize counter 'spec'
spec = 0;

% Send email
while(true)
    try
        sendmail(destination,subj(id),msg(id));
        fprintf('Anomaly notification email was sent to your mail address.\n\n')
        break
    catch
        
        % Terminates after 5 attempts
        if spec> 5
            break
        end
        spec = spec + 1;
        errors('email',0);
    end
end

end
