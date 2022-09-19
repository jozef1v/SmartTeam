options.RequestMethod = 'auto'
%?from='2022-03-30T11:00:00Z'&interval=56&to='2022-03-30T11:30:00Z'
temp_top1 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}/timeseries?from=2022-05-09T20:30:00Z&interval=60&to=2022-05-10T11:00:00Z",options)
t1 = [temp_top1.data.value]';
temp_bot1 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}/timeseries?from=2022-05-09T20:30:00Z&interval=60&to=2022-05-10T11:00:00Z",options)
temp_bot1 = [temp_bot1.data.value]';
%%
temp_top = [t1];
temp_bot = [temp_bot1];
avg_temp = (temp_top+temp_bot)/2;

%% heating
options.RequestMethod = 'auto'
%options.KeyName = 'propertyValue'
%options.KeyValue = '{"value":20}'
heat = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{a9f0e988-ad3d-4d77-b0aa-a82abfc70c58}/timeseries?from=2022-05-09T20:30:00Z&interval=60&to=2022-05-10T11:00:00Z",options)

% h1 = (100*(ones(32,1)));
% h2 = (142*(ones(111,1)));
% h3 = (42*(ones(61,1)));
% h4 = (255*(ones(50,1)));
% h5 = (75*(ones(45,1)));
% h6 = zeros(25,1);
% h7 = (190*(ones(181,1)));
% h = [h1;h2;h3;h4;h5;h6;h7];
experiment_duration
Nstep = length( durat );
my_values = [heat.data.value]';
h = [];
for k = 1 : Nstep
   h = [ h; my_values(k) * ones( durat(k), 1 ) ];
end
h

%% definovanie vstupov a výstupov
U = [h];
Y = [avg_temp];


