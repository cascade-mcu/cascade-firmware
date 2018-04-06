CASCADE_DEVICE_ID = 'cjfmlb3k40can0b825t0wzl5b'
CASCADE_URL = 'https://cascade-backend.herokuapp.com'
SCHEDULE = "* * * * *"

JSON_HEADERS = 'Accept-Encoding: gzip, deflate, br\r\nContent-Type: application/json\r\nAccept: application/json\r\n'

obtainWifi = function(cb) 
    print('Getting wifi...')
    
    wifi.setmode(wifi.STATION)
    wifi.sta.config {ssid="uabnamai", pwd="E7A0A3D980"}
    wifi.sta.connect(function()
        tmr.alarm(1, 1000, 1, function()
            if wifi.sta.getip() == nil then
                print("IP unavailable, Waiting...")
            else
                tmr.stop(1)
                print("ESP8266 mode is: " .. wifi.getmode())
                print("The module MAC address is: " .. wifi.ap.getmac())
                print("Config done, IP is "..wifi.sta.getip())
                cb()
            end
        end)
    end)
end

gql = function(body, cb) 
    http.post(CASCADE_URL, JSON_HEADERS, sjson.encode(body), function(code, response)
        cb(sjson.decode(response))
    end)
end

getSensors = function(cb)
    gql({
      query = [[
        query($deviceId: ID!) {
            device(where: {
              id: $deviceId
            }) {
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
    }, cb)
end

sensors = {}

saveSensors = function(response)
    print('Saving sensors...')
    sensors = {}
    for key, val in pairs(response.data.device.sensors) do
        sensors[val.sensorType.name] = val.id
    end
    print(sensors)
    print('Sensors saved.')
end

logs = {}

UPLOAD_LOG_QUERY = [[
  mutation($sensorId: ID!, $value: Float!) {
    createLog(data: {
      sensor: {
        connect: {
          id: $sensorId
        },
      },
      value: $value,
    }) {
      id
    }
  }
]]

logSensor = function(sensorName, value)
    sensorId = sensors[sensorName]

    table.insert(logs, {
        sensorId = sensorId,
        value = value,
    })
    print(sensorId)
    print(value)
    gql({
      query = UPLOAD_LOG_QUERY,
      variables = {
        sensorId = sensorId,
        value = value,
      },
    }, function(response)
      print(response)
    end)
end

logHumidity = function()
    print('Logging Humidity')
    alt, sda, scl =120, 1, 2                --altitude of the measurement place, GPIO2, GPIO0
    i2c.setup(0, sda, scl, i2c.SLOW)        -- call i2c.setup() only once
    bme280.setup()
    humidity, temperature = bme280.humi()
    print(bme280.humi())
    print(humidity)
    print(temperature)
    logSensor('Humidity', humidity)
end

initLogging = function()
    print('Starting to log...')
    logHumidity()
end

initUploading = function()
    print('Starting to upload...')

    print(logs[0])

    print(logs)
end

obtainWifi(
    function()
        getSensors(
            function(data)
                saveSensors(data)
                print(sjson.encode(sensors))

                initLogging()
                initUploading()
            end
        )
    end
)

--print("got sensors")