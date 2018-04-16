function writeRegister(address, reg, value)
    i2c.start(0)
    i2c.address(0, address, i2c.TRANSMITTER)
    i2c.write(0, reg)
    local high = 0
    high = bit.rshift(value, 8)
    i2c.write(0, high)
    local low = 0
    low = bit.band(0xFF)
    i2c.write(0, low)
    i2c.stop(0)
    
    high = nil
    low = nil
    addres = nil
    reg = nil
    value = nil
end