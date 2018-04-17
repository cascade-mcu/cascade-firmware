function initLogging()
    tmr.alarm(3, 1000 * 30, tmr.ALARM_AUTO, function()
        require('logSensors')
        logSensors()
        package.loaded['logSensors'] = nil
        logSensors = nil
    end)
end
