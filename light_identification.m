options.RequestMethod = 'auto'
%?from='2022-03-30T11:00:00Z'&interval=56&to='2022-03-30T11:30:00Z'
%light = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}",datetime('now'),options)


%%
r = 1350
while true
        light = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}/timeseries?from=2022-04-28T21:30:00Z&interval=10&to=2022-04-28T23:00:00Z",options)
        %light = properties.properties_v2_show('95e254c8-7421-4d0e-bcb6-4b6991c87b4f','d6653286-1d51-49d0-83b9-0dd6bf6b54fe').last_value
        aktcas = datetime()
        t = [aktcas]';
        
        if t > 6 && t < 20
            print('Riadim')
            print(light)
            e = r - light
            u = e
            if u<0
                u = 0
            else if u>255
                u = 255
            print(u)
            properties.properties_v2_publish('aa0190a8-9312-4a17-8842-25a1dd483860','128d9d60-0c2f-4a58-a3e4-fb833e10bf81',{'value':u})
        else
            print('Neriadim')
            properties.properties_v2_publish('aa0190a8-9312-4a17-8842-25a1dd483860','128d9d60-0c2f-4a58-a3e4-fb833e10bf81',{'value':0})
        time.sleep(3)
            end
        end
 end
