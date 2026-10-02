/* player.h - Player state and mechanics */

#ifndef PLAYER_H
#define PLAYER_H

#include <stdint.h>

/* Input key bitmasks */
#define INPUT_KEY_UP     0x01
#define INPUT_KEY_DOWN   0x02
#define INPUT_KEY_LEFT   0x04
#define INPUT_KEY_RIGHT  0x08
#define INPUT_KEY_FIRE   0x10
#define INPUT_KEY_PAUSE  0x20

void    player_init(void);
void    player_update(uint8_t keys);
void    player_draw(void);
void    player_on_hit(void);
void    player_reset_position(void);
uint8_t player_get_x(void);
uint8_t player_get_y(void);
uint8_t player_get_lives(void);

#endif /* PLAYER_H */
