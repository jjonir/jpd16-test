:start
set a, 0xB402
set b, 0x12D0
set c, clks
jsr find_hw_unsafe
ife a, 0
set pc, no_clks_found
ifg a, 10
set pc, too_many_clks
set [num_clks], a

set a, 0xF615
set b, 0x7349
set c, lem
jsr find_hw_unsafe
ife a, 0
set pc, no_lems_found
ifg a, 1
set pc, too_many_lems

ias interrupt

set i, 0
:clk_start_loop
ife i, [num_clks]
set pc, clk_start_loop_end

set a, 0     ; enable/set period
set b, 300   ; (300/60)s
hwi [clks+i] ; turn on the clock, period 5s

set a, 2     ; enable int/set msg
set b, i
add b, 1     ; clk index + 1
hwi [clks+i] ; turn on clk interrupt, msg (i+1)

set [clk_int_counts+i], 0

sti pc, clk_start_loop

:clk_start_loop_end

set a, 0     ; enable/map vram
set b, vram  ; vram location
hwi [lem]    ; turn on lem, map vram

set a, 0
:disp_clks
jsr disp_clk
add a, 1
ifl a, [num_clks]
set pc, disp_clks
set a, 0
set pc, disp_clks

set pc, stop

:no_clks_found
:too_many_clks
:no_lems_found
:too_many_lems

:stop
set pc, stop

:interrupt
ifl a, num_clks
jsr clk_int
rfi 0

:clk_int
sub a, 1
add [clk_int_counts+a], 1
set pc, pop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; disp_clk
; A: clock to print
; returns: none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:disp_clk
set push, c
set push, b
set push, a

set c, a

set a, clock_string
set b, 0
jsr print_string
set a, c
set b, 6
jsr print_int

set a, ints_string
set b, 9
jsr print_string
set a, [clk_int_counts+c]
set b, 15
jsr print_int

set a, ticks_string
set b, 20
jsr print_string
set a, 1     ; get ticks
set push, c
hwi [clks+c] ; get ticks for clk c
set a, c     ; ticks returned in c
set c, pop
set b, 27
jsr print_int

set a, pop
set b, pop
set c, pop
set pc, pop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print_string
; A: address of string, nul-terminated
; B, C: x, y position to print
; returns: A: characters printed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:print_string
set push, j
set push, i

set i, a
set j, c
shl j, 5
add j, b
add j, vram

:print_string_loop
ife [i], 0
set pc, print_string_end
set [j], [i]
sti pc, print_string_loop

:print_string_end
set a, i
set i, pop
set j, pop
set pc, pop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print_int
; A: integer to print
; B, C: x, y position to print
; returns: A: characters printed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:print_int
set push, j
set push, i
sub sp, 6    ; reserve 6 bytes for str

set i, sp
:print_int_loop
set [i], a
mod [i], 10
add [i], '0'
div a, 10
ifn a, 0
sti pc, print_int_loop
set [i+1], 0 ; nul-terminate the string

set a, sp
jsr print_string

add sp, 6
set i, pop
set j, pop
set pc, pop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find_hw_safe
; A, B: hw id to find
; C: start addr to store matching hw nums
; return: A: find count
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:find_hw_safe
set push, j
set push, i
set push, z
set push, y
set push, x

jsr find_hw_unsafe

set x, pop
set y, pop
set z, pop
set i, pop
set j, pop
set pc, pop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find_hw_unsafe
; use this if you don't care about
;  preserving registers, for example
;  at the start of bootloading etc.
; A, B: hw id to find
; C: start addr to store matching hw nums
; return: A: find count
; destroys: X, Y, Z, I, J
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:find_hw_unsafe
set push, c
set push, b
set push, a

set z, c
hwn i
sub i, 1
:find_hw_loop
hwq i
ife a, [sp+0]
ife b, [sp+1]
set pc, find_hw_match
set pc, find_hw_no_match
:find_hw_match
set [z], i
add z, 1
:find_hw_no_match
ifn i, 0
std pc, find_hw_loop

set a, z
sub a, [sp+2]
set b, pop
set b, pop
set c, pop
set pc, pop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; const data/strings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:clock_string
dat "Clock: ", 0
:ints_string
dat "ints: ", 0
:ticks_string
dat "ticks: ", 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:clks
res 10
:clk_int_counts
res 10
:num_clks
res 1
:lem
res 1
:vram
res 0x180
