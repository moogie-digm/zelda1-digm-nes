--
-- Source:
-- 	minucce
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- Keeps HUD on when transitioning between Overworld and Underworld



-- usa-10		5:aab4		LayoutRoomOrCaveOW - @NextSquare
-- jpn			fixed

local aob = {
	'$ e6 06',		-- inc $06		<-- column draw bump
	'a5 06',		-- lda $06
	'c9 10',		-- cmp #$10
	'b0 34',		-- bcs exit
}

local hud = rom_hook4(0xaab4, 0x16ab4, aob)




if hud then
	local _pc, _addr = hud.pc, hud.addr


	local prefn = function()
		-- refresh every 4 frames
		local frame = ram[0x06]
		if (frame & 3) != 0 then return end


		-- verify world transition
		local mode = ram[0x12]
		if (mode != 0x0a) && (mode != 0x0b) then return end


		if not ppu.vblank then
			cpu.wait()
			return
		end


		ram[0x06] += 1		-- column bump


		ppu.dma()			-- vblank = refresh oam decay


		-- hle: wait pre-render line
		ppu.stat = ppu.stat & ~0x40		-- sprite 0 off
		ppu.mask = 0x1e					-- screen on


		cpu.jsr(0x8521, _pc+2)			-- draw hud
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
