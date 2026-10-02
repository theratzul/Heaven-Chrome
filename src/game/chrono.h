/* chrono.h - Time manipulation mechanics */

#ifndef CHRONO_H
#define CHRONO_H

#include <stdint.h>

/* Time states */
#define TIME_NORMAL     0
#define TIME_SLOW       1
#define TIME_STOP       2
#define TIME_REWIND     3

void    chrono_init(void);
void    chrono_update(uint8_t keys);
uint8_t chrono_get_state(void);
uint8_t chrono_get_energy(void);
uint8_t chrono_is_slowmo(void);

#endif /* CHRONO_H */
