pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--[[
  collider component
  ==================
  defines an entity's collision
  hitbox and tracks grounded state.

  the hitbox is offset from the
  entity's transform position so
  the collision box can be smaller
  than the sprite (feels better).

  params:
    w   - hitbox width in pixels
    h   - hitbox height in pixels
    ox  - x offset from transform pos
    oy  - y offset from transform pos
]]--
function getcollider()

    local collider = {}
    local cmp_type = "collider"

    collider.__index = collider

    setmetatable(collider, {
        __index = component,
        __call = function (klass, ...)
            local self = setmetatable({}, klass)
            self:_init(...)
            return self
        end,
    })

    function collider:_init(w, h, ox, oy)
        component._init(self, cmp_type)
        self.w  = w       -- hitbox width (px)
        self.h  = h       -- hitbox height (px)
        self.ox = ox or 0 -- x offset from transform
        self.oy = oy or 0 -- y offset from transform
        self.grounded = false -- set by movement system
    end

    -- getters
    function collider:get_w()
        return self.w
    end
    function collider:get_h()
        return self.h
    end
    function collider:get_ox()
        return self.ox
    end
    function collider:get_oy()
        return self.oy
    end
    function collider:is_grounded()
        return self.grounded
    end

    -- setters
    function collider:set_w(v)
        self.w = v
    end
    function collider:set_h(v)
        self.h = v
    end
    function collider:set_ox(v)
        self.ox = v
    end
    function collider:set_oy(v)
        self.oy = v
    end
    function collider:set_grounded(v)
        self.grounded = v
    end

    return collider
end
