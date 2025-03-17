lua
function getworld()
    local world = {}
    world.__index = world

    setmetatable(world, {
        __call = function (cls, ... )
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function world:_init()
        self.entitys = {}
        self.systems = {}
    end

    function world:register_entity(entity)
        add(self.entitys, entity)
        for s in all(self.systems) do
           s:register_entity(entity)
        end
    end

    function world:register_system(system)
        system:register_world(self)
        add(self.systems, system)
        for e in all(self.entitys) do
            system:register_entity(e)
         end
    end
    function world:get_entities_with(component_types)
        local matching_entities = {}
        for e in all(self.entitys) do
            local has_all_components = true
            for _, component_type in ipairs(component_types) do
                if e:get(component_type) == nil then
                    has_all_components = false
                    break
                end
            end
            if has_all_components then
                add(matching_entities, e)
            end
        end
        return matching_entities
    end
    return world
end