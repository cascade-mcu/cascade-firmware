function obtainWifi(cb)
   if wifi.sta.status() == wifi.STA_GOTIP then
        print('Already have wifi')
        cb()
        cb = nil
        return
    end

    wifi.setmode(wifi.STATION)
    wifi.sta.config({ ssid= WIFI_SSID, pwd = WIFI_PWD, auto = false })

    wifi.sta.connect(function()
        print('Connecting...')
        tmr.alarm(1, 1000, 1, function()
            if wifi.sta.getip() == nil then
                print("IP unavailable, Waiting...")
            else
                tmr.stop(1)
   
                print('Connected!')
                
                require('syncTime')
                syncTime(cb)
                package.loaded['syncTime'] = nil
                syncTime = nil
                cb = nil
            end
        end)
    end)
end
