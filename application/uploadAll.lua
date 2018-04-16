function uploadAll()
    require('getFirstLog')
    local first = getFirstLog()
    package.loaded['getFirstLog'] = nil
    getFirstLog = nil
      
      if (not first) then
        require('sleepWifi')
        sleepWifi()
        package.loaded['sleepWifi'] = nil
        sleepWifi = nil
        print('No more logs to upload')
        first = nil
        return
      end
    
      print('Unuploaded logs exist...')
      require('upload')
      print('after upload load', node.heap())
      
      upload(first, function(data)
        package.loaded['gql'] = nil
        package.loaded['upload'] = nil
        upload = nil
        
        print('uploaded', node.heap())
        require('deleteLogFromDb')
        deleteLogFromDb(1)
        package.loaded['deleteLogFromDb'] = nil
        deleteLogFromDb = nil
        
        print('Uploaded log', sjson.encode(data))

        first = nil
        data = nil

        uploadAll()
      end)

   package.loaded['upload'] = nil
   upload = nil
end