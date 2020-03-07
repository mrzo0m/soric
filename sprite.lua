pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- sprite
function getsprite()

    local sprite = {}
    local cmp_type = "sprite"

    sprite.__index = sprite

    setmetatable(sprite, {
        __index = component, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function sprite:_init(start_pix, size_w, size_h, flip_x, flip_y, end_pix)
        component._init(self, cmp_type) -- call the base class constructor
        self.start_pix = start_pix
        self.size_w = size_w
        self.size_h = size_h
        self.flip_x = flip_x
        self.flip_y = flip_y
        self.end_pix = end_pix
    end


    function sprite:get_start_pix() --current
        return self.start_pix
    end

    function sprite:get_size_w()
        return self.size_w
    end


    function sprite:get_size_h()
        return self.size_h
    end


    function sprite:get_flip_x()
        return self.flip_x
    end


    function sprite:get_flip_y()
        return self.flip_y
    end


    function sprite:get_end_pix()
        return self.end_pix
    end



    function sprite:set_start_pix(start_pix)
         self.start_pix = start_pix
    end

    function sprite:set_size_w(size_w)
         self.size_w = size_w
    end


    function sprite:set_size_h(size_h)
         self.size_h = size_h
    end


    function sprite:set_flip_x(flip_x)
         self.flip_x = flip_x
    end


    function sprite:get_flip_y(flip_y)
         self.flip_y = flip_y
    end




    return sprite
end