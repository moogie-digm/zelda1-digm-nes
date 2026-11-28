-- Prevent sideways movement on ladder when fire knockback
-- ## Un-Tested ##



-- usa-10		7:f902		UpdateFire - @DrawAndCheckCollisions
-- jpn			7:f900

local aob = {
	'a0 00',		-- ldy #$00
	'84 00',		-- sty $00
	'20 ? ?',		-- jsr BeginShove

	'$ a9 00',		-- lda #$00		<-- apply flame damage
	'85 0d',		-- sta $0d
	'a9 80',		-- lda #$80
	'85 0e',		-- sta $0e
}

local flame = rom_hook4(0xf902, 0x1f902, aob)




if flame then
	local _pc, _addr = flame.pc, flame.addr


	local prefn = function()
		local used_ladder = ram[0x64]	-- obj index
		if used_ladder == 0 then return end


		local on_ladder = ram[0xac + used_ladder]	-- obj state
		if on_ladder != 2 then return end


		local ladder_dir = (ram[0x98 + used_ladder] & 0x0c) != 0	-- obj dir = up-down
		local knockback_dir = (ram[0xc0] & 0x0c) != 0	-- vertical


		-- clear shove to prevent exploit movement from orthogonal knockback of fire damage
		if ladder_dir != knockback_dir then
			ram[0xd3] = 0	
		end
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
