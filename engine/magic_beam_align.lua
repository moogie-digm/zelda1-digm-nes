--
-- Source:
--	minucce
--
--
-- License:
--	Code should be used only for educational, documentation and modding purposes.
--	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- Fix alignment of the sword and rod beam sprites



-- usa-10, jpn		7:f831		@DrawSwordOrRod - @CalcAttrs

local aob = {
	'a9 10',		-- lda #$10
	'20 ? ?',		-- jsr PlaceWeapon

	'$ b5 98',		-- lda ObjDir,x		<-- beam created
	'29 03',		-- and #$03
	'f0 ?',			-- beq
	'b5 70',		-- lda $70,x
}

local beam = rom_hook4(0xf831, 0x1f831, aob)




if beam then
	local sword_beam 	= { 0, 1, -1 }		-- left / right, down, up
	local rod_beam	 	= { 0, 1, -1 }


	local _pc, _addr = beam.pc, beam.addr


	local prefn = function()
		local type = 0xac + cpu.x		-- sprite type
		local xpos = 0x70 + cpu.x		-- obj x


		-- modify weapon beam sprite-x
		if ram[type] == 0x10 then
			ram[xpos] += sword_beam[cpu.y + 1]

		elseif ram[type] == 0x80 then
			ram[xpos] += rod_beam[cpu.y + 1]
		end
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
