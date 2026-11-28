song_t = {}



song_t.new = function(loop, phrase)
	return {
		loop = loop or 1,	-- first phrase
		phrase = phrase or nil,
	}
end



song_t.phrase_t = function(sq1, sq2, tri, noise, note_idx, env_mode, env_level, tri_count)
	return {
		sq1 = sq1 or 0,		-- 0 = unused; 1+ = valid ptr
		sq2 = sq2 or 0,
		tri = tri or 0,
		noi = noise or 0,


		-- NoteLengthTable
		note_idx = note_idx or 0,		-- 5 tables x 8 notes each  [0x00, 0x08, 0x10, ..]


		-- ShapeSongVolume
		env_mode = env_mode or 0,			-- CustomEnvelopeSong = high nybble (00), low nybble (80)
		env_level = env_level or 0x90,		-- volume level = 50% default


		-- @SetTrgLinear
		tri_count = tri_count or 0,			-- linear counter
	}
end



song_t.clone = function(src)
	local copy = song_t.new(src.loop, {})

	-- shallow clone due to ffi
	for i, p in ipairs(src.phrase) do
		local p_copy = {}
		for k, v in pairs(p) do
			p_copy[k] = v
		end
		copy.phrase[i] = p_copy
	end

	return copy
end




include '.' {
	'zelda1_dungeon_theme',

	'new_light_theme',				-- gzip
	'perils_darkness_theme',		-- The3Dude
	'triforce_power_theme',			-- matrixz
}
