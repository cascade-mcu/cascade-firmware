function insertLogIntoDb(log)
    local filename = log.sensorId .. '.json'
    local readDb = file.open(filename, "r")

    local originalJson = readDb:read(10000)
    readDb:close()
    readDb = nil
    
    --print(originalJson)
    local originalDb = sjson.decode(originalJson)
    originalJson = nil

    table.insert(originalDb.logs, log)

    local result = sjson.encode(originalDb)
    originalDb = nil

    writeDb = file.open(filename, 'w+')
    writeDb:write(result)
    writeDb:close()

    log = nil
    result = nil
    writeDb = nil
    filename = nil
end