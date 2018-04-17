function saveSensors(response)
    print('Saving sensors...')

    for key, val in pairs(response.data.device.sensors) do
        sensors[val.sensorType.name] = val.id
    end

    timings['log'] = response.data.device.logEveryInSeconds
    timings['upload'] = response.data.device.uploadEveryInSeconds

    print(sjson.encode(sensors))
    print(sjson.encode(timings))

    print('Sensors saved.')
end
