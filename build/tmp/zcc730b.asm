MODULE video_asm
LINE 0, "src/engine/video.asm"

;; =============================================
;; video.asm - Screen/attribute buffer helpers
;; Chronos - ZX Spectrum Game Engine
;; =============================================

    SECTION code_user

    PUBLIC  _video_cls
    PUBLIC  _video_set_border
    PUBLIC  _video_print_at

SCREEN_START    EQU 16384
SCREEN_SIZE     EQU 6144
ATTR_START      EQU 22528
ATTR_SIZE       EQU 768
BORDER_PORT     EQU 254

_video_cls:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      a, (ix+4)
    push    af

    ld      hl, SCREEN_START
    ld      de, SCREEN_START + 1
    ld      bc, SCREEN_SIZE - 1
    ld      (hl), 0
    ldir

    pop     af
    ld      hl, ATTR_START
    ld      de, ATTR_START + 1
    ld      bc, ATTR_SIZE - 1
    ld      (hl), a
    ldir

    pop     ix
    ret

_video_set_border:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      a, (ix+4)
    and     7
    out     (BORDER_PORT), a

    pop     ix
    ret

_video_print_at:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      a, (ix+4)           ; row
    ld      c, (ix+5)           ; col
    ld      l, (ix+6)           ; str low
    ld      h, (ix+7)           ; str high

    push    hl                  ; save str pointer on stack
    call    calc_screen_addr    ; returns HL = screen address
    ex      de, hl              ; DE = screen address
    pop     hl                  ; HL = str pointer

print_loop:
    ld      a, (hl)
    or      a
    jr      z, print_done
    inc     hl
    push    hl                  ; save str pointer for next char

    ;; Calculate font address: 0x3D00 + (A - 32) * 8
    sub     32
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      bc, 0x3D00
    add     hl, bc

    ;; Copy 8 scanlines to screen address in DE
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     d

    ld      a, (hl)
    ld      (de), a

    ;; Restore D back to scanline 0, advance column in E
    ld      a, d
    sub     7
    ld      d, a
    inc     e

    pop     hl                  ; restore str pointer
    jr      print_loop

print_done:
    pop     ix
    ret

calc_screen_addr:
    ld      b, a
    and     0x18
    or      0x40
    ld      h, a

    ld      a, b
    and     0x07
    rrca
    rrca
    rrca
    or      c
    ld      l, a

    ret
