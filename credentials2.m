
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CREDENTIALS2
% 
% File to load user send e-mail credentials (from external file
% credentials2.txt). M-file consists of a function that does not require
% input parameters. It provides the 'data' parameter which contains the
% basic user e-mail credentials.
%
% List of output variables
%   data          - credentials to send an e-mail (sender's & recipient's
%                   e-mails, sender's e-mail password).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = credentials2

% Load set-up
DELIMITER = ' ';
HEADERLINES = 6;

% Load data
dataR = importdata("credentials2.txt", DELIMITER, HEADERLINES);
[~,name] = fileparts("credentials2.txt");
dataM.(matlab.lang.makeValidName(name)) = dataR;
data = {dataM.credentials2{2};dataM.credentials2{4};dataM.credentials2{6}};

end
