function initLogging()
    tmr.alarm(3, 1000 * timings.log, tmr.ALARM_AUTO, function()
        require('logSensors')
        logSensors()
        package.loaded['logSensors'] = nil
        logSensors = nil
    end)
end
