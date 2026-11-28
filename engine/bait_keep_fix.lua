--
-- Source:
-- 	The3Dude
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- remove bait item when given to prevent players keeping it
-- normally taken away after grumble is fully finished



-- usa-10		1:8c88		UpdateGrumble1
-- jpn			1:896a

local aob = {
	'a9 40',		-- lda #$40
	'85 ac',		-- sta ObjState

	'$ a9 04',		-- lda #$04		<-- start bait song
	'8d 02 06',		-- sta PlayTune
	'20 ? ?',		-- jsr SetRoomFlagUWItemState
}

local bait = rom_hook4(0x8c88, 0x4c88, aob)




if bait then
	local _pc, _addr = bait.pc, bait.addr


	local prefn = function()
		ram[0x65d] = 0	-- remove food immediately
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
