function saveSensors(response)
    print('Saving sensors...')

    for key, val in pairs(response.data.device.sensors) do
        sensors[val.sensorType.name] = val.id
    end

    print('Sensors saved.')
end
