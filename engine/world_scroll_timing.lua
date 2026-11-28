--
-- Source:
-- 	minucce
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- Fixes bottom-right hud corner visual garble during overworld scroll



-- usa-10, jpn		5:8560		WaitAndScrollToSplitBottom

local aob = {
	'a4 e2',			-- ldy VScrollAddrLo

	'$ 8d 06 20',		-- sta $2006	<-- bad scroll write timing
	'8c 06 20',			-- sty $2006
	'ad 07 20',			-- lda $2007
	'ad 07 20',			-- lda $2007
}

local vscroll = rom_hook4(0x8560, 0x14560, aob)




-- usa-10, jpn		5:8588		WaitAndScrollToSplitBottom  

local aob = {
	'a5 fd',			-- lda CurHScroll
	'8d 05 20',			-- sta $2005
	'a9 00',			-- lda #$00

	'$ 8d 05 20',		-- sta $2005	<-- bad scroll write timing = nametable overflow problem
}

local hscroll = rom_hook4(0x8588, 0x14588, aob)




if vscroll then
	local _pc, _addr = vscroll.pc, vscroll.addr


	local prefn = function()
		-- hud split
		if ppu.scanline < 63 or not ppu.hblank then
			cpu.wait()
			return
		end
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end




if hscroll then
	local _pc, _addr = hscroll.pc, hscroll.addr
	local _state = 0


	local prefn = function()
		if _state == 0 then
			cpu.write(0x2005, cpu.a)	-- scroll write must happen before hblank starts


			-- x-offset = 4 ==> fetches 4 overflow pixels from rightside nametable  [junk values]
			-- force nametable to vertical mirror = reads hud pixels
			write_mmc1(0x8000, 0x0f)


			cpu.wait()		-- loop again
			_state = 1
			return
		end



		-- wait for end of hud split
		if not ppu.hblank then
			cpu.wait()
			return
		end


		-- restore horizontal nametable for playfield scroll
		write_mmc1(0x8000, 0x0e)


		cpu.jmp(_pc + 3)		-- ppu write manually done
		_state = 0
	end


	pc_hook( _pc, 0, rom_cond(_addr), prefn)
end
