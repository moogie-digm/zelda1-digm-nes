--
-- Source:
-- 	minucce
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- Reset dungeon room door flags on entrance; stops open door glitches



-- usa-10		5:b4a3		@LoadLevel
-- jpn			5:b4ab

local aob = {
	'85 10',		-- sta CurLevel

	'$ a5 eb',		-- lda RoomId	<-- loading room
	'8d 26 05',		-- sta CaveSourceRoomId
	'a9 02',		-- lda #$02
}

local dungeon = rom_hook4(0xb4a3, 0x174a3, aob)




if dungeon then
	local _pc, _addr = dungeon.pc, dungeon.addr


	local prefn = function()
		ram[0xee] = 0	-- reset currently opened doors  ["Level 1 Key Glitch"]
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
