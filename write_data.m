
function write_data(pid,id,data,error_key,options)

% Initialize counter 'spec' & request method
spec = 0;
options.RequestMethod = 'put';

% Send heating off data
while(true)
    try
        webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device(pid),"}/properties/{",d_type(id),"}/publish"), ...
            data,options);
        break
    catch
        spec = spec + 1;
        options = errors(error_key,spec);
        options.RequestMethod = 'put';
    end
end

end