/*  =============================================
 *  Chronos - ZX Spectrum Game
 *  main.c - Entry point & main game loop
 *  =============================================
 *
 *  A time-manipulation action game where the player
 *  can slow, stop, and rewind time to solve puzzles
 *  and defeat enemies.
 *
 *  Target: ZX Spectrum 48K
 *  Compiler: z88dk (zcc +zx)
 *  ============================================= */

#include <arch/zx.h>
#include <arch/zx/sp1.h>
#include <input.h>
#include <z80.h>
#include <intrinsic.h>
#include <stdint.h>
#include <string.h>

/* Project headers */
#include "player.h"
#include "levels.h"
#include "chrono.h"
#include "hud.h"

/* ---- External ASM routines ---- */
extern void video_cls(uint8_t attr);
extern void video_set_border(uint8_t color);
extern void video_print_at(uint8_t row, uint8_t col, const char *str);
extern uint8_t input_read_keys(void);
extern void sound_beep(uint16_t pitch, uint8_t duration);
extern void sound_fx_pickup(void);
extern void sound_fx_hit(void);
extern void sound_fx_timeshift(void);
extern void isr_install(void);
extern void sprite_draw(uint8_t x, uint8_t y, const uint8_t *data);
extern void sprite_draw_masked(uint8_t x, uint8_t y, const uint8_t *data, const uint8_t *mask);

/* ---- Game states ---- */
#define STATE_TITLE     0
#define STATE_PLAYING   1
#define STATE_PAUSED    2
#define STATE_GAMEOVER  3
#define STATE_LEVELWIN  4

/* ---- Global game state ---- */
static uint8_t game_state;
static uint8_t current_level;
static uint16_t score;
static uint8_t lives;
static uint8_t frame_counter;

/* ---- Title screen ---- */
static void show_title_screen(void)
{
    video_cls(INK_WHITE | PAPER_CYAN);
    video_set_border(5);

    /* Title text */
    video_print_at( 3, 10, "C H R O M E");
    video_print_at( 6, 6, "A Time-Bending Adventure");
    video_print_at(10, 7, "Controls:");
    video_print_at(12, 7, "Q/A   - Up/Down");
    video_print_at(13, 7, "O/P   - Left/Right");
    video_print_at(14, 7, "SPACE - Time Shift");
    video_print_at(15, 7, "M     - Pause");
    video_print_at(19, 5, "Press SPACE to begin...");
    video_print_at(22, 5, "(c) 2026 popa bogdan");

    /* Wait for SPACE */
    while (!(input_read_keys() & INPUT_KEY_FIRE)) {
        z80_delay_ms(50);
    }
    /* Debounce */
    z80_delay_ms(200);
}

/* ---- Game Over screen ---- */
static void show_game_over(void)
{
    video_cls(INK_RED | PAPER_CYAN);
    video_set_border(2);

    video_print_at( 8, 10, "GAME  OVER");
    video_print_at(12, 7, "Press SPACE to retry");

    sound_fx_hit();

    while (!(input_read_keys() & INPUT_KEY_FIRE)) {
        z80_delay_ms(50);
    }
    z80_delay_ms(200);
}

/* ---- Level complete screen ---- */
static void show_level_complete(void)
{
    video_cls(INK_GREEN | PAPER_CYAN);
    video_set_border(4);

    video_print_at( 8, 8, "LEVEL COMPLETE!");

    sound_fx_pickup();
    z80_delay_ms(2000);
}

/* ---- Initialize a new game ---- */
static void game_init(void)
{
    score = 0;
    lives = 3;
    current_level = 0;
    frame_counter = 0;

    player_init();
    chrono_init();
}

/* ---- Main game frame update ---- */
static void game_update(void)
{
    uint8_t keys;

    frame_counter++;
    keys = input_read_keys();

    /* Pause toggle */
    if (keys & INPUT_KEY_PAUSE) {
        game_state = STATE_PAUSED;
        return;
    }

    /* Update time mechanics */
    chrono_update(keys);

    /* Update player */
    player_update(keys);

    /* Check collisions with level geometry */
    if (level_check_collision(player_get_x(), player_get_y())) {
        player_on_hit();
        sound_fx_hit();
        if (player_get_lives() == 0) {
            game_state = STATE_GAMEOVER;
            return;
        }
    }

    /* Check level completion */
    if (level_check_exit(player_get_x(), player_get_y())) {
        current_level++;
        if (current_level >= LEVEL_COUNT) {
            game_state = STATE_GAMEOVER; /* Victory - reuse for now */
        } else {
            game_state = STATE_LEVELWIN;
        }
        return;
    }

    /* Draw frame */
    player_draw();
    hud_draw(score, lives, chrono_get_energy());
}

/* ---- Main entry point ---- */
void main(void)
{
    /* Install our IM2 interrupt handler */
    isr_install();

    /* Enable interrupts */
    intrinsic_ei();

    /* Main program loop */
    for (;;) {
        switch (game_state) {

            case STATE_TITLE:
                show_title_screen();
                game_init();
                video_cls(INK_WHITE | PAPER_CYAN);
                level_draw(current_level);
                game_state = STATE_PLAYING;
                break;

            case STATE_PLAYING:
                intrinsic_halt();   /* Sync to 50Hz frame */
                game_update();
                break;

            case STATE_PAUSED:
                video_print_at(10, 11, "** PAUSED **");
                while (input_read_keys() & INPUT_KEY_PAUSE) {
                    z80_delay_ms(50);
                }
                z80_delay_ms(200);
                game_state = STATE_PLAYING;
                break;

            case STATE_GAMEOVER:
                show_game_over();
                game_state = STATE_TITLE;
                break;

            case STATE_LEVELWIN:
                show_level_complete();
                level_load(current_level);
                player_reset_position();
                video_cls(INK_WHITE | PAPER_CYAN);
                level_draw(current_level);
                game_state = STATE_PLAYING;
                break;
        }
    }
}
