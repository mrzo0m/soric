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
        self.components = {}
        self.eventManager = nil
        self.alive = false
    end

    function entity:add(cmp)


        local cmp_type = cmp:get_type()
        if self.components[cmp_type] then
            --debug
            if debug then
                logger:debug("Aready added "..cmp:get_type().." to entity ")
            end
        else
            add(self.components, cmp)
            --debug
            if debug then
                logger:debug("added "..cmp:get_type().." to entity ")
            end
            --[[
                if self.eventmanager then
                    self.eventmanager:fireevent(lovetoys.componentadded(self, name))
                end ]]--
        end
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