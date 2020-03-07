pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--system
function getrender()
    
    local render = {}
    render.__index = render
    local system_type = "render"
    
    setmetatable(render, {
        __index = system, -- this is what makes the inheritance work
        __call = function (cls, ...)
            local self = setmetatable({}, cls)
            self:_init(...)
            return self
        end,
    })
    
    function render:_init()
        system._init(self,  system_type) -- call the base class constructor
    end

    function render:render()
        foreach(self.entitys,
            function(e)
                local trf = e:get("transform")
                local s = e:get("sprite")
                spr(
                    s:get_start_pix(),
                    trf:get_x(),
                    trf:get_y(),
                    s:get_size_w(),
                    s:get_size_h(),
                    s:get_flip_x(),
                    s:get_flip_y()
                )
            end
        )
    end

    return render
end