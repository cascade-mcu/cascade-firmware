function logCapacitiveSoilMoisture()
   require('initAds1115')
   initAds1115()
   package.loaded['initAds1115'] = nil
   initAds1115 = nil

    require('readADC_SingleEnded')
    local value = readADC_SingleEnded(0)
    package.loaded['readADC_SingleEnded'] = nil
    readADC_SingleEnded = nil

    require('logSensor')
    logSensor('Capacitive Soil Moisture', value)
    package.loaded['logSensor'] = nil
    logSensor = nil
    value = nil
end