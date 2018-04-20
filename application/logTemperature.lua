function logTemperature()
    require('initBme280')
    initBme280()
    package.loaded['initBme280'] = nil
     initBme280 = nil
     humidity, temperature = bme280.humi()

    require('logSensor')
    logSensor('Temperature', temperature)
    package.loaded['logSensor'] = nil
    logSensor = nil
    temperature = nil
end