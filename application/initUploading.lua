function initUploading()
    tmr.alarm(2, 1000 * timings.upload, tmr.ALARM_AUTO, function()
            print('Starting to upload...')

            require('uploadAll')
            uploadAll()
    end)
end
