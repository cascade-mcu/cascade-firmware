function deleteLogFromDb(log)
    local filename = log.sensorId .. '.json'
    local readDb = file.open(filename, "r")

    local originalJson = readDb:read(10000)
    readDb:close()
    readDb = nil
    
    --print(originalJson)
    local originalDb = sjson.decode(originalJson)
    originalJson = nil

    table.remove(originalDb.logs, 1)

    local result = sjson.encode(originalDb)
    originalDb = nil

    local writeDb = file.open(filename, 'w+')
    writeDb:write(result)
    writeDb:close()

    result = nil
    writeDb = nil
    filename = nil
end