function ensureDb()
    if file.exists(DB_LOCATION) then
        print("DB exists")
    else
        print('DB doesnt exist. Creating...')
        local writeDb = file.open(DB_LOCATION, 'w+')
        writeDb:write(sjson.encode({ logs= {} }))
        writeDb:close()
        writeDb = nil
    end
end
