function logHumidity()
    require('initBme280')
    initBme280()
    package.loaded['initBme280'] = nil
     initBme280 = nil
     humidity, temperature = bme280.humi()

    require('logSensor')
    logSensor('Humidity', humidity)
    package.loaded['logSensor'] = nil
    logSensor = nil
    humidity = nil
end