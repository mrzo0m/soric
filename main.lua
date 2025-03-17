pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--- soric main
-- Include world.lua
dofile("world.lua")

-- Create the world
local world = getworld()

-- soric main


function _init()
  -- create player entity
    local player = getentity("player")
    world:register_entity(player)

    -- create motion system
    local motion = getsystem("motion")
    world:register_system(motion)
end

function _update60()
    local dt = time()
    for s in all(world.systems) do
        s:update(dt)
    end
end




