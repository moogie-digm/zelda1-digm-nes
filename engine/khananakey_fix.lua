--
-- Source:
-- 	The3Dude & Fiskbit
-- 
-- License:
-- 	Code should be used only for educational, documentation and modding purposes.
-- 	Please keep derivative work open source.
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- When any shutters in a room are opening, Link is allowed to phase through locked keyhole doors for about 1 full second.
-- TouchDoorWall stops further movement



-- usa-10		5:9273		TouchDoorKey
-- jpn			5:927b

local aob = {
	'a5 54',		-- lda TriggeredDoorCmd

	'$ d0 ?',		-- bne BlockUntilTime 	==> TouchDoorWall
	'ad 64 06',		-- lda InvMagicKey
	'd0 ?',			-- bne @TriggerDoor
	'ad 6e 06'		-- lda InvKeys
}

local list = { 0xd0, 0x9235 - (0x9273 + 2) }

rom_patch4(0x15273, aob, list)
