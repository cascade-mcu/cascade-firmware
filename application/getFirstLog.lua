function getFirstLog()
    local readDb = file.open(DB_LOCATION, "r")

    local originalJson = readDb:read(10000)
    readDb:close()
    readDb = nil
    
    local result = sjson.decode(originalJson).logs[1]
    originalJson = nil
    return result;
end
