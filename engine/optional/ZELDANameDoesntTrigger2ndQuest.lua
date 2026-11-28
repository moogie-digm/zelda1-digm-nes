-- Redux = ZELDA name doesn't trigger 2nd Quest



-- usa-10		2:9f6a		@CompareToZelda
-- jpn			2:a1ab

local aob = {
	'aa',			-- tax
	'a0 00',		-- ldy #$00

	'$ a9 01',		-- lda #$01		<-- 2nd quest flag
	'91 cc',		-- sta (QuestPointer),y
}

local list = { 0xa9, 0x00 }		-- 1st quest

rom_patch4(0x9f6a, aob, list)
