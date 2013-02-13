hwn i
sub i, 1
:hw_find
hwq i
ife a, 0xF615
ife b, 0x7349
set [lem], i
ife a, 0xB402
ife b, 0x12D0
set [clk], i
ifn i, 0
std pc, hw_find

set i, vram
set j, 'A'
ias interrupt

set a, 0
set b, vram
hwi [lem]

set a, 0
set b, 60
hwi [clk]

set a, 2
set b, 1
hwi [clk]

sub pc, 1

:interrupt
sti [i], j
rfi 0

:vram
res 384
:lem
res 1
:clk
res 1
