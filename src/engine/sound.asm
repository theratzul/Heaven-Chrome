;; =============================================
;; sound.asm - Beeper sound routines
;; Chronos - ZX Spectrum Game Engine
;; =============================================

    SECTION code_user

    PUBLIC  _sound_beep
    PUBLIC  _sound_fx_pickup
    PUBLIC  _sound_fx_hit
    PUBLIC  _sound_fx_timeshift
    PUBLIC  _sound_play_music

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

_sound_play_music:
    push    ix
    ld      ix, divine_melody_data
play_note_loop:
    ld      b, (ix+0)
    ld      a, b
    or      a
    jr      z, music_done

    ld      e, (ix+1)
    ld      d, (ix+2)
    inc     ix
    inc     ix
    inc     ix

    ld      a, 0
note_cycle:
    xor     0x10
    out     (BEEPER_PORT), a
    push    af

    push    de
    pop     hl
note_delay:
    dec     hl
    ld      a, h
    or      l
    jr      nz, note_delay

    pop     af
    djnz    note_cycle

    ld      hl, 1000
note_gap:
    dec     hl
    ld      a, h
    or      l
    jr      nz, note_gap

    jr      play_note_loop

music_done:
    pop     ix
    ret

divine_melody_data:
    ;; Duration (iterations), period low, period high
    ;; Heavenly Hymn Theme
    defb    50, 158, 0     ;; E4
    defb    50, 133, 0     ;; G4
    defb    50, 118, 0     ;; A4
    defb    80, 105, 0     ;; B4
    defb    90, 99,  0     ;; C5
    defb    50, 105, 0     ;; B4
    defb    50, 118, 0     ;; A4
    defb    90, 133, 0     ;; G4
    defb    50, 158, 0     ;; E4
    defb    50, 178, 0     ;; D4
    defb    110, 158, 0    ;; E4
    defb    0, 0, 0        ;; Terminator
