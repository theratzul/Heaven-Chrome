MODULE input_asm
LINE 0, "src/engine/input.asm"

;; =============================================
;; input.asm - Keyboard input routines
;; Chronos - ZX Spectrum Game Engine
;; =============================================

    SECTION code_user

    PUBLIC  _input_read_keys

PORT_ROW_SPACE  EQU 0x7FFE
PORT_ROW_QtoT   EQU 0xFBFE
PORT_ROW_AtoG   EQU 0xFDFE
PORT_ROW_PtoY   EQU 0xDFFE

_input_read_keys:
    ld      l, 0

    ld      bc, PORT_ROW_QtoT
    in      a, (c)
    bit     0, a
    jr      nz, no_up
    set     0, l
no_up:

    ld      bc, PORT_ROW_AtoG
    in      a, (c)
    bit     0, a
    jr      nz, no_down
    set     1, l
no_down:

    ld      bc, PORT_ROW_PtoY
    in      a, (c)
    bit     1, a
    jr      nz, no_left
    set     2, l
no_left:

    ld      bc, PORT_ROW_PtoY
    in      a, (c)
    bit     0, a
    jr      nz, no_right
    set     3, l
no_right:

    ld      bc, PORT_ROW_SPACE
    in      a, (c)
    bit     0, a
    jr      nz, no_fire
    set     4, l
no_fire:

    ld      bc, PORT_ROW_SPACE
    in      a, (c)
    bit     2, a
    jr      nz, no_pause
    set     5, l
no_pause:

    ret
