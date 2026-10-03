/* render.c - SDL2 Graphics, Tilemap & UI Renderer */
#include "render.h"
#include "game.h"
#include "levels_data.h"
#include "audio.h"
#include <stdio.h>
#include <math.h>

/* Minimal 8x8 bitmap font for ASCII 32 (' ') to 122 ('z') */
static const uint8_t g_font_8x8[96][8] = {
    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}, /*   */
    {0x18,0x3C,0x3C,0x18,0x18,0x00,0x18,0x00}, /* ! */
    {0x66,0x66,0x24,0x00,0x00,0x00,0x00,0x00}, /* " */
    {0x6C,0x6C,0xFE,0x6C,0xFE,0x6C,0x6C,0x00}, /* # */
    {0x18,0x3E,0x60,0x3C,0x06,0x7C,0x18,0x00}, /* $ */
    {0x00,0x66,0xA6,0xD4,0x2B,0x65,0x66,0x00}, /* % */
    {0x38,0x6C,0x38,0x76,0xDC,0xCC,0x76,0x00}, /* & */
    {0x18,0x18,0x30,0x00,0x00,0x00,0x00,0x00}, /* ' */
    {0x0C,0x18,0x30,0x30,0x30,0x18,0x0C,0x00}, /* ( */
    {0x30,0x18,0x0C,0x0C,0x0C,0x18,0x30,0x00}, /* ) */
    {0x00,0x66,0x3C,0xFF,0x3C,0x66,0x00,0x00}, /* * */
    {0x00,0x18,0x18,0x7E,0x18,0x18,0x00,0x00}, /* + */
    {0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x30}, /* , */
    {0x00,0x00,0x00,0x7E,0x00,0x00,0x00,0x00}, /* - */
    {0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x00}, /* . */
    {0x06,0x0C,0x18,0x30,0x60,0xC0,0x80,0x00}, /* / */
    {0x7C,0xC6,0xCE,0xD6,0xE6,0xC6,0x7C,0x00}, /* 0 */
    {0x18,0x38,0x18,0x18,0x18,0x18,0x7E,0x00}, /* 1 */
    {0x7C,0xC6,0x06,0x1C,0x30,0x66,0xFE,0x00}, /* 2 */
    {0x7C,0xC6,0x06,0x3C,0x06,0xC6,0x7C,0x00}, /* 3 */
    {0x1C,0x3C,0x6C,0xCC,0xFE,0x0C,0x1E,0x00}, /* 4 */
    {0xFE,0xC0,0xFC,0x06,0x06,0xC6,0x7C,0x00}, /* 5 */
    {0x7C,0xC6,0xC0,0xFC,0xC6,0xC6,0x7C,0x00}, /* 6 */
    {0xFE,0xC6,0x0C,0x18,0x30,0x30,0x30,0x00}, /* 7 */
    {0x7C,0xC6,0xC6,0x7C,0xC6,0xC6,0x7C,0x00}, /* 8 */
    {0x7C,0xC6,0xC6,0x7E,0x06,0xC6,0x7C,0x00}, /* 9 */
    {0x00,0x18,0x18,0x00,0x18,0x18,0x00,0x00}, /* : */
    {0x00,0x18,0x18,0x00,0x18,0x18,0x30,0x00}, /* ; */
    {0x0C,0x18,0x30,0x60,0x30,0x18,0x0C,0x00}, /* < */
    {0x00,0x00,0x7E,0x00,0x7E,0x00,0x00,0x00}, /* = */
    {0x30,0x18,0x0C,0x06,0x0C,0x18,0x30,0x00}, /* > */
    {0x7C,0xC6,0x0C,0x18,0x18,0x00,0x18,0x00}, /* ? */
    {0x7C,0xC6,0xDE,0xDE,0xDE,0xC0,0x78,0x00}, /* @ */
    {0x38,0x6C,0xC6,0xFE,0xC6,0xC6,0xC6,0x00}, /* A */
    {0xFC,0x66,0x66,0x7C,0x66,0x66,0xFC,0x00}, /* B */
    {0x3C,0x66,0xC0,0xC0,0xC0,0x66,0x3C,0x00}, /* C */
    {0xF8,0x6C,0x66,0x66,0x66,0x6C,0xF8,0x00}, /* D */
    {0xFE,0x62,0x68,0x78,0x68,0x62,0xFE,0x00}, /* E */
    {0xFE,0x62,0x68,0x78,0x68,0x60,0xF0,0x00}, /* F */
    {0x3C,0x66,0xC0,0xC0,0xCE,0x66,0x3E,0x00}, /* G */
    {0xC6,0xC6,0xC6,0xFE,0xC6,0xC6,0xC6,0x00}, /* H */
    {0x3C,0x18,0x18,0x18,0x18,0x18,0x3C,0x00}, /* I */
    {0x1E,0x0C,0x0C,0x0C,0xCC,0xCC,0x78,0x00}, /* J */
    {0xE6,0x66,0x6C,0x78,0x6C,0x66,0xE6,0x00}, /* K */
    {0xF0,0x60,0x60,0x60,0x62,0x66,0xFE,0x00}, /* L */
    {0xC6,0xEE,0xFE,0xFE,0xD6,0xC6,0xC6,0x00}, /* M */
    {0xC6,0xE6,0xF6,0xDE,0xCE,0xC6,0xC6,0x00}, /* N */
    {0x7C,0xC6,0xC6,0xC6,0xC6,0xC6,0x7C,0x00}, /* O */
    {0xFC,0x66,0x66,0x7C,0x60,0x60,0xF0,0x00}, /* P */
    {0x7C,0xC6,0xC6,0xC6,0xD6,0xDE,0x7C,0x06}, /* Q */
    {0xFC,0x66,0x66,0x7C,0x6C,0x66,0xE6,0x00}, /* R */
    {0x7C,0xC6,0x60,0x38,0x0C,0xC6,0x7C,0x00}, /* S */
    {0x7E,0x5A,0x18,0x18,0x18,0x18,0x3C,0x00}, /* T */
    {0xC6,0xC6,0xC6,0xC6,0xC6,0xC6,0x7C,0x00}, /* U */
    {0xC6,0xC6,0xC6,0xC6,0xC6,0x6C,0x38,0x00}, /* V */
    {0xC6,0xC6,0xD6,0xFE,0xEE,0x6C,0x44,0x00}, /* W */
    {0xC6,0xC6,0x6C,0x38,0x6C,0xC6,0xC6,0x00}, /* X */
    {0x66,0x66,0x66,0x3C,0x18,0x18,0x3C,0x00}, /* Y */
    {0xFE,0xC6,0x8C,0x18,0x32,0x66,0xFE,0x00}, /* Z */
    {0x3C,0x30,0x30,0x30,0x30,0x30,0x3C,0x00}, /* [ */
    {0xC0,0x60,0x30,0x18,0x0C,0x06,0x02,0x00}, /* \ */
    {0x3C,0x0C,0x0C,0x0C,0x0C,0x0C,0x3C,0x00}, /* ] */
    {0x10,0x38,0x6C,0xC6,0x00,0x00,0x00,0x00}, /* ^ */
    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF}, /* _ */
    {0x30,0x18,0x0C,0x00,0x00,0x00,0x00,0x00}, /* ` */
    {0x00,0x00,0x78,0x0C,0x7C,0xCC,0x76,0x00}, /* a */
    {0xE0,0x60,0x7C,0x66,0x66,0x66,0xDC,0x00}, /* b */
    {0x00,0x00,0x7C,0xC6,0xC0,0xC6,0x7C,0x00}, /* c */
    {0x1C,0x0C,0x7C,0xCC,0xCC,0xCC,0x76,0x00}, /* d */
    {0x00,0x00,0x7C,0xC6,0xFE,0xC0,0x7C,0x00}, /* e */
    {0x1C,0x36,0x30,0x78,0x30,0x30,0x78,0x00}, /* f */
    {0x00,0x00,0x76,0xCC,0xCC,0x7C,0x0C,0xF8}, /* g */
    {0xE0,0x60,0x6C,0x76,0x66,0x66,0xE6,0x00}, /* h */
    {0x18,0x00,0x38,0x18,0x18,0x18,0x3C,0x00}, /* i */
    {0x06,0x00,0x06,0x06,0x06,0x66,0x66,0x3C}, /* j */
    {0xE0,0x60,0x66,0x6C,0x78,0x6C,0xE6,0x00}, /* k */
    {0x38,0x18,0x18,0x18,0x18,0x18,0x3C,0x00}, /* l */
    {0x00,0x00,0xEC,0xFE,0xD6,0xD6,0xD6,0x00}, /* m */
    {0x00,0x00,0xDC,0x66,0x66,0x66,0x66,0x00}, /* n */
    {0x00,0x00,0x7C,0xC6,0xC6,0xC6,0x7C,0x00}, /* o */
    {0x00,0x00,0xDC,0x66,0x66,0x7C,0x60,0xF0}, /* p */
    {0x00,0x00,0x76,0xCC,0xCC,0x7C,0x0C,0x1E}, /* q */
    {0x00,0x00,0xDC,0x76,0x60,0x60,0xF0,0x00}, /* r */
    {0x00,0x00,0x7C,0xC0,0x78,0x0E,0x7C,0x00}, /* s */
    {0x30,0x30,0x7C,0x30,0x30,0x36,0x1C,0x00}, /* t */
    {0x00,0x00,0xCC,0xCC,0xCC,0xCC,0x76,0x00}, /* u */
    {0x00,0x00,0xC6,0xC6,0xC6,0x6C,0x38,0x00}, /* v */
    {0x00,0x00,0xC6,0xD6,0xFE,0xEE,0x6C,0x00}, /* w */
    {0x00,0x00,0xC6,0x6C,0x38,0x6C,0xC6,0x00}, /* x */
    {0x00,0x00,0xC6,0xC6,0xCE,0x76,0x06,0xF8}, /* y */
    {0x00,0x00,0xFE,0x8C,0x18,0x32,0xFE,0x00}  /* z */
};

void render_init(SDL_Renderer *renderer)
{
    SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
}

void render_draw_text(SDL_Renderer *renderer, int x, int y, const char *text, SDL_Color color, int scale)
{
    if (!text || scale <= 0) return;
    SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);

    int cur_x = x;
    while (*text) {
        char ch = *text++;
        if (ch == '\n') {
            cur_x = x;
            y += 9 * scale;
            continue;
        }
        if (ch >= 32 && ch <= 122) {
            const uint8_t *glyph = g_font_8x8[ch - 32];
            for (int row = 0; row < 8; ++row) {
                uint8_t bits = glyph[row];
                for (int col = 0; col < 8; ++col) {
                    if (bits & (0x80 >> col)) {
                        SDL_Rect r = {cur_x + col * scale, y + row * scale, scale, scale};
                        SDL_RenderFillRect(renderer, &r);
                    }
                }
            }
        }
        cur_x += 8 * scale;
    }
}

void render_draw_text_centered(SDL_Renderer *renderer, int y, const char *text, SDL_Color color, int scale)
{
    if (!text) return;
    int len = 0;
    while (text[len] && text[len] != '\n') len++;
    int total_width = len * 8 * scale;
    int x = (SCREEN_W - total_width) / 2;
    render_draw_text(renderer, x, y, text, color, scale);
}

static void draw_sunrays(SDL_Renderer *renderer)
{
    int cx = SCREEN_W / 2;
    int cy = -100;
    float base_angle = g_game.sunray_angle;
    int ray_count = 18;

    for (int i = 0; i < ray_count; ++i) {
        if (i % 2 == 0) continue;
        float a1 = base_angle + (float)i * (6.28318f / ray_count);
        float a2 = a1 + (6.28318f / ray_count);

        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 18);
        for (float r = 50.0f; r < 900.0f; r += 30.0f) {
            int x1 = cx + (int)(cosf(a1) * r);
            int y1 = cy + (int)(sinf(a1) * r);
            int x2 = cx + (int)(cosf(a2) * r);
            int y2 = cy + (int)(sinf(a2) * r);
            SDL_RenderDrawLine(renderer, x1, y1, x2, y2);
        }
    }
}

static void draw_tile(SDL_Renderer *renderer, int tx, int ty, uint8_t tile)
{
    int px = tx * TILE_SIZE;
    int py = ty * TILE_SIZE;

    if (tile == TILE_WALL) {
        /* Marble Block */
        SDL_Rect r = {px, py, TILE_SIZE, TILE_SIZE};
        SDL_SetRenderDrawColor(renderer, 250, 250, 240, 255);
        SDL_RenderFillRect(renderer, &r);

        /* Gold beveled border */
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &r);

        SDL_SetRenderDrawColor(renderer, 218, 165, 32, 200);
        SDL_RenderDrawLine(renderer, px + 2, py + 2, px + TILE_SIZE - 3, py + 2);
        SDL_RenderDrawLine(renderer, px + 2, py + 2, px + 2, py + TILE_SIZE - 3);
    }
    else if (tile == TILE_PLATFORM) {
        /* Cloud platform */
        SDL_Rect r = {px, py + 6, TILE_SIZE, TILE_SIZE - 10};
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 230);
        SDL_RenderFillRect(renderer, &r);

        /* Soft gold lining */
        SDL_SetRenderDrawColor(renderer, 255, 225, 100, 240);
        SDL_RenderDrawLine(renderer, px, py + 6, px + TILE_SIZE, py + 6);
    }
    else if (tile == TILE_HAZARD) {
        /* Crimson Demonic Cross */
        SDL_Rect v = {px + 10, py + 4, 5, TILE_SIZE - 8};
        SDL_Rect h = {px + 4, py + 8, TILE_SIZE - 8, 5};
        
        SDL_SetRenderDrawColor(renderer, 220, 20, 60, 255);
        SDL_RenderFillRect(renderer, &v);
        SDL_RenderFillRect(renderer, &h);

        /* Fiery outline */
        SDL_SetRenderDrawColor(renderer, 255, 100, 100, 200);
        SDL_RenderDrawRect(renderer, &v);
        SDL_RenderDrawRect(renderer, &h);
    }
    else if (tile == TILE_EXIT) {
        /* Pearly Gates */
        SDL_Rect frame = {px + 2, py + 2, TILE_SIZE - 4, TILE_SIZE - 4};
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &frame);

        /* Radiant Portal Core */
        SDL_Rect core = {px + 6, py + 6, TILE_SIZE - 12, TILE_SIZE - 12};
        SDL_SetRenderDrawColor(renderer, 224, 255, 255, 240);
        SDL_RenderFillRect(renderer, &core);

        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        SDL_RenderDrawLine(renderer, px + 8, py + 4, px + TILE_SIZE - 8, py + 4);
    }
    else if (tile == TILE_ANGEL) {
        /* Guardian Angel: Wings, Body, Halo */
        int cx = px + TILE_SIZE / 2;
        int cy = py + TILE_SIZE / 2;

        /* Golden Halo */
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawLine(renderer, cx - 4, cy - 8, cx + 4, cy - 8);

        /* Angel Wings */
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 230);
        SDL_RenderDrawLine(renderer, cx - 7, cy - 3, cx - 1, cy + 2);
        SDL_RenderDrawLine(renderer, cx + 7, cy - 3, cx + 1, cy + 2);

        /* White Robe / Core */
        SDL_Rect body = {cx - 2, cy - 4, 5, 8};
        SDL_RenderFillRect(renderer, &body);
    }
}

static void draw_player(SDL_Renderer *renderer)
{
    int px = (int)(g_game.player.x * TILE_SIZE);
    int py = (int)(g_game.player.y * TILE_SIZE);
    int cx = px + TILE_SIZE / 2;
    int cy = py + TILE_SIZE / 2;

    /* Invincibility flicker */
    if (g_game.player.invincible > 0 && (g_game.player.invincible / 4) % 2 == 0) {
        return;
    }

    /* Outer golden aura */
    SDL_SetRenderDrawColor(renderer, 255, 215, 0, 80);
    SDL_Rect aura = {cx - 10, cy - 10, 20, 20};
    SDL_RenderFillRect(renderer, &aura);

    /* Radiant Core */
    SDL_SetRenderDrawColor(renderer, 255, 245, 180, 255);
    SDL_Rect core = {cx - 6, cy - 6, 12, 12};
    SDL_RenderFillRect(renderer, &core);

    /* Pure white center */
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_Rect center = {cx - 3, cy - 3, 6, 6};
    SDL_RenderFillRect(renderer, &center);

    /* Halo */
    SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
    SDL_RenderDrawLine(renderer, cx - 5, cy - 9, cx + 5, cy - 9);
}

static void draw_hud(SDL_Renderer *renderer)
{
    /* Top HUD banner - fits cleanly within row 0 boundary (0..25px) to never overlap level tiles */
    SDL_Rect banner = {10, 2, SCREEN_W - 20, 22};
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 230);
    SDL_RenderFillRect(renderer, &banner);
    SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
    SDL_RenderDrawRect(renderer, &banner);

    char buf[64];
    SDL_Color gold = {139, 101, 8, 255};
    SDL_Color val_color = {184, 134, 11, 255};

    /* REALM */
    snprintf(buf, sizeof(buf), "REALM: %d/%d", g_game.current_level + 1, LEVEL_COUNT);
    render_draw_text(renderer, 22, 9, buf, gold, 1);

    /* FAITH */
    snprintf(buf, sizeof(buf), "FAITH: %u", g_game.score);
    render_draw_text(renderer, 170, 9, buf, val_color, 1);

    /* SOULS */
    snprintf(buf, sizeof(buf), "SOULS: %d", g_game.lives);
    render_draw_text(renderer, 330, 9, buf, gold, 1);

    /* GRACE BAR */
    render_draw_text(renderer, 440, 9, "GRACE:", gold, 1);
    SDL_Rect energy_bg = {500, 7, 100, 12};
    SDL_SetRenderDrawColor(renderer, 200, 200, 200, 180);
    SDL_RenderFillRect(renderer, &energy_bg);
    SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
    SDL_RenderDrawRect(renderer, &energy_bg);

    int fill_w = (int)((g_game.energy / g_game.max_energy) * 96.0f);
    if (fill_w > 0) {
        SDL_Rect energy_fill = {502, 9, fill_w, 8};
        SDL_SetRenderDrawColor(renderer, 255, 200, 0, 255);
        SDL_RenderFillRect(renderer, &energy_fill);
    }

    /* AUDIO STATUS */
    const char *audio_str = audio_is_muted() ? "MUTED" : "AUDIO";
    render_draw_text(renderer, 680, 9, audio_str, gold, 1);
}

void render_frame(SDL_Renderer *renderer)
{
    /* Heavenly Gradient Background */
    SDL_SetRenderDrawColor(renderer, 19, 78, 124, 255);
    SDL_RenderClear(renderer);

    for (int y = 0; y < SCREEN_H; y += 8) {
        float t = (float)y / SCREEN_H;
        uint8_t r = (uint8_t)(19 + t * (179 - 19));
        uint8_t g = (uint8_t)(78 + t * (229 - 78));
        uint8_t b = (uint8_t)(124 + t * (252 - 124));
        SDL_SetRenderDrawColor(renderer, r, g, b, 255);
        SDL_Rect band = {0, y, SCREEN_W, 8};
        SDL_RenderFillRect(renderer, &band);
    }

    /* Sunrays */
    draw_sunrays(renderer);

    /* Render Level Grid */
    for (int y = 0; y < GRID_HEIGHT; ++y) {
        for (int x = 0; x < GRID_WIDTH; ++x) {
            uint8_t tile = g_game.map[y][x];
            if (tile != TILE_EMPTY) {
                draw_tile(renderer, x, y, tile);
            }
        }
    }

    /* Render Particles */
    for (int i = 0; i < g_game.particle_count; ++i) {
        Particle *p = &g_game.particles[i];
        SDL_SetRenderDrawColor(renderer, p->r, p->g, p->b, p->a);
        SDL_Rect pr = {(int)p->x, (int)p->y, (int)p->size, (int)p->size};
        SDL_RenderFillRect(renderer, &pr);
    }

    /* Render Player */
    if (g_game.state == STATE_PLAYING || g_game.state == STATE_PAUSED || g_game.state == STATE_LEVELWIN) {
        draw_player(renderer);
        draw_hud(renderer);
    }

    /* Screen Overlays */
    SDL_Color white = {255, 255, 255, 255};
    SDL_Color gold = {255, 215, 0, 255};
    SDL_Color blue = {30, 136, 229, 255};
    SDL_Color dark = {139, 101, 8, 255};

    if (g_game.state == STATE_TITLE) {
        SDL_Rect box = {100, 50, 600, 500};
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 235);
        SDL_RenderFillRect(renderer, &box);
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &box);

        render_draw_text_centered(renderer, 80, "HEAVEN CHROME", dark, 3);
        render_draw_text_centered(renderer, 125, "A Divine Time-Bending Journey", blue, 2);
        render_draw_text_centered(renderer, 155, "BY POPA BOGDAN", gold, 1);

        /* Controls Panel */
        SDL_Rect c_box = {140, 185, 520, 175};
        SDL_SetRenderDrawColor(renderer, 255, 248, 220, 255);
        SDL_RenderFillRect(renderer, &c_box);
        SDL_SetRenderDrawColor(renderer, 218, 165, 32, 255);
        SDL_RenderDrawRect(renderer, &c_box);

        render_draw_text(renderer, 170, 205, "MOVE:       WASD / Arrows / Gamepad D-Pad", dark, 1);
        render_draw_text(renderer, 170, 235, "SLOW TIME:  Hold SPACE / Gamepad [A]", dark, 1);
        render_draw_text(renderer, 170, 265, "PAUSE:      P / Escape / Controller [Start]", dark, 1);
        render_draw_text(renderer, 170, 295, "MUTE AUDIO: M Key / Controller [Y]", dark, 1);
        render_draw_text(renderer, 170, 325, "OBJECTIVE:  Ascend 20 Divine Realms to Paradise", dark, 1);

        /* Action button */
        SDL_Rect btn = {140, 390, 520, 52};
        SDL_SetRenderDrawColor(renderer, 255, 200, 0, 255);
        SDL_RenderFillRect(renderer, &btn);
        SDL_SetRenderDrawColor(renderer, 218, 165, 32, 255);
        SDL_RenderDrawRect(renderer, &btn);

        render_draw_text_centered(renderer, 408, "PRESS SPACE OR [A] TO ASCEND", white, 2);
        render_draw_text_centered(renderer, 465, "Steam Deck & Gamepad Ready", gold, 1);
        render_draw_text_centered(renderer, 490, "Press [M] to Toggle Audio", dark, 1);
    }
    else if (g_game.state == STATE_PAUSED) {
        SDL_Rect box = {180, 170, 440, 240};
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 230);
        SDL_RenderFillRect(renderer, &box);
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &box);

        render_draw_text_centered(renderer, 210, "CONTEMPLATION", dark, 3);
        render_draw_text_centered(renderer, 260, "Journey Paused", blue, 2);
        render_draw_text_centered(renderer, 310, "Press P, SPACE, or [A] to Resume", dark, 1);
        render_draw_text_centered(renderer, 340, "Press M or [Y] to Toggle Audio", gold, 1);
    }
    else if (g_game.state == STATE_GAMEOVER) {
        SDL_Rect box = {130, 140, 540, 290};
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 235);
        SDL_RenderFillRect(renderer, &box);
        SDL_SetRenderDrawColor(renderer, 220, 20, 60, 255);
        SDL_RenderDrawRect(renderer, &box);

        SDL_Color red = {220, 20, 60, 255};
        render_draw_text_centered(renderer, 175, "FALLEN", red, 4);
        render_draw_text_centered(renderer, 230, "Your soul yearns to ascend again", dark, 1);

        char stats[64];
        snprintf(stats, sizeof(stats), "Reached Realm %d  -  Faith Score: %u", g_game.current_level + 1, g_game.score);
        render_draw_text_centered(renderer, 260, stats, blue, 1);

        SDL_Rect r_btn = {140, 310, 520, 48};
        SDL_SetRenderDrawColor(renderer, 220, 20, 60, 255);
        SDL_RenderFillRect(renderer, &r_btn);
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &r_btn);

        render_draw_text_centered(renderer, 326, "PRESS SPACE OR [A] TO RESURRECT", white, 2);
    }
    else if (g_game.state == STATE_LEVELWIN) {
        SDL_Rect box = {180, 200, 440, 180};
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 235);
        SDL_RenderFillRect(renderer, &box);
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &box);

        render_draw_text_centered(renderer, 230, "REALM CLEARED!", gold, 3);
        char buf[64];
        snprintf(buf, sizeof(buf), "Ascending to Realm %d of %d...", g_game.current_level + 2, LEVEL_COUNT);
        render_draw_text_centered(renderer, 280, buf, blue, 1);
    }
    else if (g_game.state == STATE_VICTORY) {
        SDL_Rect box = {140, 120, 520, 340};
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 240);
        SDL_RenderFillRect(renderer, &box);
        SDL_SetRenderDrawColor(renderer, 255, 215, 0, 255);
        SDL_RenderDrawRect(renderer, &box);

        render_draw_text_centered(renderer, 150, "PARADISE ATTAINED!", gold, 3);
        render_draw_text_centered(renderer, 200, "All 20 Heavenly Realms Conquered", blue, 1);

        char buf[64];
        snprintf(buf, sizeof(buf), "FINAL FAITH SCORE: %u", g_game.score);
        render_draw_text_centered(renderer, 250, buf, dark, 2);

        render_draw_text_centered(renderer, 320, "PRESS SPACE OR [A] TO PLAY AGAIN", gold, 1);
    }

    SDL_RenderPresent(renderer);
}
