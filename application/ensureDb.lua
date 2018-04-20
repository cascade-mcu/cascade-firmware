function ensureDb()
    for key, val in pairs(sensors) do
        local filename = val .. '.json'
        
        if file.exists(filename) then
            print("Log file exists for " .. key)
        else
            print('Log file doesnt exist for' .. key .. '. Creating...')
            local writeDb = file.open(filename, 'w+')
            writeDb:write(sjson.encode({ logs= {} }))
            writeDb:close()
            writeDb = nil
        end

        filename = nil
        key = nil
        val = nil
    end
end
