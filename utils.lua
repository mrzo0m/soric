pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

function ipairs (a)
    return iter, a, 0
end