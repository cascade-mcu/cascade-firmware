function upload(log, cb)
    require('obtainWifi')
    
   obtainWifi(function()
        package.loaded['obtainWifi'] = nil
        obtainWifi = nil
        require('gql')
        
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
              }
            ]],
            variables = log,
        }, cb)

        package.loaded['gql'] = nil
        gql = nil
        cb = nil
        log = nil
    end)

    package.loaded['obtainWifi'] = nil
    obtainWifi = nil
end