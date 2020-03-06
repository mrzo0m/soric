pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function getentity()
    local entity = {}
    entity.__index = entity

    setmetatable(entity, {
        __call = function(cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function entity:_init(init)
        self.id = init
        self.components = {}
        self.eventManager = nil
        self.alive = false
    end

    function entity:get(cmp_type)
        --debug
        if debug then
            logger:debug("get " .. cmp_type .. " from entity ")
        end

        local reslult
        for c in all(self.components) do
            if c:get_type() == cmp_type then
                reslult = c
            end
        end
        return reslult

    end


    function entity:add(cmp)

        local cmp_type = cmp:get_type()

        local tmp = self:get(cmp_type)
        --debug
        if debug and tmp ~= nil then
            logger:debug("type is "..tmp:get_type())
        end
        if tmp ~= nil then
            --debug
            if debug then
                logger:debug("Aready added "..cmp_type.." to entity "..self.id)
            end
        else
            add(self.components, cmp)
            --debug
            if debug then
                logger:debug("added "..cmp:get_type().." to entity "..self.id)
            end
            --[[
                if self.eventmanager then
                    self.eventmanager:fireevent(lovetoys.componentadded(self, name))
                end ]] --
        end
    end

    function entity:remove(cmp)
        --debug
        if debug then
            logger:debug("delete " .. cmp:get_type() .. " from entity "..self.id )
        end
        del(self.components, cmp)
    end


    function entity:get_components()
        return self.components
    end

    function entity:set_id(newval)
        self.id = newval
    end

    function entity:get_id()
        return self.id
    end

    return entity
end