function logPressure()
    require('initBme280')
    initBme280()
    package.loaded['initBme280'] = nil
     initBme280 = nil
    pressure, temperature = bme280.baro()

    require('logSensor')
    logSensor('Pressure', pressure)
    package.loaded['logSensor'] = nil
    logSensor = nil
    pressure = nil
end
