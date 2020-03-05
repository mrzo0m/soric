pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function getentity()
    local entity = {}
    entity.__index = entity

    setmetatable(entity, {
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function entity:_init(init)
        self.id = init
    end

    function entity:set_id(newval)
        self.id = newval
    end

    function entity:get_id()
        return self.id
    end
    return entity
end