
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% device
%
% Device type assignment file. The M-file consists of an external function
% that provides the 'ID' access key of the device being used as an output.
% It requires an input parameter 'id' which contains the identifier of
% the device in question.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ID = device(id)
    
% Devices ID
keySet = {'sensor','actuator'};
valueSet = {'95e254c8-7421-4d0e-bcb6-4b6991c87b4f'; % Sensors
        'aa0190a8-9312-4a17-8842-25a1dd483860'};    % Actuators
device = containers.Map(keySet,valueSet);

ID = device(id);

end
