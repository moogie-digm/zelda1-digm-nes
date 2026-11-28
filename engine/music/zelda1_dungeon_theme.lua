local phrase1 = song_t.phrase_t()


phrase1.sq2 = rom + 0x10dd - 1		-- index 1 based
phrase1.sq1 = phrase1.sq2 + 0x22
phrase1.tri = phrase1.sq2 + 0x45



local phrase2 = song_t.phrase_t()


phrase2.sq2 = rom + 0x113a - 1		-- index 1 based
phrase2.sq1 = phrase2.sq2 + 0x1c
phrase2.tri = phrase2.sq2 + 0x39




zelda1_dungeon_theme = song_t.new()
zelda1_dungeon_theme.phrase = { phrase1, phrase2 }
