pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--entity
function getplayer()
    
    local player = {}
    player.__index = player
    
    setmetatable(player, {
        __index = entity, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })
    
    function player:_init(id, name)
        entity._init(self, id) -- call the base class constructor
        self.name = name
    end
    
    function player:get_id()
        return self.id
    end

    function player:get_name()
        return self.name
    end
    
    return player
end