---------------------------------------
-- Zelda: Perils of Darkness music track notes by The3Dude


perils_darkness_dungeon_theme = song_t.clone(zelda1_dungeon_theme)


for _, phrase in ipairs(perils_darkness_dungeon_theme.phrase) do
	phrase.env_level = 0x30
end
