function upload(log, cb)
    require('obtainWifi')
    
   obtainWifi(function()
        package.loaded['obtainWifi'] = nil
        obtainWifi = nil
        require('gql')

        address, netmask, gateway = wifi.sta.getip()
        
        gql({
            query = [[
              mutation(
                $sensorId: ID!, 
                $value: Float!, 
                $readingTime: DateTime!, 
                $deviceId: ID!,
                $ssid: String,
                $hostname: String,
                $address: String,
                $netmask: String,
                $gateway: String,
                $mac: String,
                $rssi: Float,
              ) {
                createLog(data: {
                  sensor: {
                    connect: {
                      id: $sensorId
                    },
                  },
                  value: $value,
                  readingTime: $readingTime,
                }) {
                  id
                }

                createWifiLog(data: {
                    device: {
                      connect: {
                        id: $deviceId
                      },
                    },
                    ssid: $ssid,
                    hostname: $hostname,
                    address: $address,
                    netmask: $netmask,
                    gateway: $gateway,
                    mac: $mac,
                    rssi: $rssi
                }) {
                    id
                }
              }
            ]],
            variables = {
                sensorId = log.sensorId,
                value = log.value,
                readingTime = log.readingTime,
                deviceId = CASCADE_DEVICE_ID,
                ssid = WIFI_SSID,
                hostname = wifi.sta.gethostname(),
                address = address,
                netmask = netmask,
                gateway = gateway,
                mac = wifi.sta.getmac(),
                rssi = wifi.sta.getrssi(),
            },
        }, cb)

        package.loaded['gql'] = nil
        gql = nil
        cb = nil
        log = nil
        
        address = nil
        netmask = nil
        gateway = nil
    end)

    package.loaded['obtainWifi'] = nil
    obtainWifi = nil
end