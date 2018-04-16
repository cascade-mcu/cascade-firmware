function initAds1115()
    --print('Setting up ads1115')
    sda = 2
    scl = 1
    i2c.setup(0, sda, scl, i2c.SLOW)
    --print('ads1115 set up')
end
