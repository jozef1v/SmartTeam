

options.RequestMethod = 'auto'
%?from='2022-03-30T11:00:00Z'&interval=56&to='2022-03-30T11:30:00Z'
temp_top1 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}/timeseries?from=2022-04-05T18:38:00Z&interval=10&to=2022-04-06T03:30:00Z",options)
t1 = [temp_top1.data.value]';

temp_top2 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}/timeseries?from=2022-04-05T21:24:30Z&interval=10&to=2022-04-06T03:30:00Z",options)
t2 = [temp_top2.data.value]';

temp_top3 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}/timeseries?from=2022-04-06T00:11:00Z&interval=10&to=2022-04-06T03:30:00Z",options)
t3 = [temp_top3.data.value]';

temp_top4 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}/timeseries?from=2022-04-06T02:57:30Z&interval=10&to=2022-04-06T03:30:00Z",options)
t4 = [temp_top4.data.value]';

temp_bot1 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}/timeseries?from=2022-04-05T18:38:00Z&interval=10&to=2022-04-06T03:30:00Z",options)
temp_bot1 = [temp_bot1.data.value]';

temp_bot2 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}/timeseries?from=2022-04-05T21:24:30Z&interval=10&to=2022-04-06T03:30:00Z",options)
temp_bot2 = [temp_bot2.data.value]';

temp_bot3 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}/timeseries?from=2022-04-06T00:11:00Z&interval=10&to=2022-04-06T03:30:00Z",options)
temp_bot3 = [temp_bot3.data.value]';

temp_bot4 = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}/timeseries?from=2022-04-06T02:57:30Z&interval=10&to=2022-04-06T03:30:00Z",options)
temp_bot4 = [temp_bot4.data.value]';


%%
temp_top = [t1;t2;t3;t4];
temp_bot = [temp_bot1; temp_bot2; temp_bot3; temp_bot4];
avg_temp = (temp_top+temp_bot)/2;

%% fans
options.RequestMethod = 'auto'
%options.KeyName = 'propertyValue'
%options.KeyValue = '{"value":20}'
fans = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/timeseries?from=2022-04-05T18:38:00Z&interval=10&to=2022-04-06T03:30:00Z",options)

f1 = zeros(1917,1);
f2 = (99*(ones(91,1)));
f3 = (160*(ones(48,1)));
f4 = (249.5*(ones(1139,1)));
f = [f1;f2;f3;f4];

%% heating
options.RequestMethod = 'auto'
%options.KeyName = 'propertyValue'
%options.KeyValue = '{"value":20}'
heat = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{a9f0e988-ad3d-4d77-b0aa-a82abfc70c58}/timeseries?from=2022-04-05T18:38:00Z&interval=10&to=2022-04-06T03:30:00Z",options)


h1 = (255*(ones(215,1)));
h2 = (11.5*(ones(608,1)));
h3 = (50*(ones(409,1)));
h4 = (255*(ones(909,1)));
h5 = zeros(1054,1);
h = [h1;h2;h3;h4;h5];

%% lighting 
options.RequestMethod = 'auto'
%options.KeyName = 'propertyValue'
%options.KeyValue = '{"value":20}'
light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/timeseries?from=2022-04-05T18:38:00Z&interval=10&to=2022-04-06T03:30:00Z",options)


l1 = (7*(ones(897,1)));
l2 = (69*(ones(587,1)));
l3 = (141*(ones(718,1)));
l4 = zeros(993,1);
l = [l1;l2;l3;l4];

%% definovanie vstupov a výstupov
U = [f, h, l];
Y = [avg_temp];
%% plot vstupov
time = 0:1:3194 ;

figure
plot(time, f );
hold on 
plot(time, l);
hold on
plot(time, h)
