pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- soric man
#include logger.lua
#include component.lua
#include keyboard.lua
#include sprite.lua
#include motion.lua
#include transform.lua
#include entity.lua
#include player.lua
#include system.lua
#include movement.lua
#include playerinput.lua
#include render.lua
soric_sp=1
soric_flip=false
soric_anim_time=0
debug=false
ren=nil
mvm=nil

velx=nil
vely=nil

logger = getlogger()
--components
component = getcomponent()
keyboard = getkeyboard()
sprite = getsprite()
motion = getmotion()
transform = gettransform()
--entitys
entity = getentity()
player = getplayer()
--systems
system = getsystem()
render = getrender()
movement = getmovement()
playerinput = getplayerinput()

function _init()
	

 
 local soric_spr = sprite(1,2,2,true,false,13)
 local soric_trf = transform(1,59)

 
 local pl = player(2)
 
 local soric_motion = motion(0,0,0.000,0.0001)
 
 local soric_keyb = keyboard(false,false,false,false,false,false)
 

 pl:add(soric_spr)
 pl:add(soric_trf)
 pl:add(soric_motion)
 pl:add(soric_keyb)


 ren = render()
 ren:register_entity(pl)
 
 mvm = movement()
 mvm:register_entity(pl)
 
 inpt = playerinput()
 inpt:register_entity(pl)
end

function _update()

 local cur_time = time()
 
  mvm:update(cur_time)
  inpt:update(cur_time)
 --[[
 if cur_time - soric_anim_time > 0.2 then
			soric_anim_time = time() 
	
 end ]]--
  
end

function _draw()
  cls()
 -- spr(soric_sp,56,56,2,2,true)
 

 
 ren:render()
 
 --print(velx.." "..vely)
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000970000000000000000
007007000000009740000000000000097000000000000000000000000000000000000000000000000000000000009997400000000000999744d0000000000000
00077000000099974000000000000999700000000000000000000000000000000000000000000000000000002999ff07444d00000009ff07444dd00000000000
000770002999ff07444ddd0002999ff0744dd0000000097000dd0000000009700000000000007000d4d0000000fffff94444d0000009fff94444dd0000000000
0070070000fffff94444ddd0000fffff9444dd0000099077454dd0000009907745d000000009744d45dd00000000099994444dd0009ff99994444dd000000000
000000000000099994444dd00000009994444dd02999fff94444dd002999fff944ddd00000907f4944d4400000000099449445d002ff0099449445d000000000
0000000000000099449445d000000009949445d00fffff9949445d000fffff9949445d00009fff49445450000000004999944440000000499994444000000000
00000000000000099994444000000009999444440000009999444440000004999944440009f0099994444d000000044444444450000044444444445000000000
0000000000000004444444500000000444444454000000444444454000000444444445400f004444444445000000040044455455000000000445545500000000
00000000000000040445545000000000404004500000044404004500000004000400450020040400004405500000000040004405000000000040440500000000
00000000000000040040440000000004040005400000000000000550000000000000050000000000000000500000000000000550000000000000005000000000
00000000000000000050000000000000000050000000000000000050000000000000005000000000000000050000000000000000000000000000050000000000
00000000000000000500000000000000000500000000000000000005000000000000000500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00009997400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009ff07444d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009fff94444d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009ff99994444dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02ff0099449445d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000049999444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004444444444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000004400004550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000004000044050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
