DB_LOCATION = 'db.json'

collectgarbage("setmemlimit", 100)

sensors = {}
timings = {}

require('getSensors')
getSensors(function(data)
    require('saveSensors')
    saveSensors(data)
    package.loaded['saveSensors'] = nil
    saveSensors = nil
    data = nil

    require('ensureDb')
    ensureDb()
    package.loaded['ensureDb'] = nil
    ensureDb = nil

    require('initLogging')
    initLogging()
    package.loaded['initLogging'] = nil
    initLogging = nil

    require('initUploading')
    initUploading()
    package.loaded['initUploading'] = nil
    initUploading = nil
end)

package.loaded['getSensors'] = nil
getSensors = nil