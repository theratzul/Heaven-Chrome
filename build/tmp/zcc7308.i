
#line 1 "src/game/chrono.c"
 








#line 1 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/stdint.h"

 





typedef signed char            int8_t;
typedef signed int             int16_t;
typedef signed long            int32_t;

typedef unsigned char          uint8_t;
typedef unsigned int           uint16_t;
typedef unsigned long          uint32_t;

typedef signed char            int_least8_t;
typedef signed int             int_least16_t;
typedef signed long            int_least32_t;

typedef unsigned char          uint_least8_t;
typedef unsigned int           uint_least16_t;
typedef unsigned long          uint_least32_t;

typedef signed int             int_fast8_t;
typedef signed int             int_fast16_t;
typedef signed long            int_fast32_t;

typedef unsigned int           uint_fast8_t;
typedef unsigned int           uint_fast16_t;
typedef unsigned long          uint_fast32_t;
















typedef long long              int64_t;
typedef unsigned long long     uint64_t;

typedef long long              int_least64_t;
typedef unsigned long long     uint_least64_t;

typedef long long              int_fast64_t;
typedef unsigned long long     uint_fast64_t;


















typedef int                    intptr_t;


typedef unsigned int           uintptr_t;










typedef long long              intmax_t;
typedef unsigned long long     uintmax_t;





























































































































 
 






 
 














































#line 10 "src/game/chrono.c"

#line 1 "src/game\chrono.h"
 






 





void    chrono_init(void);
void    chrono_update(uint8_t keys);
uint8_t chrono_get_state(void);
uint8_t chrono_get_energy(void);
uint8_t chrono_is_slowmo(void);



#line 11 "src/game/chrono.c"

#line 1 "src/game\player.h"
 






 







void    player_init(void);
void    player_update(uint8_t keys);
void    player_draw(void);
void    player_on_hit(void);
void    player_reset_position(void);
uint8_t player_get_x(void);
uint8_t player_get_y(void);
uint8_t player_get_lives(void);



#line 12 "src/game/chrono.c"

extern void sound_fx_timeshift(void);

 
static uint8_t time_state;
static uint8_t energy;           
static uint8_t recharge_timer;






void chrono_init(void)
{
    time_state =  0 ;
    energy =  100 ;
    recharge_timer = 0;
}

void chrono_update(uint8_t keys)
{
    uint8_t prev_state = time_state;

    if ((keys &  0x10 ) && energy >=  2 ) {
         
        time_state =  1 ;
        energy -=  2 ;
    } else {
        time_state =  0 ;

         
        recharge_timer++;
        if (recharge_timer >=  4 ) {
            recharge_timer = 0;
            if (energy <  100 ) {
                energy +=  1 ;
            }
        }
    }

     
    if (time_state != prev_state) {
        if (time_state ==  1 ) {
            sound_fx_timeshift();
        }
    }
}

uint8_t chrono_get_state(void)  { return time_state; }
uint8_t chrono_get_energy(void) { return energy; }
uint8_t chrono_is_slowmo(void)  { return (time_state ==  1 ) ? 1 : 0; }

