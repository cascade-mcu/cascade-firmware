function deleteLogFromDb(i)
    local readDb = file.open(DB_LOCATION, "r")

    local originalJson = readDb:read(10000)
    readDb:close()
    readDb = nil
    
    --print(originalJson)
    local originalDb = sjson.decode(originalJson)
    originalJson = nil

    table.remove(originalDb.logs, i)

    local result = sjson.encode(originalDb)
    originalDb = nil

    local writeDb = file.open(DB_LOCATION, 'w+')
    writeDb:write(result)
    writeDb:close()

    result = nil
    writeDb = nil
end