function logLogsCount()
    local count = 0
    
    for key, val in pairs(sensors) do
        local filename = val .. '.json'

        local readDb = file.open(filename, "r")
        filename = nil

        local originalJson = readDb:read(10000)
        readDb:close()
        readDb = nil
        
        count = count + table.getn(sjson.decode(originalJson).logs)
        originalJson = nil
    end

    require('logSensor')
    logSensor('Logs Count', count)
    package.loaded['logSensor'] = nil
    logSensor = nil
end