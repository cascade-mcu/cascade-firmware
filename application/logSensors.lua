function logSensors()
    for key, val in pairs(sensors) do
      if key == 'Humidity' then
           require('logHumidity')
         logHumidity()
          package.loaded['logHumidity'] = nil
          logHumidity = nil
      elseif key == 'Temperature' then
            require('logTemperature')
         logTemperature()
          package.loaded['logTemperature'] = nil
          logTemperature = nil
      elseif key == 'Pressure' then
         require('logPressure')
         logPressure()
          package.loaded['logPressure'] = nil
          logPressure = nil
      elseif key == 'Vdd33' then
        --logVdd33()
      elseif key == 'Capacitive Soil Moisture' then
        require('logCapacitiveSoilMoisture')
        logCapacitiveSoilMoisture()
        package.loaded['logCapacitiveSoilMoisture'] = nil
        logCapacitiveSoilMoisture = nil
      elseif key == 'Ambient Light' then
        require('logAmbientLight')
        logAmbientLight()
        package.loaded['logAmbientLight'] = nil
        logAmbientLight = nil
      elseif key == 'Battery' then
         require('logBattery')
        logBattery()
        package.loaded['logBattery'] = nil
        logBattery = nil
      elseif key == 'Electrical Conductivity' then
         require('logElectricalConductivity')
         logElectricalConductivity()
          package.loaded['logElectricalConductivity'] = nil
          logElectricalConductivity = nil
       elseif key == 'Ground Temperature' then
         require('logGroundTemperature')
         logGroundTemperature()
          package.loaded['logGroundTemperature'] = nil
          logGroundTemperature = nil
      elseif key == 'Heap' then
           require('logHeap')
           logHeap()
          package.loaded['logHeap'] = nil
          logHeap = nil
      end

      key = nil
      val = nil
    end
end
