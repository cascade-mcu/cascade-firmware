function logSensor(sensorName, value)
    if (not value) then
        return
    end

    print('Logging', sensorName, value)

    sensorId = sensors[sensorName]

    require('currentReadingTime')
    local time = currentReadingTime()
    package.loaded['currentReadingTime'] = nil

    require('insertLogIntoDb')

    insertLogIntoDb({
       sensorId = sensorId,
       value = value,
       readingTime = time,
     })
     package.loaded['insertLogIntoDb'] = nil
    
     sensorId = nil
     time = nil
     sensorName = nil
     value = nil
end