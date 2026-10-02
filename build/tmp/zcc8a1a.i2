
#line 1 "src/game/player.c"
 


#line 1 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/stdint.h"

 





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





























































































































 
 






 
 














































#line 4 "src/game/player.c"

#line 1 "src/game\player.h"
 






 







void    player_init(void);
void    player_update(uint8_t keys);
void    player_draw(void);
void    player_on_hit(void);
void    player_reset_position(void);
uint8_t player_get_x(void);
uint8_t player_get_y(void);
uint8_t player_get_lives(void);



#line 5 "src/game/player.c"

 
static const uint8_t player_sprite[] = {
    0x18,   
    0x3C,   
    0x7E,   
    0x5A,   
    0x7E,   
    0x24,   
    0x24,   
    0x66    
};

 
extern void sprite_draw(uint8_t x, uint8_t y, const uint8_t *data);
extern void sprite_erase(uint8_t x, uint8_t y);

 
static uint8_t px, py;           
static uint8_t old_px, old_py;   
static uint8_t lives;
static uint8_t invincible;       
static uint8_t facing;           
static uint8_t start_x, start_y;




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
     
    if (invincible > 0) {
        invincible--;
    }

    old_px = px;
    old_py = py;

     
    if ((keys &  0x01 ) && py > 1) {
        py -=  1 ;
    }
    if ((keys &  0x02 ) && py < 22) {
        py +=  1 ;
    }
    if ((keys &  0x04 ) && px > 0) {
        px -=  1 ;
        facing = 1;
    }
    if ((keys &  0x08 ) && px < 31) {
        px +=  1 ;
        facing = 0;
    }
}

void player_draw(void)
{
     
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
    if (invincible > 0) return;   

    if (lives > 0) {
        lives--;
    }
    invincible =  50 ;

    sprite_erase(px, py);

     
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

