function gql(body, cb)
    --print('GQL query to ' .. CASCADE_URL)
    --print(sjson.encode(body))
    http.post('http://cascade-backend.herokuapp.com', 'Accept-Encoding: gzip, deflate, br\r\nContent-Type: application/json\r\nAccept: application/json\r\n', sjson.encode(body), function(code, response)
        if (code == -1) then
            return print('gql error')
        end

        cb(sjson.decode(response))
        response = nil
        cb = nil
        body = nil
    end)
end
