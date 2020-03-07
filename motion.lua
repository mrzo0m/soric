pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- motion
function getmotion()

local motion = {}
    local cmp_type = "motion"
    
    motion.__index = motion
    
    setmetatable(motion, {
        __index = component, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })
    
    function motion:_init(velocity_x, velocity_y, acceleration_x, acceleration_y)
        component._init(self, cmp_type) -- call the base class constructor
        self.velocity_x = velocity_x
        self.acceleration_x = acceleration_x
        self.velocity_y = velocity_y
        self.acceleration_y = acceleration_y
    end
    
    -- return vector
    function motion:get_velocity()
        local vel = {
            x = self.velocity_x,
            y = self.velocity_y
        }
        return vel
    end
    -- return vector
        function motion:get_acceleration()
        local acc = {
            x = self.acceleration_x,
            y = self.acceleration_y
        }
        return acc
    end


    function motion:set_velocity(velocity_x, velocity_y)
        self.velocity_x = velocity_x
        self.velocity_y = velocity_y
    end

    function motion:set_acceleration(acceleration_x, acceleration_y)
        self.acceleration_x = acceleration_x
        self.acceleration_y = acceleration_y
    end

    return motion
end