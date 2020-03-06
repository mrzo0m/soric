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

    function system:get_entity(entity_type)
        --debug
        if debug then
            logger:debug("get " .. entity_type .. " from system ")
        end

        local reslult
        for e in all(self.entitys) do
            if e:get_type() == entity_type then
                reslult = e
            end
        end
        return reslult

    end

    function system:register_world(world)
        self.world = world
    end

    function system:register_entity(entity)
        if debug then
            logger:debug("Registring some entity "..entity:get_type().." to system ")
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
            add(self.entitys, entity)
            --debug
            if debug then
                logger:debug("added "..entity:get_type().." to system ")
            end
        end
    end

    function system:update(dt)
    end

    function system:render()
    end

    return system
end