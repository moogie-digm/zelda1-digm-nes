-- global override
if rom_version then return end



local versions = {
    [0xd7c8] = 'usa_10',
    [0xe076] = 'usa_11',
    [0xdbcb] = 'jpn',
}


-- seems to be prg checksum or similar
local region = (rom[0x1fff0] << 8) | rom[0x1fff1]



local id = 'ZELDA'

for lcv = 1,#id do
	if rom[0x1ffeb + lcv - 1] != string.byte(id, lcv) then
		region = 0
		break
	end
end



rom_version = versions[region] or 'unknown'



if rom_version == 'unknown' then
	print('error: unknown zelda1 rom')
	return false
end



print('zelda1 rom = ' .. rom_version)
return true
