CASCADE_DEVICE_ID = 'cjfmlb3k40can0b825t0wzl5b'
CASCADE_URL = 'http://cascade-backend.herokuapp.com'
SENSOR_SCHEDULE = "* * * * *"
UPLOAD_SCHEDULE = "* * * * *"
DB_LOCATION = 'db.json'

WIFI_SSID = "uabnamai"
WIFI_PWD = "E7A0A3D980"

--WIFI_SSID = "Devyni Nol Astuoni"
--WIFI_PWD = "iknowhowtotype908"

JSON_HEADERS = 'Accept-Encoding: gzip, deflate, br\r\nContent-Type: application/json\r\nAccept: application/json\r\n'

sntp.sync(nil, nil, nil, 1)

ensureDb = function()
    if file.exists(DB_LOCATION) then
        print("DB exists")
    else
        print('DB doesnt exist. Creating...')
        writeDb = file.open('db.json', 'w+')
        writeDb:write(sjson.encode({ logs= {} }))
        writeDb:close()
    end
end

obtainWifi = function(cb)
    print('Getting wifi...')

    wifi.setmode(wifi.STATION)
    wifi.sta.config({ ssid= WIFI_SSID, pwd = WIFI_PWD })
    print('Configed.')
    wifi.sta.connect(function()
        print('Connecting...')
        tmr.alarm(1, 1000, 1, function()
            if wifi.sta.getip() == nil then
                print("IP unavailable, Waiting...")
            else
                tmr.stop(1)
                print('Connected!')
                print("ESP8266 mode is: " .. wifi.getmode())
                print("The module MAC address is: " .. wifi.ap.getmac())
                print("Config done, IP is "..wifi.sta.getip())
                cb()
            end
        end)
    end)
end

gql = function(body, cb)
    print('GQL query to ' .. CASCADE_URL)
    print(sjson.encode(body))
    http.post(CASCADE_URL, JSON_HEADERS, sjson.encode(body), function(code, response)
        if (code == -1) then
            return print('gql error')
        end

        cb(sjson.decode(response))
    end)
end

getSensors = function(cb)
    obtainWifi(function()
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
    end)
end

sensors = {}

saveSensors = function(response)
    print('Saving sensors...')
    sensors = {}
    for key, val in pairs(response.data.device.sensors) do
        sensors[val.sensorType.name] = val.id
    end

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

insertLogIntoDb = function(log)
    ensureDb()

    readDb = file.open("db.json", "r")

    originalJson = readDb:read()
    readDb:close()
    print(originalJson)
    originalDb = sjson.decode(originalJson)

    table.insert(originalDb.logs, log)

    result = sjson.encode(originalDb)

    writeDb = file.open('db.json', 'w+')
    writeDb:write(result)
    writeDb:close()

    print('Inserted into DB, final value:', result)
end

removeLogFromDb = function(i)
    ensureDb()

    readDb = file.open("db.json", "r")

    originalJson = readDb:read()
    readDb:close()
    print(originalJson)
    originalDb = sjson.decode(originalJson)

    table.remove(originalDb.logs, i)

    result = sjson.encode(originalDb)

    writeDb = file.open('db.json', 'w+')
    writeDb:write(result)
    writeDb:close()

    print('Removed' .. i .. ' from DB, final value:', result)
end

dbLogs = function()
    ensureDb()

    readDb = file.open("db.json", "r")

    originalJson = readDb:read()
    readDb:close()
    return sjson.decode(originalJson).logs
end

logSensor = function(sensorName, value)
    if (not value) then
        return
    end

    sensorId = sensors[sensorName]

    insertLogIntoDb({
        sensorId = sensorId,
        value = value,
    })
end

logHumidity = function()
    humidity, temperature = bme280.humi()
    logSensor('Humidity', humidity)
end

logTemperature = function()
    humidity, temperature = bme280.humi()
    logSensor('Temperature', temperature)
end

logPressure = function()
    pressure, temperature = bme280.baro()
    logSensor('Pressure', pressure)
end

initSensors= function()
    alt, sda, scl =120, 1, 2                --altitude of the measurement place, GPIO2, GPIO0
    i2c.setup(0, sda, scl, i2c.SLOW)        -- call i2c.setup() only once
    print('Setting up bme280')
    bme280.setup()
    print('Bme280 set up')
end

logSensors = function()
    for key, val in pairs(sensors) do
      print('Logging ', key)

      if key == 'Humidity' then
        logHumidity()
      elseif key == 'Temperature' then
        logTemperature()
      elseif key == 'Pressure' then
        logPressure()
      end

      print('Logged ', key)
    end
end

initLogging = function()
    cron.schedule(SENSOR_SCHEDULE, function(e)
      logSensors()
      logHumidity()
    end)
end

upload = function(log, cb)
   obtainWifi(function()
        gql({
            query = UPLOAD_LOG_QUERY,
            variables = log,
        }, cb)
    end)
end

uploadFirstLog = function()
  first = dbLogs()[1]

  if (not first) then
    return print('No more logs to upload')
  end

  print('Unuploaded logs exist...')
  upload(first, function(data)
    removeLogFromDb(1)
    print('Uploaded log', sjson.encode(data))
    uploadFirstLog()
  end)
end

initUploading = function()
    cron.schedule(UPLOAD_SCHEDULE, function(e)
        print('Starting to upload...')

        uploadFirstLog()
    end)
end

getSensors(function(data)
    saveSensors(data)
    initSensors()
    print(sjson.encode(sensors))

    initLogging()
    initUploading()
end)
