/* hud.c - Heads-up display */

#include <stdint.h>
#include <arch/zx.h>
#include "hud.h"

extern void video_print_at(uint8_t row, uint8_t col, const char *str);

static char score_buf[8];

static void uint16_to_str(uint16_t val, char *buf)
{
    int8_t i;
    buf[6] = '\0';
    for (i = 5; i >= 0; i--) {
        buf[i] = '0' + (val % 10);
        val /= 10;
    }
}

static void draw_energy_bar(uint8_t row, uint8_t col, uint8_t energy)
{
    uint8_t filled = energy / 10;
    uint8_t i;
    char bar[13];

    bar[0] = '[';
    for (i = 0; i < 10; i++) {
        bar[i + 1] = (i < filled) ? '=' : ' ';
    }
    bar[11] = ']';
    bar[12] = '\0';

    video_print_at(row, col, bar);
}

void hud_draw(uint16_t score, uint8_t lives, uint8_t chrono_energy)
{
    uint16_to_str(score, score_buf);
    video_print_at(0, 0, "SC:");
    video_print_at(0, 3, score_buf);

    score_buf[0] = 'L';
    score_buf[1] = ':';
    score_buf[2] = '0' + lives;
    score_buf[3] = '\0';
    video_print_at(0, 11, score_buf);

    video_print_at(0, 16, "TM:");
    draw_energy_bar(0, 19, chrono_energy);
}
