-- Fixes the collision above link when swinging the wand

-- During pre-attack phase, one tile above Link is used as collision hitbox
-- https://youtu.be/FBk-QkzMeIk?t=1673



local wand_valid = false


local wand = function()

if wand_valid then return end



-- usa-10, jpn		w:7d64		CheckMonsterArrowOrRodCollision

local aob = {
	'b9 ac 00',		-- lda $ac,y

	'$ c9 30',		-- cmp #$30		<-- current weapon frame
	'90 ?',			-- bne x
	'a9 01',		-- lda #$01
}

local _hook = wram_hook2(0x7d64, aob)



if _hook then
	wand_valid = true


	local _pc, _addr, _aob = _hook.pc, _hook.addr, _hook.aob


	local postfn = function()
		cpu.cf = cpu.a >= 0x32		-- active attack frame #
	end


	pc_hook( _pc, 0, wram_cond(_addr, _aob), nil, postfn)
end

end		-- wand_overlay


wram_overlays.add(wand)
