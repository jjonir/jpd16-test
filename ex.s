set a, 0
set b, 2
add a, b
sub b, 0x01
set c, ex
:loop
set pc, loop ; comment
;set pc, foo
dat 0x10c0
dat "stringinging",0
dat 'c','h','a','r',0
hwi z
hwn [a+10]
set push, b
add c, peek
set a, pop
set i, pick[1]
