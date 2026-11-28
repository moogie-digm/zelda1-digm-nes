--***********************************************************
--		Change Dungeon Music
--	Code by tacoschip, new Dungeon theme by gzip
--***********************************************************


incsrc('music._list')


local playlist = {
	-- dungeons 1-4
	zelda1_dungeon_theme,
	new_light_dungeon_theme,
	perils_darkness_dungeon_theme,
	triforce_power_dungeon_theme,


	-- dungeons 5-8
	zelda1_dungeon_theme,
	new_light_dungeon_theme,
	perils_darkness_dungeon_theme,
	triforce_power_dungeon_theme,
}



-- usa-10, jpn		0:9c97		@PlayFirstUnderworldPhrase

local aob = {
	'$ a0 0f',		-- ldy #$0f		<-- 0f+1 = phrase1
	'd0 ?',			-- bne SetPrevPhraseIndex
	'a0 08',		-- ldy #$08
}

local first_phrase = rom_hook4(0x9c97, 0x1c97, aob)




-- usa-10, jpn		0:9cbe		@PlayNextUnderworldPhrase

local aob = {
	'e6 6c',		-- inc SongPhraseIndex
	'a4 6c',		-- ldy SongPhraseIndex

	'$ c0 12',		-- cpy #$12		<-- last dungeon phrase
	'd0 ?',			-- bne PrepPhrase
}

local next_phrase = rom_hook4(0x9cbe, 0x1cbe, aob)




-- usa-10, jpn		0:9ce5		PrepPhrase

local aob = {
	'$ b9 5f 8d',		-- lda SongTableLo, y		<-- load song ptr
	'a8',				-- tay
	'b9 60 8d',			-- lda SongTable, Y
}

local prep_phrase = rom_hook4(0x9ce5, 0x1ce5, aob)


if prep_phrase then

	-- usa-10, jpn		0:0d2c		KeepPlayingSong
	local aob = {
		'8d 17 06',			-- sta NoteCounterSongNoise
		'4a',				-- lsr
		'8d 0a 06',			-- sta NoteOffsetSongSq1

		'$ ce 11 06',		-- dec NoteCounterSongSq1	<-- after load phrase done
	}

	local jmp = rom_hook4(0x9d2c, 0x1d2c, aob)


	if jmp then
		prep_phrase.jmp = jmp.pc
	else
		prep_phrase = nil
	end
end




-- usa-10, jpn		0:9d37		KeepPlayingSong

local aob = {
	'ac 0a 06',			-- ldy NoteOffsetSongSq1
	'ee 0a 06',			-- inc NoteOffsetSongSq1

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'f0 ?',				-- beq SongEnded
	'10 ?',				-- bpl PlayNote
	'd0 ?',				-- bne PrepNote
}

local sq2_note1 = rom_hook4(0x9d37, 0x1d37, aob)




-- usa-10, jpn		0:9d63		PrepNote

local aob = {
	'ac 0a 06',			-- ldy NoteOffsetSongSq1
	'ee 0a 06',			-- inc NoteOffsetSongSq1

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'ae 07 06',			-- ldx Tune1
}

local sq2_note2 = rom_hook4(0x9d63, 0x1d63, aob)




-- usa-10, jpn		0:9dbe		@HandleSq0

local aob = {
	'ac 0b 06',			-- ldy NoteOffsetSongSq0
	'ee 0b 06',			-- inc NoteOffsetSongSq0

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'10 ?',				-- bpl @PlaySq0
	'20 ? ?',			-- jsr GetSongNoteLength
}

local sq1_note1 = rom_hook4(0x9dbe, 0x1dbe, aob)




-- usa-10, jpn		0:9dce		@HandleSq0

local aob = {
	'ac 0b 06',			-- ldy NoteOffsetSongSq0
	'ee 0b 06',			-- inc NoteOffsetSongSq0

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'ae 05 06',			-- ldx Tune0
}

local sq1_note2 = rom_hook4(0x9dce, 0x1dce, aob)




-- usa-10, jpn		0:9e2c		@PrepNoteOrPassage

local aob = {
	'ac 0c 06',			-- ldy NoteOffsetSongTrg
	'ee 0c 06',			-- inc NoteOffsetSongTrg

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'f0 ?',				-- beq @SetTrgLinear
	'10 ?',				-- bpl @PlayNoteTrg
}

local tri_note1 = rom_hook4(0x9e2c, 0x1e2c, aob)




-- usa-10, jpn		0:9e66		@PrepNoteTrg

local aob = {
	'ac 0c 06',			-- ldy NoteOffsetSongTrg
	'ee 0c 06',			-- inc NoteOffsetSongTrg

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'f0 ?',				-- beq @SetTrgLinear
	'20 ? ?',			-- jsr EmitTriangleNote
}

local tri_note2 = rom_hook4(0x9e66, 0x1e66, aob)




-- usa-10, jpn		0:9ea7		@HandleNoise

local aob = {
	'ac 0d 06',			-- ldy NoteOffsetSongNoise
	'ee 0d 06',			-- inc NoteOffsetSongNoise

	'$ b1 66',			-- lda (SongScriptPtrLo), Y
	'd0 ?',				-- bne @NoteLength
}

local noi_note1 = rom_hook4(0x9ea7, 0x1ea7, aob)




-- usa-10, jpn		0:9f8f		ShapeSongVolume

local aob = {
	'b9 ? ?',		-- lda CustomEnvelopeSong,Y
	'4a',			-- lsr a
	'4a',			-- lsr a
	'4a',			-- lsr a
	'4a',			-- lsr a

	'$ 09 ?',		-- ora #volume		<-- hacks can use custom level
	'60',			-- rts
}

local envelope = rom_hook4(0x9f8f, 0x1f8f, aob)




local get_phrase = function(index)
	index = index or ram[0x6c]		-- phrase index


	local level = ram[0x10]		-- dungeon 1-8
	local track = playlist[level]
	local phrase = track.phrase[index]


	return phrase
end



local get_track = function()
	local level = ram[0x10]		-- dungeon 1-8
	local track = playlist[level]


	return track
end



local load_phrase = function(index)
	local phrase = get_phrase(index)


	ram[0x66] = 0		-- song base ptr
	ram[0x67] = 0

	ram[0x5f1] = phrase.tri_count		-- linear counter
	ram[0x5f4] = phrase.note_idx		-- duration

	ram[0x60a] = phrase.sq2 != 0		-- index 1 start
	ram[0x60b] = phrase.sq1 != 0
	ram[0x60c] = phrase.tri != 0
	ram[0x60d] = phrase.noi != 0
	ram[0x5f5] = ram[0x60d]

	ram[0x619] = phrase.env_mode		-- envelope selector


	ram[0x611] = 1		-- sq2 note reset
	ram[0x613] = 1		-- sq1 note reset
	ram[0x616] = 1		-- trg note reset
	ram[0x617] = 1		-- noi note reset
end



local music_cond = function(addr)
	return function()
		local level = ram[0x10]			-- dungeon 1-8
		if level < 1 or level > 8 then return false end


		local flag = ram[0x609] == 0x40		-- underworld music
		local fn = rom_cond(addr)

		return flag and fn()
	end
end



if first_phrase then
	local _pc, _addr = first_phrase.pc, first_phrase.addr


	local postfn = function()
		load_phrase(1)	-- start new song

		cpu.y = 0		-- reset first phrase num  (post +1 bump later)
	end


	pc_hook( _pc, 0, music_cond(_addr), nil, postfn)
end




if next_phrase then
	local _pc, _addr = next_phrase.pc, next_phrase.addr


	local postfn = function()
		local track = get_track()	-- external song data
		local index = ram[0x6c]		-- cpu.y / SongPhraseIndex


		-- loop track
		if #track.phrase < index then
			cpu.y = track.loop		-- reset phrase num

			ram[0x6c] = cpu.y		-- SongPhraseIndex
		end


		cpu.zf = 0		-- always play dungeon song
	end


	pc_hook( _pc, 0, music_cond(_addr), nil, postfn)
end




if prep_phrase then
	local _pc, _addr, _jmp = prep_phrase.pc, prep_phrase.addr, prep_phrase.jmp


	local prefn = function()
		load_phrase()

		cpu.jmp(_jmp)	-- skip entire loading block
	end


	pc_hook( _pc, 0, music_cond(_addr), prefn)
end




local load_note_hook = function(hook, channel)
	local _pc, _addr = hook.pc, hook.addr
	local _ch = channel


	local postfn = function()
		local phrase = get_phrase()
		local index = cpu.y			-- NoteOffsetSong[ch] = cpu.y


		-- read note, set bcc flags
		if     _ch == 1 then cpu.lda( phrase.sq2[index] )
		elseif _ch == 2 then cpu.lda( phrase.sq1[index] )
		elseif _ch == 3 then cpu.lda( phrase.tri[index] )
		elseif _ch == 4 then cpu.lda( phrase.noi[index] )
		end
	end


	pc_hook( _pc, 0, music_cond(_addr), nil, postfn)
end



if sq2_note1 then load_note_hook(sq2_note1, 1) end
if sq2_note2 then load_note_hook(sq2_note2, 1) end


if sq1_note1 then load_note_hook(sq1_note1, 2) end
if sq1_note2 then load_note_hook(sq1_note2, 2) end


if tri_note1 then load_note_hook(tri_note1, 3) end
if tri_note2 then load_note_hook(tri_note2, 3) end


if noi_note1 then load_note_hook(noi_note1, 4) end



if envelope then
	local _pc, _addr = envelope.pc, envelope.addr


	local prefn = function()
		local phrase = get_phrase()


		cpu.a += phrase.env_level	-- custom volume level


		cpu.skip(2)		-- ignore default level
	end


	pc_hook( _pc, 0, music_cond(_addr), prefn)
end
