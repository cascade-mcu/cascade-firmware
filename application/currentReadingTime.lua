function currentReadingTime()
    local tm = rtctime.epoch2cal(rtctime.get())
    return string.format("%04d-%02d-%02dT%02d:%02d:%02d.000Z", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"])
end