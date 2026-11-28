-- Smooth vertical scrolling



-- usa-10, jpn		5:8235		ScrollWorldDownOrH

local aob = {
	'$ e9 08',	-- sbc #$08		<-- move player sprite up 1/2 frame
	'85 84',	-- sta ObjY
	'a5 e2',	-- lda VScrollAddrLo
	'18',		-- clc
}

local patch = { 0xe9, 0x04 }

rom_patch4(0x14235, aob, patch)




-- usa-10, jpn		5:81f9		ScrollWorld[Up]

local aob = {
	'$ 69 08',	-- adc #$08		<-- move player sprite down 1/2 frame
	'85 84',	-- sta ObjY
	'a5 e2',	-- lda VScrollAddrLo
	'38',		-- sec
}

local patch = { 0x69, 0x04 }

rom_patch4(0x141f9, aob, patch)




-- usa-10, jpn		5:8497		UpdateMode7Scroll_Sub2

local aob = {
	'$ 69 01',		-- adc #$01		<-- reset vscroll frame tick
	'29 03',		-- and #$03
	'a4 10',		-- ldy CurLevel
	'd0 ?',			-- bne
}

local patch = { 0x69, 0x00 }

rom_patch4(0x14497, aob, patch)




-- usa-10, jpn		5:8560		WaitAndScrollToSplitBottom

local aob = {
	'a4 e2',			-- ldy VScrollAddrLo

	'$ 8d 06 20',		-- sta $2006	<-- bad scroll write = not precise enough
	'8c 06 20',			-- sty $2006
	'ad 07 20',			-- lda $2007	<-- bad scroll +1
	'ad 07 20',			-- lda $2007	<-- bad scroll +2
}

local vscroll = rom_hook4(0x8560, 0x14560, aob)


if not vscroll then
	-- redux patch
	aob = {
		'a9 00',		-- lda #$00

		'$ 8c 06 20',	-- sty $2006  <-- not enough precision
		'8d 05 20',		-- sta $2005
	}

	vscroll = rom_hook4(0x8566, 0x14566, aob)
end




if vscroll then
	local _pc, _addr = vscroll.pc, vscroll.addr


	local prefn = function()
		-- hud split
		if ppu.scanline < 63 or not ppu.hblank then
			cpu.wait()
			return
		end



		local scroll_mode = ram[0x13]
		local vaddr = (ram[0x58] << 8) | ram[0xe2]

		local coarse_y = (vaddr >> 5) & 0x1f
		local fine_y = 0
		local namet = vaddr >> 10



		-- scroll started = not top or bottom
		if not (vaddr == 0x2800 or (vaddr == 0x2100 and scroll_mode != 3)) then
			local start_frame = ram[0xe6]
			local frame_tick = (ram[0x15] - start_frame) & 3

			local overworld = ram[0x10] == 0		-- dungeon 1-9
			local same_frame = (frame_tick & (overworld and 1 or 3)) == 0

			local spr_up = (ram[0x98] & 8) > 0		-- player facing up


			if overworld then
				fine_y = (spr_up == same_frame) ? 2 : 0

			else
				-- 0,1,2,3 -> 6,4,2,0 / 0,2,4,6
				fine_y = spr_up ? 3 - frame_tick : frame_tick
			end

			fine_y *= 2



			if same_frame then
				local spr_y = ram[0x84]

				-- move player sprite
				ram[0x84] = spr_up ? math.min(spr_y + 4, 221) : math.max(spr_y - 4, 61)
			end
		end


		ppu.write_scroll(0, 0, coarse_y, fine_y, namet)
		cpu.rts()		-- do not read vram = bumps y-scroll +1 each time => glitchy scroll
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
