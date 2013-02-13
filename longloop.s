set a, 0
set b, 1
set c, 2
set x, 3
set y, 4
set z, 5
set i, 6
set j, 7
:loop1
ifn j, 0
std pc, loop1
set i, 5
:loop2
set a, a
set b, b
set c, c
set x, y
ifn i, 0
std pc, loop2
sub pc, 1
