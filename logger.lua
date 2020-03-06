pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function getlogger()
    local logger = {}
    function logger:debug(str)
       print(str)
    end
    return logger
end