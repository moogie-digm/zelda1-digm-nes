init_system = false


require(((... or ""):match("(.-)[^%.]+%.[^%.]+$") or "") .. 'utils._init')		-- parent



incsrc_critical('../emu._init')			-- Lua bridge


if not incsrc('utils.detect_version') then return false end


include 'utils' {
	'wram_overlays',
}


init_system = true
