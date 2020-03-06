pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--entity
function getplayer()
    
    local player = {}
    player.__index = player
    local entity_type = "player"
    
    setmetatable(player, {
        __index = entity, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })
    
    function player:_init(id)
        entity._init(self, id, entity_type) -- call the base class constructor
    end

    
    return player
end