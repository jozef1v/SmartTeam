
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ANOMALY_D
%
% File for sending notification e-mails when data faults (anomalies) are
% detected. M-file consists of a function that does not provide any output
% parameter. It requires an 'id' input parameter that is used to detect
% unexpected faults (anomalies) associated with Vesna control.
%
% List of used functions
%   email2        - send notification e-mail about detected control
%                   anomaly. It requires email 'id' parameter.
%
% List of input variables
%   id            - identifier of the emerged fault (anomaly). Specifies
%                   the type of e-mail to send about the corresponding
%                   anomaly.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function anomaly_d(id)

% Send fault (anomaly) e-mail
while(true)
    try
        email2(id);
        break
    catch
        1;
    end
end

end
