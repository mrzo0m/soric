# Soric — PICO-8 Platformer/Digging Game

## Project Overview

A 2D platformer built in PICO-8 with Mario-like movement and a dig-down mechanic. Uses an Entity Component System (ECS) architecture.

## Architecture

### ECS Pattern

All game logic follows the Entity-Component-System pattern:

- **Components** — Pure data containers (no logic). Each is a `.lua` file returning a factory function (`get<name>()`).
- **Entities** — Containers that hold components. Identified by `id` and `type`. Components stored in a hash table for O(1) lookup via `entity:get("component_type")`.
- **Systems** — Process entities each frame. Inherit from the base `system` class. Override `update(dt)` or `render()`.
- **World** — Coordinates registration of entities and systems. Bidirectional: registering an entity notifies all systems, registering a system notifies it of all entities.

### OOP Pattern

All classes use Lua metatables with a factory function pattern:
```lua
function getfoo()
    local foo = {}
    foo.__index = foo
    setmetatable(foo, {
        __index = parent,  -- inheritance
        __call = function(klass, ...)
            local self = setmetatable({}, klass)
            self:_init(...)
            return self
        end,
    })
    function foo:_init(...) ... end
    return foo
end
```

Globals are initialized in `soric.p8` after all `#include` directives, in dependency order: components, then entities, then systems, then world.

## File Structure

| File | Type | Purpose |
|------|------|---------|
| `soric.p8` | Cartridge | Main entry point, `_init/_update/_draw`, includes, globals |
| `component.lua` | Core | Base component class |
| `entity.lua` | Core | Base entity class |
| `system.lua` | Core | Base system class |
| `world.lua` | Core | World coordinator |
| `collider.lua` | Component | Hitbox dimensions (w, h, ox, oy) + grounded flag |
| `keyboard.lua` | Component | Cached input state (arrows + 2 buttons) |
| `sprite.lua` | Component | Sprite rendering data (pixel index, size, flip, animation range) |
| `motion.lua` | Component | Velocity and acceleration vectors |
| `transform.lua` | Component | Pixel position (x, y) |
| `player.lua` | Entity | Player entity, type="player", inherits from entity |
| `movement.lua` | System | Physics: gravity, acceleration, friction, jumping, collision, digging |
| `playerinput.lua` | System | Reads btn() into keyboard component + sprite animation |
| `render.lua` | System | Draws sprites using `spr()` |
| `logger.lua` | Utility | Debug logging |
| `utils.lua` | Utility | Helper functions (ipairs) |
| `statemachine.lua` | Utility | Finite state machine (kyle conroy) |

## Player Entity Setup

The player entity (id=2, type="player") has 5 components:

| Component | Init Values | Notes |
|-----------|------------|-------|
| `sprite` | `(1, 2, 2, true, false, 13)` | 2x2 tiles (16x16px), animation frames 1-13 |
| `transform` | `(8, 17)` | Spawn position, feet on ground row 4 |
| `motion` | `(0, 0, 0, 0)` | Zero initial velocity/acceleration |
| `keyboard` | `(all false)` | Input state reset each frame |
| `collider` | `(12, 14, 2, 1)` | 12x14px hitbox, inset 2px right + 1px down from sprite origin |

## Movement System Physics

Constants defined at top of `movement.lua`:

| Constant | Value | Purpose |
|----------|-------|---------|
| `mv_accel` | 0.3 | Horizontal acceleration per frame |
| `mv_fric` | 0.8 | Friction multiplier when no input (0=stop, 1=ice) |
| `mv_max_spd` | 1.5 | Max horizontal speed |
| `mv_dead` | 0.05 | Snap-to-zero threshold |
| `mv_grav` | 0.2 | Gravity per frame |
| `mv_jump_spd` | -3.5 | Jump velocity (negative = up) |
| `mv_max_fall` | 3.0 | Terminal falling speed |

### Collision Resolution

- Uses separate horizontal-then-vertical passes to prevent corner clipping
- Collision probes use the `collider` component's hitbox (not sprite size)
- `check_solid(x, y)` reads the map with `mget` then checks `fget(tile, 0)`
- Grounded state is stored on the `collider` component (`collider:is_grounded()`)

### Controls

| Button | PICO-8 | Action |
|--------|--------|--------|
| Left | `btn(0)` | Accelerate left |
| Right | `btn(1)` | Accelerate right |
| Down | `btn(3)` | Dig (when grounded on diggable tile) |
| Z/C | `btnp(4)` | Jump (when grounded) |
| X/V | `btnp(5)` | Jump (when grounded) |

## Map & Tile Collision

### Sprite Flags

Set in the PICO-8 sprite editor (circles below sprite) or programmatically with `fset()`:

| Flag | Number | Meaning |
|------|--------|---------|
| 0 | Red circle | **Solid** — blocks player movement |
| 1 | Orange circle | **Diggable** — player can remove with DOWN |

A tile can have both flags (value 3 = solid + diggable).

Currently set programmatically in `_init()`:
```lua
for i=65,68 do
  fset(i, 3)  -- solid + diggable
end
```

### Ground Tiles

Tiles 65-68 (hex 0x41-0x44) are the terrain sprites. Painted in the bottom rows of the map.

### Map Layout

```
Row 0-3: Empty (sky/open space)
Row 4:   Ground surface (y=32px) — player stands here
Row 5-8: Underground terrain (diggable)
```

### How to Add Collidable Ground

1. **Sprite editor**: Draw a tile, click flag 0 (solid) below it
2. **Map editor**: Place that tile on the map
3. Movement system automatically detects it — no code changes needed

### Coordinate System

- PICO-8 screen: 128x128 pixels
- Map tiles: 8x8 pixels each
- Pixel-to-tile conversion: `tile_x = flr(pixel_x / 8)`
- Player position (`transform`) is the sprite's top-left corner in pixels
- Collider hitbox is offset from transform: `hitbox_x = transform.x + collider.ox`

## System Execution Order

In `_update()`:
1. `mvm:update(dt)` — Movement system (physics, collision, input reading)
2. `inpt:update(dt)` — Player input system (keyboard state, animation)

In `_draw()`:
1. `cls()` — Clear screen
2. Camera set to follow player: `camera(-64+x+8, -64+y+8)`
3. `map()` — Draw tile map
4. `camera()` — Reset camera
5. `ren:render()` — Render system draws entity sprites

## Important Notes

- `playerinput.lua` does NOT move the player directly — it only updates keyboard state and sprite animation. All position changes go through `movement.lua` so collision is respected.
- Motion component acceleration is `(0,0,0,0)` — gravity is handled internally by the movement system constant `mv_grav`.
- The collider hitbox (12x14px) is intentionally smaller than the sprite (16x16px) for better game feel.
- Token budget: ~3300/8192 (~40%) as of last check.
