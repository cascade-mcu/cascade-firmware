function initBme280()
    --print('Setting up bme280')
    sda = 6
    scl = 5
    i2c.setup(0, sda, scl, i2c.SLOW)
    bme280.setup()
    --print('Bme280 set up')
end
