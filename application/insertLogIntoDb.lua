function insertLogIntoDb(log)
    local readDb = file.open(DB_LOCATION, "r")

    local originalJson = readDb:read(10000)
    readDb:close()
    readDb = nil
    
    --print(originalJson)
    local originalDb = sjson.decode(originalJson)
    originalJson = nil

    table.insert(originalDb.logs, log)

    local result = sjson.encode(originalDb)
    originalDb = nil

    writeDb = file.open(DB_LOCATION, 'w+')
    writeDb:write(result)
    writeDb:close()

    log = nil
    result = nil
    writeDb = nil
end