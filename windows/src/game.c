/* game.c - Core Game Logic & State Management for Linux */
#include "game.h"
#include "levels_data.h"
#include "audio.h"
#include <string.h>
#include <stdlib.h>
#include <math.h>

Game g_game;

void game_spawn_particle(float x, float y, float vx, float vy, float life, uint8_t r, uint8_t g, uint8_t b, float size)
{
    if (g_game.particle_count >= MAX_PARTICLES) return;
    Particle *p = &g_game.particles[g_game.particle_count++];
    p->x = x;
    p->y = y;
    p->vx = vx;
    p->vy = vy;
    p->life = life;
    p->max_life = life;
    p->r = r;
    p->g = g;
    p->b = b;
    p->a = 255;
    p->size = size;
}

void game_init(void)
{
    memset(&g_game, 0, sizeof(Game));
    g_game.state = STATE_TITLE;
    g_game.current_level = 0;
    g_game.score = 0;
    g_game.lives = 3;
    g_game.energy = 100.0f;
    g_game.max_energy = 100.0f;
    g_game.is_slow = false;
    g_game.sunray_angle = 0.0f;
}

void game_reset(void)
{
    g_game.current_level = 0;
    g_game.score = 0;
    g_game.lives = 3;
    g_game.energy = 100.0f;
    g_game.is_slow = false;
    audio_set_time_slow(false);
    game_start_level(0);
    g_game.state = STATE_PLAYING;
}

void game_start_level(int level_idx)
{
    if (level_idx < 0) level_idx = 0;
    if (level_idx >= LEVEL_COUNT) level_idx = LEVEL_COUNT - 1;

    g_game.current_level = level_idx;
    memcpy(g_game.map, g_levels[level_idx], sizeof(g_game.map));

    /* Reset player to standard start position */
    g_game.player.x = 2.0f;
    g_game.player.y = 20.0f;
    g_game.player.vx = 0.0f;
    g_game.player.vy = 0.0f;
    g_game.player.invincible = 60;
    g_game.is_slow = false;
    audio_set_time_slow(false);

    /* Burst particles at entrance */
    for (int i = 0; i < 20; ++i) {
        float angle = (float)rand() / (float)RAND_MAX * 6.28318f;
        float spd = 20.0f + (float)rand() / (float)RAND_MAX * 40.0f;
        game_spawn_particle(
            g_game.player.x * TILE_SIZE + TILE_SIZE / 2,
            g_game.player.y * TILE_SIZE + TILE_SIZE / 2,
            cosf(angle) * spd, sinf(angle) * spd,
            0.6f + (float)rand() / (float)RAND_MAX * 0.4f,
            255, 235, 120, 4.0f
        );
    }
}

void game_set_time_slow(bool slow)
{
    if (g_game.state != STATE_PLAYING) return;

    if (slow && g_game.energy > 5.0f) {
        if (!g_game.is_slow) {
            audio_play_time_shift();
        }
        g_game.is_slow = true;
        audio_set_time_slow(true);
    } else {
        g_game.is_slow = false;
        audio_set_time_slow(false);
    }
}

void game_toggle_pause(void)
{
    if (g_game.state == STATE_PLAYING) {
        g_game.state = STATE_PAUSED;
    } else if (g_game.state == STATE_PAUSED) {
        g_game.state = STATE_PLAYING;
    }
}

void game_start_or_respawn(void)
{
    if (g_game.state == STATE_TITLE) {
        game_reset();
    } else if (g_game.state == STATE_PAUSED) {
        g_game.state = STATE_PLAYING;
    } else if (g_game.state == STATE_GAMEOVER) {
        game_reset();
    } else if (g_game.state == STATE_VICTORY) {
        g_game.state = STATE_TITLE;
    }
}

void game_handle_move(int dx, int dy)
{
    if (g_game.state != STATE_PLAYING) return;

    float speed = 5.2f;
    g_game.player.vx = dx * speed;
    g_game.player.vy = dy * speed;
}

void game_update(float dt)
{
    g_game.sunray_angle += dt * 0.15f;
    if (g_game.sunray_angle > 6.28318f) g_game.sunray_angle -= 6.28318f;

    /* Update existing particles */
    for (int i = 0; i < g_game.particle_count; ) {
        Particle *p = &g_game.particles[i];
        p->life -= dt;
        if (p->life <= 0.0f) {
            g_game.particles[i] = g_game.particles[--g_game.particle_count];
            continue;
        }
        p->x += p->vx * dt;
        p->y += p->vy * dt;
        p->a = (uint8_t)((p->life / p->max_life) * 255);
        i++;
    }

    if (g_game.state == STATE_LEVELWIN) {
        g_game.state_timer -= dt;
        if (g_game.state_timer <= 0.0f) {
            g_game.current_level++;
            if (g_game.current_level >= LEVEL_COUNT) {
                g_game.state = STATE_VICTORY;
            } else {
                game_start_level(g_game.current_level);
                g_game.state = STATE_PLAYING;
            }
        }
        return;
    }

    if (g_game.state != STATE_PLAYING) {
        return;
    }

    /* Divine Time Shift energy management */
    if (g_game.is_slow) {
        g_game.energy -= dt * 25.0f;
        if (g_game.energy <= 0.0f) {
            g_game.energy = 0.0f;
            g_game.is_slow = false;
            audio_set_time_slow(false);
        }
    } else {
        if (g_game.energy < g_game.max_energy) {
            g_game.energy += dt * 15.0f;
            if (g_game.energy > g_game.max_energy) g_game.energy = g_game.max_energy;
        }
    }

    if (g_game.player.invincible > 0) {
        g_game.player.invincible--;
    }

    /* Move player */
    float target_x = g_game.player.x + g_game.player.vx * dt;
    float target_y = g_game.player.y + g_game.player.vy * dt;

    /* Boundary collision */
    if (target_x < 1.0f) target_x = 1.0f;
    if (target_x > GRID_WIDTH - 2.0f) target_x = GRID_WIDTH - 2.0f;
    if (target_y < 1.0f) target_y = 1.0f;
    if (target_y > GRID_HEIGHT - 2.0f) target_y = GRID_HEIGHT - 2.0f;

    /* Move player with axis-independent collision: walls & platforms are impassable obstacles */
    int test_x = (int)(target_x + 0.5f);
    int curr_y = (int)(g_game.player.y + 0.5f);
    uint8_t tile_x = g_game.map[curr_y][test_x];
    if (tile_x != TILE_WALL && tile_x != TILE_PLATFORM) {
        g_game.player.x = target_x;
    }

    int curr_x = (int)(g_game.player.x + 0.5f);
    int test_y = (int)(target_y + 0.5f);
    uint8_t tile_y = g_game.map[test_y][curr_x];
    if (tile_y != TILE_WALL && tile_y != TILE_PLATFORM) {
        g_game.player.y = target_y;
    }

    int tile_x_pos = (int)(g_game.player.x + 0.5f);
    int tile_y_pos = (int)(g_game.player.y + 0.5f);
    uint8_t tile = g_game.map[tile_y_pos][tile_x_pos];

    /* Check Angel Collectible */
    if (tile == TILE_ANGEL) {
        g_game.map[tile_y][tile_x] = TILE_EMPTY;
        g_game.score += 500;
        audio_play_angel_chime();

        /* Angel sparkle burst */
        for (int i = 0; i < 30; ++i) {
            float angle = (float)rand() / (float)RAND_MAX * 6.28318f;
            float spd = 30.0f + (float)rand() / (float)RAND_MAX * 60.0f;
            game_spawn_particle(
                tile_x * TILE_SIZE + TILE_SIZE / 2,
                tile_y * TILE_SIZE + TILE_SIZE / 2,
                cosf(angle) * spd, sinf(angle) * spd,
                0.8f, 255, 215, 0, 5.0f
            );
        }
    }

    /* Check Exit Gate */
    if (tile == TILE_EXIT) {
        g_game.score += 1000;
        audio_play_level_win();
        g_game.state = STATE_LEVELWIN;
        g_game.state_timer = 1.6f;

        for (int i = 0; i < 40; ++i) {
            float angle = (float)rand() / (float)RAND_MAX * 6.28318f;
            float spd = 40.0f + (float)rand() / (float)RAND_MAX * 80.0f;
            game_spawn_particle(
                g_game.player.x * TILE_SIZE + TILE_SIZE / 2,
                g_game.player.y * TILE_SIZE + TILE_SIZE / 2,
                cosf(angle) * spd, sinf(angle) * spd,
                1.2f, 255, 255, 255, 6.0f
            );
        }
        return;
    }

    /* Check Hazard Collision */
    if (tile == TILE_HAZARD && g_game.player.invincible == 0) {
        g_game.lives--;
        audio_play_hazard_hit();

        /* Red particle burst */
        for (int i = 0; i < 25; ++i) {
            float angle = (float)rand() / (float)RAND_MAX * 6.28318f;
            float spd = 20.0f + (float)rand() / (float)RAND_MAX * 50.0f;
            game_spawn_particle(
                g_game.player.x * TILE_SIZE + TILE_SIZE / 2,
                g_game.player.y * TILE_SIZE + TILE_SIZE / 2,
                cosf(angle) * spd, sinf(angle) * spd,
                0.6f, 255, 50, 50, 4.0f
            );
        }

        if (g_game.lives <= 0) {
            g_game.state = STATE_GAMEOVER;
        } else {
            /* Reset to start of level */
            g_game.player.x = 2.0f;
            g_game.player.y = 20.0f;
            g_game.player.invincible = 90;
        }
    }

    /* Floating light trail particles behind player */
    if (rand() % 3 == 0) {
        game_spawn_particle(
            g_game.player.x * TILE_SIZE + TILE_SIZE / 2 + ((float)rand() / RAND_MAX * 8.0f - 4.0f),
            g_game.player.y * TILE_SIZE + TILE_SIZE / 2 + ((float)rand() / RAND_MAX * 8.0f - 4.0f),
            -g_game.player.vx * 0.2f, -g_game.player.vy * 0.2f,
            0.5f,
            255, 240, 180, 3.5f
        );
    }
}
