hwn i
sub i, 1
:find_hw
hwq i
ife a, 0xBF3C
ife b, 0x42BA
set [sped], i
ifn i, 0
std pc, find_hw

set a, 1
set x, sped_data
set y, sped_data_count
hwi [sped]

sub pc, 1

:sped
res 1
:sped_data_count
dat 4
;res 1
:sped_data
dat 0x8080, 0x0180
dat 0xFF80, 0x0180
dat 0xFFFF, 0x0180
dat 0x80FF, 0x0180
;res 256
