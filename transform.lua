pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
    -- Transform
    function gettransform()

    local transform = {}
    local cmp_type = "transform"

    transform.__index = transform

    setmetatable(transform, {
        __index = component, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function transform:_init(x, y)
        component._init(self, cmp_type) -- call the base class constructor
        self.x = x
        self.y = y
    end

    function transform:get_x()
        return self.x
    end

    function transform:get_y()
        return self.y
    end

    function transform:set_x(newx)
         self.x = newx
    end

    function transform:set_y(newy)
         self.y = newy
    end

    return transform
end