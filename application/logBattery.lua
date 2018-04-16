function logBattery()
    require('initAds1115')
   initAds1115()
   package.loaded['initAds1115'] = nil
   initAds1115 = nil

    require('readADC_SingleEnded')
    local value = readADC_SingleEnded(2)
    package.loaded['readADC_SingleEnded'] = nil
    readADC_SingleEnded = nil

    require('logSensor')
    logSensor('Battery', value)
    package.loaded['logSensor'] = nil
    logSensor = nil
    value = nil
end
