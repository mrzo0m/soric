pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function getsystem()
    local system = {}
    system.__index = system

    setmetatable(system, {
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function system:_init(type)
        self.type = type
        self.world = nil
        self.entitys = {}
    end

    function system:set_type(newval)
        self.type = type
    end

    function system:get_type()
        return self.type
    end

    function system:register_world(world)
        self.world = world
    end

    function system:register_entity(entity)

        local entity_type = entity:get_type()
        if self.entitys[entity_type] then
            --debug
            if debug then
                logger:debug("Aready added " .. cmp:get_type() .. " to entity "..self.id)
            end
        else
            add(self.entitys, cmp)
            --debug
            if debug then
                logger:debug("added " .. cmp:get_type() .. " to entity "..self.id)
            end
            --[[
                if self.eventmanager then
                    self.eventmanager:fireevent(lovetoys.componentadded(self, name))
                end ]] --
        end
    end

    function system:update(dt)
    end

    function system:render()
    end

    return system
end