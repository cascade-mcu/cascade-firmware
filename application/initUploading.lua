function initUploading()
    require('uploadAll')
    uploadAll()
    tmr.alarm(2, 1000 * timings.upload, tmr.ALARM_AUTO, function()
            print('Starting to upload...')
            uploadAll()
    end)
end
