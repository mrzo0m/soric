pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- Control
function getkeyboardcomponent()

    local keyboardcomponent = {}
    local cmp_type = "keyboardcomponent"

    keyboardcomponent.__index = keyboardcomponent

    setmetatable(keyboardcomponent, {
        __index = component, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function keyboardcomponent:_init()
        component._init(self, cmp_type) -- call the base class constructor
    end


    return keyboardcomponent
end