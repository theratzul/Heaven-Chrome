/* levels.h - Level data and management */

#ifndef LEVELS_H
#define LEVELS_H

#include <stdint.h>

#define LEVEL_COUNT    20
#define LEVEL_WIDTH    32
#define LEVEL_HEIGHT   24

/* Tile types */
#define TILE_EMPTY      0
#define TILE_WALL       1
#define TILE_PLATFORM   2
#define TILE_HAZARD     3
#define TILE_EXIT       4
#define TILE_PICKUP     5

void    level_load(uint8_t level_num);
void    level_draw(uint8_t level_num);
uint8_t level_check_collision(uint8_t x, uint8_t y);
uint8_t level_check_exit(uint8_t x, uint8_t y);
uint8_t level_get_tile(uint8_t x, uint8_t y);

#endif /* LEVELS_H */
