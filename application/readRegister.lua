function readRegister(address, reg)
    i2c.start(0)
    i2c.address(0, address, i2c.TRANSMITTER)
    i2c.write(0, reg)
    i2c.stop(0)

    i2c.start(0)
    i2c.address(0, address, i2c.RECEIVER)
    local all = i2c.read(0, 2)
    i2c.stop(0)

    local a = string.byte(all)
    if a == nil then
        a = 0
    end

    local b = string.byte(all, 2)
    if b == nil then
        b = 0
    end

    local ret = 0
    ret = bit.bor(ret, a)
    ret = bit.lshift(ret, 8)
    ret = bit.bor(ret, b)

    address = nil
    all = nil
    a = nil
    b = nil
    return ret
end