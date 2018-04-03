--print(wifi.sta.getip())
--move everything to lc submodules
--log  datex5          XY.LL.MM.TT.HH
--ex   00.117.86400    XY.22.33.22.55
--       21 474 83648

print(' chip:',node.chipid(),' heap:',node.heap())

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,
function(T)
     print("\n\tSTA_GOT_IP".."\n\tIP: "..T.IP.."\n\tMask: "..T.netmask.."\n\tGW "..T.gateway)
     sntp.sync(nil, nil, nil, 1)
     mytimer = tmr.create()
     mytimer:register(20000, tmr.ALARM_SINGLE,
          function()
               dofile('box.lua')

                if pcall(box.sensor_temp) then
                    print("Temp sent OK")
                 else
                    print("Temp err" )
                 end
                box.i2c_scan(1,2)

               --box.sensor_light()
               box = nil
          end)
     --mytimer:register(20000, tmr.ALARM_SINGLE, function() print("ALARM 20k") end)
     mytimer:start()
     --out=ebox.home_ping(T.IP)
end)

wifi.setmode(wifi.STATION)
--wifi.sta.config {ssid="Teo-55A397-Greitasis", pwd="CA5A698B5C"}
wifi.sta.config {ssid="uabnamai", pwd="E7A0A3D980"}
wifi.sta.connect()

-- in you init.lua:
if adc.force_init_mode(adc.INIT_ADC)
then
  node.restart()
  return -- don't bother continuing, the restart is scheduled
end
--


-- Serving static files
dofile('httpServer.lua')
httpServer:listen(80)

-- Custom API
-- Get text/html
httpServer:use('/', function(req, res)
	res:send('Hello ') -- /welcome?name=doge
end)


httpServer:use('/box/ping', function(req, res)
     dofile('box.lua')
     box.home_ping(T.IP)
     box = nil
     res:send('Hello ')
end)

httpServer:use('/box/light', function(req, res)
     dofile('box.lua')
     out=box.sensor_light()
     box = nil
	res:send(out)
end)

httpServer:use('/box/temp', function(req, res)
     --dofile('box.lua')
     --out=box.sensor_temp()
     --box = nil
	--res:send(out)
     res:send('Hello ')
end)

httpServer:use('/box/put', function(req, res)
     --dofile('box.lua')
     --box.sensor()
     --box = nil
	res:send('Hello ') -- /welcome?name=doge
end)

-- Get file
httpServer:use('/box/log', function(req, res)
	res:sendFile('local.log')
end)

-- Get json
httpServer:use('/json', function(req, res)
	res:type('application/json')
	res:send('{"doge": "smile"}')
end)


cron.schedule("*/10 * * * *", function(e)
     --dofile('box.lua')
     --box.sensor()
     --box = nil
end)