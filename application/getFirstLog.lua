function getFirstLog()
    for key, val in pairs(sensors) do
        local filename = val .. '.json'

        local readDb = file.open(filename, "r")
        filename = nil

        local originalJson = readDb:read(10000)
        readDb:close()
        readDb = nil
        
        local result = sjson.decode(originalJson).logs[1]
        originalJson = nil
        
        if (result) then
            return result
        end
    end

    return nil
end
