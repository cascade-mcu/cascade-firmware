function syncTime(cb)
    print('Syncing time...')

    sntp.sync(nil, function()
        print('Time synced')
        cb()
        cb = nil
    end)
end
