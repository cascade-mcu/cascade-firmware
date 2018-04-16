function readADC_SingleEnded(channel, cb)
    if channel > 3 then
        return 0
    end

    local ADDR                                = 0x48

    local ADS1115_CONVERTIONDELAY             = 8
    
    local ADS1015_REG_POINTER_MASK            = 0x03
    local ADS1015_REG_POINTER_CONVERT         = 0x00
    local ADS1015_REG_POINTER_CONFIG          = 0x01
    local ADS1015_REG_POINTER_LOWTHRESH       = 0x02
    local ADS1015_REG_POINTER_HITHRESH        = 0x03
    
    local ADS1015_REG_CONFIG_MUX_SINGLE_0     = 0x4000
    local ADS1015_REG_CONFIG_MUX_SINGLE_1     = 0x5000
    local ADS1015_REG_CONFIG_MUX_SINGLE_2     = 0x6000
    local ADS1015_REG_CONFIG_MUX_SINGLE_3     = 0x7000
    
    local ADS1015_REG_CONFIG_OS_SINGLE        = 0x8000
    
    local ADS1015_REG_CONFIG_CQUE_NONE        = 0x0003
    local ADS1015_REG_CONFIG_CLAT_NONLAT      = 0x0000
    local ADS1015_REG_CONFIG_CPOL_ACTVLOW     = 0x0000
    local ADS1015_REG_CONFIG_CMODE_TRAD       = 0x0000
    local ADS1015_REG_CONFIG_DR_1600SPS       = 0x0080
    local ADS1015_REG_CONFIG_MODE_SINGLE      = 0x0100

    local config = 0
    config = bit.bor(config, ADS1015_REG_CONFIG_CQUE_NONE)
    config = bit.bor(config, ADS1015_REG_CONFIG_CLAT_NONLAT)
    config = bit.bor(config, ADS1015_REG_CONFIG_CPOL_ACTVLOW)
    config = bit.bor(config, ADS1015_REG_CONFIG_CMODE_TRAD)
    config = bit.bor(config, ADS1015_REG_CONFIG_DR_1600SPS)
    config = bit.bor(config, ADS1015_REG_CONFIG_MODE_SINGLE)

    if channel == 0 then
        config = bit.bor(config, ADS1015_REG_CONFIG_MUX_SINGLE_0)
    elseif channel == 1 then
        config = bit.bor(config, ADS1015_REG_CONFIG_MUX_SINGLE_1)
    elseif channel == 2 then
        config = bit.bor(config, ADS1015_REG_CONFIG_MUX_SINGLE_2)
    elseif channel == 3 then
        config = bit.bor(config, ADS1015_REG_CONFIG_MUX_SINGLE_3)
    end

    config = bit.bor(config, ADS1015_REG_CONFIG_OS_SINGLE)

    require('writeRegister')
    writeRegister(ADDR, ADS1015_REG_POINTER_CONFIG, config)
    package.loaded['writeRegister'] = nil
    writeRegister = nil

    tmr.delay(ADS1115_CONVERTIONDELAY)

    require('readRegister')
    local value = readRegister(ADDR, ADS1015_REG_POINTER_CONVERT)
    package.loaded['readRegister'] = nil
    readRegister = nil
    
    ADS1115_CONVERTIONDELAY             = nil
    
    ADS1015_REG_POINTER_MASK            = nil
    ADS1015_REG_POINTER_CONVERT         = nil
    ADS1015_REG_POINTER_CONFIG          = nil
    ADS1015_REG_POINTER_LOWTHRESH       = nil
    ADS1015_REG_POINTER_HITHRESH        = nil
        
    ADS1015_REG_CONFIG_MUX_SINGLE_0     = nil
    ADS1015_REG_CONFIG_MUX_SINGLE_1     = nil
    ADS1015_REG_CONFIG_MUX_SINGLE_2     = nil
     ADS1015_REG_CONFIG_MUX_SINGLE_3     = nil
        
    ADS1015_REG_CONFIG_OS_SINGLE        = nil
        
     ADS1015_REG_CONFIG_CQUE_NONE        = nil
     ADS1015_REG_CONFIG_CLAT_NONLAT      = nil
     ADS1015_REG_CONFIG_CPOL_ACTVLOW     = nil
     ADS1015_REG_CONFIG_CMODE_TRAD       = nil
     ADS1015_REG_CONFIG_DR_1600SPS       = nil
     ADS1015_REG_CONFIG_MODE_SINGLE      = nil

    return  value
end