function getSensors(cb)
    print('Getting sensors')

    require('obtainWifi')
    
    obtainWifi(function()
        require('gql')
        
        gql({
          query = [[
            query($deviceId: ID!) {
                device(where: {
                  id: $deviceId
                }) {
                    logEveryInSeconds
                    uploadEveryInSeconds
                    sensors {
                        id
                        sensorType {
                            name
                        }
                    }
                }
            }
            ]],
          variables = {
            deviceId = CASCADE_DEVICE_ID
          }
        }, function(response)
            require('sleepWifi')
            sleepWifi()
            package.loaded['sleepWifi'] = nil
            sleepWifi = nil

            cb(response)
            cb = nil
            response = nil
            print('Got sensors')
        end)

        package.loaded['gql'] = nil
        gql = nil
    end)

    package.loaded['obtainWifi'] = nil
    obtainWifi = nil
end
