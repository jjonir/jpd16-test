ias interrupt
set a, 0x10
int 0x20
sub pc, 1
:interrupt
set c, 0x30
rfi 0 ; ignores its argument
sub pc, 1
