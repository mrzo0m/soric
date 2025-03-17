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

    function system:get_entity(entity_id)
        if self.world == nil then
           error("system not registered in world")
        end
        local entity = self.world:get_entity(entity_id)

        return entity
    end

    function system:register_world(world)
        self.world = world
    end

    function system:register_entity(entity)        
        if self.world == nil then
           error("system not registered in world")
        end
        if entity == nil then
            error("Cant register a nil entity")
        end
        if debug then
            logger:debug("Registring some entity "..entity:get_id().." to system ")
        end
        local entity_type = entity:get_type()

        local tmp = self:get_entity(entity_type)
        --debug
        if debug and tmp ~= nil then
            logger:debug("type is "..tmp:get_type())
        end
        if tmp ~= nil then
            --debug
            if debug then
                logger:debug("Aready added "..entity_type.." to system ")
            end
        else
            if self.world:has_entity(entity:get_id()) then
                add(self.entitys, entity)
            else
                error("Can register an entity that is not on the world")
            end

            --debug
            if debug then
                logger:debug("added "..entity:get_id().." to system ")
            end
        end
    end

    function system:unregister_entity(entity)
        for i,e in ipairs(self.entitys) do
            if e:get_id() == entity:get_id() then
                del(self.entitys,i)
                if debug then
                    logger:debug("unregistered "..entity:get_id().." from system ")
                end
                break
            end
        end
    end

    function system:update(dt)
    end

    function system:render()
    end

    return system
end