function initUploading()
    tmr.alarm(2, 1000 * 60 * 15 + 20 * 1000, tmr.ALARM_AUTO, function()
            print('Starting to upload...')

            require('uploadAll')
            uploadAll()
    end)
end
