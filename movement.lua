pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--[[
  movement system
  ===============
  mario-like platformer physics
  with gravity, jumping, friction,
  and a dig-down mechanic.

  required components:
    "transform" - pixel position
    "motion"    - velocity data
    "collider"  - hitbox + grounded flag

  optional components:
    "sprite"    - for flip direction

  map tile sprite flags:
    flag 0 = solid (walls, ground)
    flag 1 = diggable (breakable)
  set these with fset() in _init().
]]--

--------------------------------------------
-- physics constants (tune these!)
--------------------------------------------
-- horizontal
local mv_accel   = 0.3   -- acceleration per frame
local mv_fric    = 0.8   -- friction multiplier (0=stop, 1=ice)
local mv_max_spd = 1.5   -- max horizontal speed
local mv_dead    = 0.05  -- snap-to-zero threshold

-- vertical
local mv_grav     = 0.2  -- gravity per frame
local mv_jump_spd = -3.5 -- jump velocity (neg=up)
local mv_max_fall = 3.0  -- terminal velocity

-- tile flags
local mv_solid_flag = 0
local mv_dig_flag   = 1

function getmovement()

    local movement = {}
    movement.__index = movement
    local system_type = "movement"

    setmetatable(movement, {
        __index = system,
        __call = function (klass, ...)
            local self = setmetatable({}, klass)
            self:_init(...)
            return self
        end,
    })

    function movement:_init()
        system._init(self, system_type)
    end

    ----------------------------------------
    -- collision helpers
    ----------------------------------------

    -- returns true if the map tile at
    -- pixel (x,y) has the solid flag
    function movement:check_solid(x, y)
        local tile = mget(flr(x / 8), flr(y / 8))
        return fget(tile, mv_solid_flag)
    end

    -- returns true if tile is diggable
    function movement:is_diggable(x, y)
        local tile = mget(flr(x / 8), flr(y / 8))
        return fget(tile, mv_dig_flag)
    end

    -- remove a tile from the map
    function movement:dig_tile(x, y)
        mset(flr(x / 8), flr(y / 8), 0)
    end

    ----------------------------------------
    -- main update
    ----------------------------------------
    function movement:update(dt)
        foreach(self.entitys, function(e)

            -- required components
            local t = e:get("transform")
            local m = e:get("motion")
            local c = e:get("collider")
            if t == nil or m == nil or c == nil then return end

            -- optional: sprite for flip
            local s = e:get("sprite")

            -- read current state
            local vel = m:get_velocity()
            local vx  = vel.x
            local vy  = vel.y
            local px  = t:get_x()
            local py  = t:get_y()

            -- hitbox from collider component
            local cw = c:get_w()
            local ch = c:get_h()
            local cox = c:get_ox()
            local coy = c:get_oy()

            -- hitbox world position
            -- (top-left of the collision box)
            local bx = px + cox
            local by = py + coy

            -- === grounded check ===
            -- probe two points at the bottom
            -- edge of the hitbox, 1px below feet
            local foot_y = by + ch
            local grounded =
                self:check_solid(bx + 1, foot_y)
             or self:check_solid(bx + cw - 2, foot_y)

            -- store grounded state on collider
            -- so other systems can read it
            c:set_grounded(grounded)

            --------------------------------
            -- horizontal movement
            --------------------------------
            if btn(0) then
                vx -= mv_accel
                if s then s:set_flip_x(false) end
            elseif btn(1) then
                vx += mv_accel
                if s then s:set_flip_x(true) end
            else
                vx *= mv_fric
                if abs(vx) < mv_dead then
                    vx = 0
                end
            end
            vx = mid(-mv_max_spd, vx, mv_max_spd)

            --------------------------------
            -- gravity
            --------------------------------
            vy += mv_grav
            if vy > mv_max_fall then
                vy = mv_max_fall
            end

            --------------------------------
            -- jumping
            --------------------------------
            if grounded and (btnp(4) or btnp(5)) then
                vy = mv_jump_spd
            end

            --------------------------------
            -- horizontal collision
            --------------------------------
            local nx = px + vx
            local nbx = nx + cox -- new hitbox x

            if vx < 0 then
                -- moving left: probe left edge
                if self:check_solid(nbx, by + 1)
                or self:check_solid(nbx, by + ch - 2) then
                    -- snap: align hitbox left to
                    -- right edge of blocking tile
                    nbx = flr(nbx / 8) * 8 + 8
                    nx  = nbx - cox
                    vx  = 0
                end
            elseif vx > 0 then
                -- moving right: probe right edge
                local probe_x = nbx + cw - 1
                if self:check_solid(probe_x, by + 1)
                or self:check_solid(probe_x, by + ch - 2) then
                    -- snap: align hitbox right to
                    -- left edge of blocking tile
                    nbx = flr(probe_x / 8) * 8 - cw
                    nx  = nbx - cox
                    vx  = 0
                end
            end

            t:set_x(nx)

            --------------------------------
            -- vertical collision
            --------------------------------
            local ny  = py + vy
            local nby = ny + coy -- new hitbox y
            -- use updated nbx for x probes
            nbx = nx + cox

            if vy < 0 then
                -- moving up: probe top edge (head)
                if self:check_solid(nbx + 1, nby)
                or self:check_solid(nbx + cw - 2, nby) then
                    -- bonked ceiling
                    nby = flr(nby / 8) * 8 + 8
                    ny  = nby - coy
                    vy  = 0
                end
            elseif vy > 0 then
                -- moving down: probe feet
                local probe_y = nby + ch
                if self:check_solid(nbx + 1, probe_y)
                or self:check_solid(nbx + cw - 2, probe_y) then
                    -- landed on ground
                    nby = flr(probe_y / 8) * 8 - ch
                    ny  = nby - coy
                    vy  = 0
                end
            end

            t:set_y(ny)

            --------------------------------
            -- dig-down mechanic
            --------------------------------
            if grounded and btn(3) then
                -- probe center-bottom, one tile
                -- below the hitbox feet
                local dig_x = nbx + cw / 2
                local dig_y = ny + coy + ch
                if self:is_diggable(dig_x, dig_y) then
                    self:dig_tile(dig_x, dig_y)
                    -- sfx(0) -- optional sound
                end
            end

            --------------------------------
            -- store velocity
            --------------------------------
            m:set_velocity(vx, vy)

        end)
    end

    return movement
end
