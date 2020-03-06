pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- sprite
function getsprite()

    local sprite = {}
    local cmp_type = "sprite"

    sprite.__index = sprite

    setmetatable(sprite, {
        __index = component, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function sprite:_init()
        component._init(self, cmp_type) -- call the base class constructor
    end

    function sprite:get_type()
        return self.type
    end

    return sprite
end