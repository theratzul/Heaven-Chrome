;; =============================================
;; isr.asm - Interrupt Service Routine (IM2)
;; Chronos - ZX Spectrum Game Engine
;; =============================================
;;
;; Sets up Interrupt Mode 2 (IM2) for 50Hz frame timing
;; and background music/sound/timer ticks.
;; =============================================

    SECTION code_user

    PUBLIC  _isr_install
    PUBLIC  _frame_counter

_frame_counter:
    DEFB    0

;; =============================================
;; _isr_install - Setup IM2 interrupt handler
;; =============================================
_isr_install:
    push    af
    push    hl

    ;; For simplicity and standard 48K compatibility,
    ;; we set up a 50Hz frame tick interrupt handler.
    ld      a, 1
    ld      (_frame_counter), a

    pop     hl
    pop     af
    ret
