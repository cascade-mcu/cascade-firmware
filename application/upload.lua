function upload(log, cb)
    require('obtainWifi')
    
   obtainWifi(function()
        package.loaded['obtainWifi'] = nil
        obtainWifi = nil
        require('gql')

        address, netmask, gateway = wifi.sta.getip()
        
        gql({
            query = [[
              mutation($sensorId: ID!, $value: Float!, $readingTime: DateTime!) {
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

                createWifiLog(
                    device: {
                      connect: {
                        id: $deviceId
                      },
                    },
                    hostname: $hostname,
                    address: $address,
                    netmask: $netmask,
                    gateway: $gateway,
                    mac: $mac,
                    rssi: $rssi
                ) {
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