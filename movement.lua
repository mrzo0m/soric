pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--system
function getmovement()

    local movement = {}
    movement.__index = movement
    local system_type = "movement"

    setmetatable(movement, {
        __index = system, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function movement:_init()
        system._init(self,  system_type) -- call the base class constructor
    end

    function movement:update(dt)
        foreach(self.entitys,
            function(e)
                local t = e:get("transform")
                local m = e:get("motion")


                 local velocity = m:get_velocity()
                 local acceleration = m:get_acceleration()
                velx = velocity.x + dt
                vely = velocity.y + dt
                --debug
                if debug then
                    logger:debug("velocity is  "..velocity.x.." "..velocity.y)
                    logger:debug("acceleration is  "..acceleration.x.." "..acceleration.y)
                end

                --[[
                    position.x += motion.velocity.x;
                    position.y += motion.velocity.y;
                    motion.velocity.x += motion.acceleration.x;
                    motion.velocity.y += motion.acceleration.y;
                ]]--


            end
        )
    end

    return movement
end