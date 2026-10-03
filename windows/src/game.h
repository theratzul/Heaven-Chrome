/* game.h - Core Game Logic & State Management for Linux */
#ifndef GAME_H
#define GAME_H

#include <stdint.h>
#include <stdbool.h>

#define GRID_WIDTH   32
#define GRID_HEIGHT  24
#define TILE_SIZE    25
#define SCREEN_W     (GRID_WIDTH * TILE_SIZE)   /* 800 */
#define SCREEN_H     (GRID_HEIGHT * TILE_SIZE)  /* 600 */

#define MAX_PARTICLES 128

typedef enum {
    STATE_TITLE,
    STATE_PLAYING,
    STATE_PAUSED,
    STATE_GAMEOVER,
    STATE_LEVELWIN,
    STATE_VICTORY
} GameState;

typedef struct {
    float x;
    float y;
    float vx;
    float vy;
    int invincible;
    int wing_frame;
} Player;

typedef struct {
    float x;
    float y;
    float vx;
    float vy;
    float life;
    float max_life;
    uint8_t r, g, b, a;
    float size;
} Particle;

typedef struct {
    GameState state;
    int current_level;
    uint32_t score;
    int lives;
    float energy;
    float max_energy;
    bool is_slow;
    float state_timer;

    Player player;
    uint8_t map[GRID_HEIGHT][GRID_WIDTH];

    Particle particles[MAX_PARTICLES];
    int particle_count;
    
    float sunray_angle;
} Game;

extern Game g_game;

void game_init(void);
void game_reset(void);
void game_start_level(int level_idx);
void game_update(float dt);
void game_handle_move(int dx, int dy);
void game_set_time_slow(bool slow);
void game_toggle_pause(void);
void game_start_or_respawn(void);
void game_spawn_particle(float x, float y, float vx, float vy, float life, uint8_t r, uint8_t g, uint8_t b, float size);

#endif /* GAME_H */
