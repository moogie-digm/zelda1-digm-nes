--
-- Source:
-- 	minucce
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- Reset the meta timer when creating sprites
-- Prevents very lengthy uninit countdowns



-- usa-10		5:886e		InitMode_EnterRoom - @PlaceObjects
-- jpn			fixed

local aob = {
	'95 ac',		-- sta $ObjState,x
	'95 98',		-- sta $ObjDir,x

	'$ 95 3d',		-- sta $ObjStunTimer,x		<-- reset sprite meta
	'fe d0 03',		-- inc ObjAnimCounter, x
}

local sprites = rom_hook4(0x886e, 0x1486e, aob)




if sprites then
	local _pc, _addr = sprites.pc, sprites.addr


	local postfn = function()
		ram[0x28 + cpu.x] = 0	-- clear ObjTimer, to match jpn order
	end


	pc_hook( _pc, 0, rom_cond(_addr), nil, postfn)
end
