;; =============================================
;; sprites.asm - Sprite drawing routines
;; Chronos - ZX Spectrum Game Engine
;; =============================================

    SECTION code_user

    PUBLIC  _sprite_draw
    PUBLIC  _sprite_draw_masked
    PUBLIC  _sprite_erase

_sprite_erase:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      c, (ix+4)           ; x (column)
    ld      a, (ix+5)           ; y (row)

    call    sprite_calc_addr

    ld      b, 8                ; 8 scanlines

erase_loop:
    ld      (hl), 0             ; Write 0 to screen
    inc     h                   ; Next scanline (H += 1 = +256 bytes)
    djnz    erase_loop

    pop     ix
    ret

_sprite_draw:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      c, (ix+4)           ; x (column)
    ld      a, (ix+5)           ; y (row)
    ld      e, (ix+6)           ; data pointer low
    ld      d, (ix+7)           ; data pointer high

    call    sprite_calc_addr

    ld      b, 8                ; 8 scanlines

draw_loop:
    ld      a, (de)             ; Get sprite byte
    or      (hl)                ; OR with existing screen
    ld      (hl), a             ; Write to screen
    inc     de                  ; Next sprite byte
    inc     h                   ; Next scanline (H += 1 = +256 bytes)
    djnz    draw_loop

    pop     ix
    ret

_sprite_draw_masked:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      c, (ix+4)           ; x (column)
    ld      a, (ix+5)           ; y (row)
    ld      e, (ix+6)           ; data pointer low
    ld      d, (ix+7)           ; data pointer high
    ld      l, (ix+8)           ; mask low
    ld      h, (ix+9)           ; mask high
    push    hl                  ; Save mask on stack
    push    de                  ; Save data on stack

    call    sprite_calc_addr    ; Returns HL = screen address

    pop     de                  ; DE = data pointer
    pop     ix                  ; IX = mask pointer

    ld      b, 8

mask_loop:
    ld      a, (de)
    ld      c, a
    ld      a, (ix+0)
    and     (hl)
    or      c
    ld      (hl), a

    inc     de
    inc     ix
    inc     h

    djnz    mask_loop

    pop     ix                  ; restore caller's IX
    ret

sprite_calc_addr:
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
