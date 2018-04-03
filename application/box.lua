box = {}
function box.put(line)
  if file.open("local.log", "a+") then
     file.writeline(line)
     file.close()
  end
end

function box.home_ping(ip)
     conn=net.createConnection(net.TCP, 0)
     conn:on("receive", function(conn, pl) print(pl) end)
     conn:connect(80,"165.227.167.119")
     conn:send("GET / HTTP/1.1\r\nHost: www..com\r\n"
    .."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
     conn=nil
end

function box.sensor_temp()
  --alt, sda, scl =120, 3, 4                --altitude of the measurement place, GPIO2, GPIO0
  alt, sda, scl =120, 1, 2                --altitude of the measurement place, GPIO2, GPIO0
  i2c.setup(0, sda, scl, i2c.SLOW)        -- call i2c.setup() only once
  bme280.setup()
  --P, T = bme280.baro()
  H, T = bme280.humi()
  sec, usec, rate = rtctime.get()
  out='t:'..sec..' H:'..H..' T:'..T
  print(out)
  box.put(out)
  return out
end

function box.sensor_light()
     L = adc.read(0)
     S, usec, rate = rtctime.get()
     out='t:'..S..' L:'..L
     print(out)
     box.put(out)
     return out
end

function box.ads1115()
local id, alert_pin, sda, scl = 0, 7, 6, 5
i2c.setup(id, sda, scl, i2c.SLOW)
ads1115.reset()
adc1 = ads1115.ads1115(id, ads1115.ADDR_GND)

-- continuous mode
adc1:setting(ads1115.GAIN_6_144V, ads1115.DR_128SPS, ads1115.SINGLE_0, ads1115.CONTINUOUS)

-- read adc result with read()
volt, volt_dec, adc, sign = ads1:read()
print(volt, volt_dec, adc, sign)

-- comparator
adc1:setting(ads1115.GAIN_6_144V, ads1115.DR_128SPS, ads1115.SINGLE_0, ads1115.CONTINUOUS, ads1115.COMP_1CONV, 1000, 2000)
local function comparator(level, when)
    -- read adc result with read() when threshold reached
    gpio.trig(alert_pin)
    volt, volt_dec, adc, sign = ads1:read()
    print(volt, volt_dec, adc, sign)
end
gpio.mode(alert_pin, gpio.INT)
gpio.trig(alert_pin, "both", comparator)

-- read adc result with read()
volt, volt_dec, adc, sign = ads1115:read()
print(volt, volt_dec, adc, sing)

-- format value in int build
if sign then
    -- int build
    print(string.format("%s%d.%03d mV", sign >= 0 and "+" or "-", volt, volt_dec))
else
    -- float build
    -- just use V as it is
end
end

function box.i2c_scan(sda, scl)
  -- Based on work by zeroday & sancho among many other open source authors
  -- This code is public domain, attribution to gareth@l0l.org.uk appreciated.

  -- initialize i2c with our id and pins in slow mode :-)
  id=0
  i2c.setup(id, sda, scl, i2c.SLOW)

  -- user defined function: read from reg_addr content of dev_addr
  local read_reg = function (dev_addr, reg_addr)
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.TRANSMITTER)
    i2c.write(id, reg_addr)
    i2c.stop(id)
    i2c.start(id)
    i2c.address(id, dev_addr, i2c.RECEIVER)
    c=i2c.read(id,1)
    i2c.stop(id)
    return c
  end

  print("Scanning I2C Bus")
  for i = 0, 127 do
    if (string.byte(read_reg(i, 0)) == 0) then
      print("I2C device found at address: 0x"..string.format("%02X",i))
    end
  end
end