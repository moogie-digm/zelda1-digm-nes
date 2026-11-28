-- signal modules when wram copied



-- usa-10		1:8d38		CopyCommonCodeToRam
-- jpn			1:8d3f

local aob = {
	'69 00',	-- adc #$00
	'85 03',	-- sta $03
	'c9 ?',		-- cmp #$7f / #$80  [some zelda1 hacks]
	'd0 ?',		-- bne x
	'a5 02',	-- lda $02
	'c9 00',	-- cmp #$00

	'$ d0 ?',	-- bne @Loop	<-- copy loop done
}

local copy = rom_hook4(0x8d38, 0x4d38, aob)




wram_overlays = create_overlays_system()



if copy then
	local _pc, _addr = copy.pc, copy.addr


	local prefn = function()
		if cpu.zf == 0 then return end		-- still copying data


		wram_overlays.run()		-- callbacks
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end



loadstate.add(function()
	wram_overlays.run()
end)
