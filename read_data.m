
function data_val = read_data(pid,id,error_key,options)

% Initialize counter 'spec' & request method
spec = 0;
options.RequestMethod = 'auto';

% Load last data value
while(true)
    try
        data = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device(pid),"}/properties/{",d_type(id),"}"),options);
        break
    catch
        spec = spec + 1;
        options = errors(error_key,spec);
        options.RequestMethod = 'auto';
    end
end
data_val = data.last_value;

end