/* chrono.c - Time manipulation mechanics
 *
 * The core mechanic of Chronos: the player can manipulate time.
 * - Hold FIRE to slow time (enemies move at half speed)
 * - This costs chrono energy, which recharges over time
 * - At higher levels, more time powers unlock
 */

#include <stdint.h>
#include "chrono.h"
#include "player.h"

extern void sound_fx_timeshift(void);

/* Chrono state */
static uint8_t time_state;
static uint8_t energy;          /* 0-100 chrono energy */
static uint8_t recharge_timer;

#define MAX_ENERGY       100
#define SLOW_COST        2      /* Energy cost per frame for slow-mo */
#define RECHARGE_RATE    1      /* Energy gained per recharge tick */
#define RECHARGE_DELAY   4      /* Frames between recharge ticks */

void chrono_init(void)
{
    time_state = TIME_NORMAL;
    energy = MAX_ENERGY;
    recharge_timer = 0;
}

void chrono_update(uint8_t keys)
{
    uint8_t prev_state = time_state;

    if ((keys & INPUT_KEY_FIRE) && energy >= SLOW_COST) {
        /* Activate time slow */
        time_state = TIME_SLOW;
        energy -= SLOW_COST;
    } else {
        time_state = TIME_NORMAL;

        /* Recharge energy when not using chrono powers */
        recharge_timer++;
        if (recharge_timer >= RECHARGE_DELAY) {
            recharge_timer = 0;
            if (energy < MAX_ENERGY) {
                energy += RECHARGE_RATE;
            }
        }
    }

    /* Play sound on state transitions */
    if (time_state != prev_state) {
        if (time_state == TIME_SLOW) {
            sound_fx_timeshift();
        }
    }
}

uint8_t chrono_get_state(void)  { return time_state; }
uint8_t chrono_get_energy(void) { return energy; }
uint8_t chrono_is_slowmo(void)  { return (time_state == TIME_SLOW) ? 1 : 0; }
