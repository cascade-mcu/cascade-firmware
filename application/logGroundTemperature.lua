function logGroundTemperature()
   require('initDs18b20')
   initDs18b20()
   package.loaded['initDs18b20'] = nil
   initDs18b20 = nil

   ds18b20.read(function(ind, rom, res, groundTemperature, tdec, par)
        require('logSensor')
        logSensor('Ground Temperature', groundTemperature)
        package.loaded['logSensor'] = nil
        logSensor = nil
        groundTemperature = nil
    end, {})

    tmr.delay(1000)
end