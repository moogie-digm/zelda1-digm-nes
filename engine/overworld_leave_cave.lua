--
-- Source:
-- 	minucce
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.


-- Reset player sprite position on entering overworld from caves



-- usa-10		5:8f5d		GoToModeAFromCave
-- jpn			fixed

local aob = {
	'$ a9 0a',	-- lda #$0a		<-- overworld flag
	'85 12',	-- sta GameMode
	'a9 00',	-- lda #$00
	'85 13',	-- sta GameSubmode
}

local cave = rom_hook4(0x8f5d, 0x14f5d, aob)




if cave then
	local _pc, _addr = cave.pc, cave.addr


	local prefn = function()
		ram[0x84] = 0xf8	-- hide player sprite
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
