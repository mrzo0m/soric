pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function getcomponent()
    local component = {}
    component.__index = component
    
    setmetatable(component, {
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })
    
    function component:_init(type)
        self.type = type
    end
    
    function component:set_type(newval)
        self.type = type
    end
    
    function component:get_type()
        return self.type
    end
    return component
end