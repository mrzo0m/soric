pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--system
function getplayerinput()

    local playerinput = {}
    playerinput.__index = playerinput
    local system_type = "playerinput"

    setmetatable(playerinput, {
        __index = system, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function playerinput:_init()
        system._init(self,  system_type) -- call the base class constructor
    end

    function playerinput:update(dt)

            foreach(self.entitys,
            function(e)
                local trf = e:get("transform")
                local keyb = e:get("keyboard")
                local s = e:get("sprite")

                local last_spr_pix = s:get_end_pix()
                local shift_for_spr = s:get_size_w()


                 local animfn = function()
                     if s:get_start_pix() > last_spr_pix - 1 then
                         s:set_start_pix(1) --magic pixel location
                     else
                         s:set_start_pix(s:get_start_pix()  + shift_for_spr)
                     end
                 end

                if btn(3) then
                    keyb:set_down_arrow(true)
                    trf:set_y(trf:get_y() + 1)
                end
                if btn(2) then
                    keyb:set_up_arrow(true)
                    trf:set_y(trf:get_y() - 1)
                end

                if btn(1) then
                    keyb:set_right_arrow(true)
                    s:set_flip_x(true)
                    trf:set_x(trf:get_x() + 1)
                    animfn()
                end


                if btn(0) then
                    keyb:set_left_arrow(true)
                    s:set_flip_x(false)
                    trf:set_x(trf:get_x() - 1)
                    animfn()
                end


            end
        )
    end

    return playerinput
end