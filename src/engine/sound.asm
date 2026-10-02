;; =============================================
;; sound.asm - Beeper sound routines
;; Chronos - ZX Spectrum Game Engine
;; =============================================

    SECTION code_user

    PUBLIC  _sound_beep
    PUBLIC  _sound_fx_pickup
    PUBLIC  _sound_fx_hit
    PUBLIC  _sound_fx_timeshift

BEEPER_PORT     EQU 254

_sound_beep:
    push    ix
    ld      ix, 0
    add     ix, sp

    ld      e, (ix+4)
    ld      d, (ix+5)
    ld      b, (ix+6)

    ld      a, 0
beep_loop:
    xor     0x10
    out     (BEEPER_PORT), a
    push    af

    push    de
    pop     hl
delay_loop:
    dec     hl
    ld      a, h
    or      l
    jr      nz, delay_loop

    pop     af
    djnz    beep_loop

    pop     ix
    ret

_sound_fx_pickup:
    ld      de, 200
    ld      b, 30
    ld      a, 0

pickup_loop:
    xor     0x10
    out     (BEEPER_PORT), a
    push    af

    push    de
    pop     hl
pickup_delay:
    dec     hl
    ld      a, h
    or      l
    jr      nz, pickup_delay

    pop     af

    dec     de
    dec     de
    dec     de
    dec     de
    dec     de

    djnz    pickup_loop
    ret

_sound_fx_hit:
    ld      de, 20
    ld      b, 40
    ld      a, 0

hit_loop:
    xor     0x10
    out     (BEEPER_PORT), a
    push    af

    push    de
    pop     hl
hit_delay:
    dec     hl
    ld      a, h
    or      l
    jr      nz, hit_delay

    pop     af

    inc     de
    inc     de
    inc     de

    djnz    hit_loop
    ret

_sound_fx_timeshift:
    ld      c, 3

timeshift_outer:
    ld      de, 50
    ld      b, 20

timeshift_loop:
    ld      a, 0
    xor     0x10
    out     (BEEPER_PORT), a
    push    af

    push    de
    pop     hl
timeshift_delay:
    dec     hl
    ld      a, h
    or      l
    jr      nz, timeshift_delay

    pop     af

    ld      a, b
    and     0x04
    jr      z, ts_up
    inc     de
    inc     de
    inc     de
    inc     de
    jr      ts_cont
ts_up:
    dec     de
    dec     de
    dec     de
    dec     de
ts_cont:
    djnz    timeshift_loop

    dec     c
    jr      nz, timeshift_outer

    ret
