
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
%   credentials2  - loads e-mail credentials.
%   errors        - checks the type of error that occurred.
%
% List of input variables
%   id            - identifier of the emerged fault (anomaly).
%
% List of local variables
%   data          - user e-mail credentials.
%   destin        - recipient's e-mail address.
%   email_times   - container (dictionary) of latest sent e-mail times.
%   fileID        - loaded file ID.
%   keySet        - array of e-mail specifications.
%   msg           - description of the detected anomaly (e-mail message).
%   password      - sender's password.
%   source        - sender's e-mail address.
%   subj          - type of the detected anomaly (e-mail subject).
%   valueSet1     - array of e-mail titles.
%   valueSet2     - array of e-mail bodies.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function email2(id)

% Load Gmail credentials
data = credentials2;

source = data{1};
destin = data{2};
password = data{3};

% Set up Gmail SMTP
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',password);

% Gmail server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable', 'true' );
props.setProperty('mail.smtp.socketFactory.port','465');

% Message description
fileID = fopen('emails2/email2_spec.txt','r');
keySet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

fileID = fopen('emails2/email2_title.txt','r');
valueSet1 = split(fscanf(fileID,'%s'),";");
fclose(fileID);

fileID = fopen('emails2/email2_body.txt','r');
valueSet2 = split(fscanf(fileID,'%s'),";");
fclose(fileID);

subj = containers.Map(keySet,valueSet1);
msg = containers.Map(keySet,valueSet2);

% Anomaly display
fprintf(2,strcat(subj(id),' (',string(datetime('now')),')\n',msg(id),'\n\n'))

% Send anomaly detection e-mail
for spec = 1:5
    try
        % Load latest sent e-mail time
        email_times = containers.Map(fieldnames(jsondecode(fileread("emails2/email2_time.json"))), ...
        struct2cell(jsondecode(fileread("emails2/email2_time.json"))));

        % Check period of e-mail sending & rewrite latest sent e-mail time
        if datetime(email_times(id))+minutes(10) <= datetime('now')
            email_times(id) = string(datetime('now'));
            fileID = fopen("emails2/email2_time.json",'w');
            fprintf(fileID,'%s',jsonencode(cell2struct(values(email_times)', ...
                keys(email_times)'),PrettyPrint=true));
            fclose(fileID);
            sendmail(destin,subj(id),msg(id));
        end
        break
    catch
        pause(5)

        % Terminates after 5 attempts
        if spec == 5
            errors('email',spec);
            break
        end
    end
end

end
