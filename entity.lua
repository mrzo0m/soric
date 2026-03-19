pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function getentity()
    local entity = {}
    entity.__index = entity

    setmetatable(entity, {
        __call = function(klass, ...)
            local self = setmetatable({}, klass)
            self:_init(...)
            return self
        end,
    })

    function entity:_init(id, type)
        self.id = id
        self.type = type
        self.components = {} -- Use a table/map
        self.eventManager = nil
        self.alive = false
    end

    function entity:set_type(type_newval)
        self.type = type_newval
    end

    function entity:get_type()
        return self.type
    end

    function entity:get(cmp_type)
        --debug
        if debug then
            logger:debug("get " .. cmp_type .. " from entity ")
        end
        return self.components[cmp_type] -- Direct access, O(1)
    end

    function entity:add(cmp)
        local cmp_type = cmp:get_type()
        if not self.components[cmp_type] then
            self.components[cmp_type] = cmp
            if debug then
                logger:debug("added "..cmp_type.." to entity ")
            end
        else
            if debug then
                logger:debug("Aready added "..cmp_type.." to entity ")
            end
        end
    end

    function entity:remove(cmp)
        --debug
        if debug then
            logger:debug("delete " .. cmp:get_type() .. " from entity " )
        end

        local cmp_type = cmp:get_type()
        self.components[cmp_type] = nil -- Remove from the table
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