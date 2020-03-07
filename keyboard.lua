pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- Control
function getkeyboard()

    local keyboard = {}
    local cmp_type = "keyboard"

    keyboard.__index = keyboard

    setmetatable(keyboard, {
        __index = component, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })

    function keyboard:_init()
        component._init(self, cmp_type) -- call the base class constructor
        self.up_arrow = false
        self.down_arrow = false
        self.left_arrow = false
        self.right_arrow = false
        self.fst_btn = false
        self.snd_btn = false
    end


    function keyboard:get_up_arrow()
       return self.up_arrow
    end
    function keyboard:get_down_arrow()
       return self.down_arrow
    end
    function keyboard:get_left_arrow()
       return self.left_arrow
    end
    function keyboard:get_right_arrow()
       return self.right_arrow
    end
    function keyboard:get_fst_btn()
       return self.fst_btn
    end
    function keyboard:get_snd_btn()
       return self.snd_btn
    end

    function keyboard:set_up_arrow(pressed)
         self.up_arrow = pressed
    end

    function keyboard:set_down_arrow(pressed)
         self.down_arrow = pressed
    end
    function keyboard:set_left_arrow(pressed)
         self.left_arrow = pressed
    end
    function keyboard:set_right_arrow(pressed)
         self.right_arrow = pressed
    end
    function keyboard:set_fst_btn(pressed)
         self.fst_btn = pressed
    end
    function keyboard:set_snd_btn(pressed)
         self.snd_btn = pressed
    end

return keyboard
end