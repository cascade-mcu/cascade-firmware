function gql(body, cb)
    --print('GQL query to ' .. CASCADE_URL)
    --print(sjson.encode(body))
    http.post('http://cascade-backend.herokuapp.com', 'Accept-Encoding: gzip, deflate, br\r\nContent-Type: application/json\r\nAccept: application/json\r\n', sjson.encode(body), function(code, response)
        if (code == -1) then
            response = nil
            code = nil
            print('gql error')
            require('gql')
            gql(body, cb)
            package.loaded['gql'] = nil
            gql = nil
            body = nil
            cb = nil
            return
        end

        print(response)
        cb(sjson.decode(response))
        response = nil
        cb = nil
        body = nil
    end)
end
