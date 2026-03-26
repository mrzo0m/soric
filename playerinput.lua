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
        __call = function (klass, ...)
            local self = setmetatable({}, klass)
            self:_init(...)
            return self
        end,
    })

    function playerinput:_init()
        system._init(self,  system_type) -- call the base class constructor
    end

    function playerinput:reset()
        keyboard:set_up_arrow(false)
        keyboard:set_down_arrow(false)
        keyboard:set_left_arrow(false)
        keyboard:set_right_arrow(false)
        keyboard:set_fst_btn(false)
        keyboard:set_snd_btn(false)
    end

    function playerinput:update(dt)

            foreach(self.entitys,
            function(e)
                local keyb = e:get("keyboard")
                local s = e:get("sprite")
                if keyb == nil or s == nil then return end

                -- reset all keys each frame
                self:reset()

                local last_spr_pix = s:get_end_pix()
                local shift_for_spr = s:get_size_w()

                 local animfn = function()
                     if s:get_start_pix() > last_spr_pix - 1 then
                         s:set_start_pix(1) --magic pixel location
                     else
                         s:set_start_pix(s:get_start_pix()  + shift_for_spr)
                     end
                 end

                -- update keyboard state only.
                -- movement system handles position,
                -- velocity, and sprite flipping.
                if btn(3) then
                    keyb:set_down_arrow(true)
                end
                if btn(2) then
                    keyb:set_up_arrow(true)
                end

                if btn(1) then
                    keyb:set_right_arrow(true)
                    animfn()
                end

                if btn(0) then
                    keyb:set_left_arrow(true)
                    animfn()
                end


            end
        )
    end

    return playerinput
end