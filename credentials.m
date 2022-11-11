
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CREDENTIALS
% 
% File to load Arduino Cloud connection credentials (from external file
% credentials.txt). M-file consists of a function that does not require
% input parameters. It provides the 'data' parameter which contains the
% basic Arduino Cloud connection credentials.
%
% List of output variables
%   data          - credentials to connect to the Arduino API Cloud (id &
%                   secret).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = credentials

% Load set-up
DELIMITER = ' ';
HEADERLINES = 4;

% Load data
dataR = importdata("credentials.txt", DELIMITER, HEADERLINES);
[~,name] = fileparts("credentials.txt");
dataM.(matlab.lang.makeValidName(name)) = dataR;
data = {dataM.credentials{2};dataM.credentials{4}};

end
