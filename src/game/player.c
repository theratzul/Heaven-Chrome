/* player.c - Player state and movement mechanics */

#include <stdint.h>
#include "player.h"

/* Player sprite data (8x8 pixel character) */
static const uint8_t player_sprite[] = {
    0x18,  /* ...##... */
    0x3C,  /* ..####.. */
    0x7E,  /* .######. */
    0x5A,  /* .#.##.#. */
    0x7E,  /* .######. */
    0x24,  /* ..#..#.. */
    0x24,  /* ..#..#.. */
    0x66   /* .##..##. */
};

/* Extern ASM drawing routine */
extern void sprite_draw(uint8_t x, uint8_t y, const uint8_t *data);
extern void sprite_erase(uint8_t x, uint8_t y);

/* Player state */
static uint8_t px, py;          /* Position in character coords (0-31, 0-23) */
static uint8_t old_px, old_py;  /* Previous position for erasing */
static uint8_t lives;
static uint8_t invincible;      /* Invincibility frames after hit */
static uint8_t facing;          /* 0=right, 1=left */
static uint8_t start_x, start_y;

#define PLAYER_SPEED    1
#define INVINCIBLE_TIME 50       /* ~1 second at 50fps */

void player_init(void)
{
    start_x = 2;
    start_y = 20;
    px = start_x;
    py = start_y;
    old_px = start_x;
    old_py = start_y;
    lives = 3;
    invincible = 0;
    facing = 0;
}

void player_update(uint8_t keys)
{
    /* Decrement invincibility counter */
    if (invincible > 0) {
        invincible--;
    }

    old_px = px;
    old_py = py;

    /* Movement */
    if ((keys & INPUT_KEY_UP) && py > 1) {
        py -= PLAYER_SPEED;
    }
    if ((keys & INPUT_KEY_DOWN) && py < 22) {
        py += PLAYER_SPEED;
    }
    if ((keys & INPUT_KEY_LEFT) && px > 0) {
        px -= PLAYER_SPEED;
        facing = 1;
    }
    if ((keys & INPUT_KEY_RIGHT) && px < 31) {
        px += PLAYER_SPEED;
        facing = 0;
    }
}

void player_draw(void)
{
    /* Flash when invincible (skip draw on odd frames) */
    if (invincible > 0 && (invincible & 1)) {
        return;
    }
    
    if (old_px != px || old_py != py) {
        sprite_erase(old_px, old_py);
    }
    sprite_draw(px, py, player_sprite);
}

void player_on_hit(void)
{
    if (invincible > 0) return;  /* Already invincible, ignore */

    if (lives > 0) {
        lives--;
    }
    invincible = INVINCIBLE_TIME;

    sprite_erase(px, py);

    /* Knock player back to start of level */
    px = start_x;
    py = start_y;
    old_px = start_x;
    old_py = start_y;
}

void player_reset_position(void)
{
    px = start_x;
    py = start_y;
    invincible = 0;
}

uint8_t player_get_x(void)      { return px; }
uint8_t player_get_y(void)      { return py; }
uint8_t player_get_lives(void)  { return lives; }
