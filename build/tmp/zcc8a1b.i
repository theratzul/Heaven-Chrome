
#line 1 "src/game/levels.c"
 






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





























































































































 
 






 
 














































#line 8 "src/game/levels.c"

#line 1 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"

 






#line 1 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch.h"

 





 





































#line 1 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/../../../libsrc/_DEVELOPMENT/target/zx/config_zx.h"









 













































































































































































































































































































































      













      





  





















   




































   




























































































































































































































































































































































































































































































































































































































































































































































































































































































































































#line 46 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch.h"


















#line 9 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"


#line 1 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/stddef.h"

 









typedef int           ptrdiff_t;



typedef unsigned int  size_t;


typedef unsigned char max_align_t;



typedef unsigned char wchar_t;
















#line 11 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"

#line 1 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/rect.h"

 







 

struct r_Ival8
{
   uint8_t coord;               
   uint8_t width;               
};

struct r_Ival16
{
   uint16_t coord;              
   uint16_t width;              
};

struct r_Rect8
{
   uint8_t x;                   
   uint8_t width;               
   uint8_t y;                   
   uint8_t height;              
};

struct r_Rect16
{
   uint16_t x;                  
   uint16_t width;              
   uint16_t y;                  
   uint16_t height;             
};



#line 12 "Z:\home\vboxuser\myrepos\Heaven-Chrome\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"

 






















 

extern unsigned char GLOBAL_ZX_PORT_FE;
extern unsigned char GLOBAL_ZX_PORT_1FFD;
extern unsigned char GLOBAL_ZX_PORT_7FFD;

 









__sfr __at 0xfe IO_FE;

__sfr __banked __at 0x1ffd IO_1FFD;
__sfr __banked __at 0x7ffd IO_7FFD;



 

struct zxtapehdr
{
	unsigned char hdtype;       
	unsigned char hdname[10];   
	unsigned int  hdlen;        
	unsigned int  hdadd;        
	unsigned int  hdvars;       
};




extern unsigned char zx_tape_load_block(void *dst,unsigned int len,unsigned char type) __preserves_regs(iyl,iyh);
extern unsigned char zx_tape_load_block_callee(void *dst,unsigned int len,unsigned char type) __preserves_regs(iyl,iyh) __z88dk_callee;



extern unsigned char zx_tape_save_block(void *src,unsigned int len,unsigned char type) __preserves_regs(iyl,iyh);
extern unsigned char zx_tape_save_block_callee(void *src,unsigned int len,unsigned char type) __preserves_regs(iyl,iyh) __z88dk_callee;



extern unsigned char zx_tape_verify_block(void *dst,unsigned int len,unsigned char type) __preserves_regs(iyl,iyh);
extern unsigned char zx_tape_verify_block_callee(void *dst,unsigned int len,unsigned char type) __preserves_regs(iyl,iyh) __z88dk_callee;




 

extern void zx_border(unsigned char colour) __preserves_regs(b,c,d,e,iyl,iyh);
extern void zx_border_fastcall(unsigned char colour) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern void zx_cls(unsigned char attr) __preserves_regs(iyl,iyh);
extern void zx_cls_fastcall(unsigned char attr) __preserves_regs(iyl,iyh) __z88dk_fastcall;



extern void zx_cls_attr(unsigned char attr) __preserves_regs(iyl,iyh);
extern void zx_cls_attr_fastcall(unsigned char attr) __preserves_regs(iyl,iyh) __z88dk_fastcall;



extern void zx_cls_pix(unsigned char pix) __preserves_regs(iyl,iyh);
extern void zx_cls_pix_fastcall(unsigned char pix) __preserves_regs(iyl,iyh) __z88dk_fastcall;



extern void zx_cls_wc(struct r_Rect8 *r,unsigned char attr);
extern void zx_cls_wc_callee(struct r_Rect8 *r,unsigned char attr) __z88dk_callee;



extern void zx_cls_wc_attr(struct r_Rect8 *r,unsigned char attr);
extern void zx_cls_wc_attr_callee(struct r_Rect8 *r,unsigned char attr) __z88dk_callee;



extern void zx_cls_wc_pix(struct r_Rect8 *r,unsigned char pix);
extern void zx_cls_wc_pix_callee(struct r_Rect8 *r,unsigned char pix) __z88dk_callee;



extern void zx_scroll_up(unsigned char rows,unsigned char attr) __preserves_regs(iyl,iyh);
extern void zx_scroll_up_callee(unsigned char rows,unsigned char attr) __preserves_regs(iyl,iyh) __z88dk_callee;



extern void zx_scroll_up_attr(unsigned char rows,unsigned char attr) __preserves_regs(iyl,iyh);
extern void zx_scroll_up_attr_callee(unsigned char rows,unsigned char attr) __preserves_regs(iyl,iyh) __z88dk_callee;



extern void zx_scroll_up_pix(unsigned char rows,unsigned char pix) __preserves_regs(iyl,iyh);
extern void zx_scroll_up_pix_callee(unsigned char rows,unsigned char pix) __preserves_regs(iyl,iyh) __z88dk_callee;



extern void zx_scroll_wc_up(struct r_Rect8 *r,unsigned char rows,unsigned char attr);
extern void zx_scroll_wc_up_callee(struct r_Rect8 *r,unsigned char rows,unsigned char attr) __z88dk_callee;



extern void zx_scroll_wc_up_attr(struct r_Rect8 *r,unsigned char rows,unsigned char attr);
extern void zx_scroll_wc_up_attr_callee(struct r_Rect8 *r,unsigned char rows,unsigned char attr) __z88dk_callee;



extern void zx_scroll_wc_up_pix(struct r_Rect8 *r,unsigned char rows,unsigned char pix);
extern void zx_scroll_wc_up_pix_callee(struct r_Rect8 *r,unsigned char rows,unsigned char pix) __z88dk_callee;





















extern void zx_visit_wc_attr(struct r_Rect8 *r,void (*visit)(unsigned char *));
extern void zx_visit_wc_attr_callee(struct r_Rect8 *r,void (*visit)(unsigned char *)) __z88dk_callee;



extern void zx_visit_wc_pix(struct r_Rect8 *r,void (*visit)(unsigned char *));
extern void zx_visit_wc_pix_callee(struct r_Rect8 *r,void (*visit)(unsigned char *)) __z88dk_callee;





















 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

extern unsigned char zx_aaddr2cx(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_aaddr2cx_fastcall(void *aaddr) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_aaddr2cy(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_aaddr2cy_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_aaddr2px(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_aaddr2px_fastcall(void *aaddr) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_aaddr2py(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_aaddr2py_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_aaddr2saddr(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_aaddr2saddr_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_aaddrcdown(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_aaddrcdown_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_aaddrcleft(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_aaddrcleft_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_aaddrcright(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_aaddrcright_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_aaddrcup(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_aaddrcup_fastcall(void *aaddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_bitmask2px(unsigned char bitmask) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_bitmask2px_fastcall(unsigned char bitmask) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_cxy2aaddr(unsigned char x,unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_cxy2aaddr_callee(unsigned char x,unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_callee;



extern unsigned char *zx_cxy2saddr(unsigned char x,unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_cxy2saddr_callee(unsigned char x,unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_callee;



extern unsigned char *zx_cy2aaddr(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_cy2aaddr_fastcall(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_cy2saddr(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_cy2saddr_fastcall(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_px2bitmask(unsigned char x) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_px2bitmask_fastcall(unsigned char x) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_pxy2aaddr(unsigned char x,unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_pxy2aaddr_callee(unsigned char x,unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_callee;



extern unsigned char *zx_pxy2saddr(unsigned char x,unsigned char y) __preserves_regs(b,c,iyl,iyh);
extern unsigned char *zx_pxy2saddr_callee(unsigned char x,unsigned char y) __preserves_regs(b,c,iyl,iyh) __z88dk_callee;



extern unsigned char *zx_py2aaddr(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_py2aaddr_fastcall(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_py2saddr(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_py2saddr_fastcall(unsigned char y) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddr2aaddr(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddr2aaddr_fastcall(void *saddr) __preserves_regs(b,c,d,e,l,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_saddr2cx(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_saddr2cx_fastcall(void *saddr) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned char zx_saddr2cy(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char zx_saddr2cy_fastcall(void *saddr) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned int zx_saddr2px(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned int zx_saddr2px_fastcall(void *saddr) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned int zx_saddr2py(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned int zx_saddr2py_fastcall(void *saddr) __preserves_regs(b,c,d,e,h,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddrcdown(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddrcdown_fastcall(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddrcleft(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddrcleft_fastcall(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddrcright(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddrcright_fastcall(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddrcup(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddrcup_fastcall(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddrpdown(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddrpdown_fastcall(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;



extern unsigned char *zx_saddrpleft(void *saddr,unsigned char bitmask) __preserves_regs(b,c,iyl,iyh);
extern unsigned char *zx_saddrpleft_callee(void *saddr,unsigned char bitmask) __preserves_regs(b,c,iyl,iyh) __z88dk_callee;



extern unsigned char *zx_saddrpright(void *saddr,unsigned char bitmask) __preserves_regs(b,c,iyl,iyh);
extern unsigned char *zx_saddrpright_callee(void *saddr,unsigned char bitmask) __preserves_regs(b,c,iyl,iyh) __z88dk_callee;



extern unsigned char *zx_saddrpup(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh);
extern unsigned char *zx_saddrpup_fastcall(void *saddr) __preserves_regs(b,c,d,e,iyl,iyh) __z88dk_fastcall;




 

extern int zx_pattern_fill(unsigned char x,unsigned char y,void *pattern,unsigned int depth);
extern int zx_pattern_fill_callee(unsigned char x,unsigned char y,void *pattern,unsigned int depth) __z88dk_callee;






#line 9 "src/game/levels.c"

#line 1 "src/game\levels.h"
 










 








void    level_load(uint8_t level_num);
void    level_draw(uint8_t level_num);
uint8_t level_check_collision(uint8_t x, uint8_t y);
uint8_t level_check_exit(uint8_t x, uint8_t y);
uint8_t level_check_angel(uint8_t x, uint8_t y);
void    level_collect_angel(uint8_t x, uint8_t y);
uint8_t level_get_tile(uint8_t x, uint8_t y);



#line 10 "src/game/levels.c"

extern void video_print_at(uint8_t row, uint8_t col, const char *str);
extern void sprite_draw(uint8_t x, uint8_t y, const uint8_t *data);
extern void sprite_erase(uint8_t x, uint8_t y);

 
static const uint8_t tile_wall_gfx[] = {
    0xFF, 0x81, 0xBD, 0xA5, 0xA5, 0xBD, 0x81, 0xFF
};

 
static const uint8_t tile_platform_gfx[] = {
    0x3C, 0x7E, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
};

 
static const uint8_t tile_hazard_gfx[] = {
    0x18, 0x18, 0x7E, 0x7E, 0x18, 0x18, 0x18, 0x18
};

 
static const uint8_t tile_exit_gfx[] = {
    0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E
};

 
static const uint8_t tile_angel_gfx[] = {
    0x3C, 0x18, 0xDB, 0xFF, 0x7E, 0x3C, 0x18, 0x24
};

 
static const uint8_t level1_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 8,0,
    1,5, 21,0, 2,1, 7,0, 4,2, 19,0, 2,1, 16,0,
    1,5, 13,0, 2,1, 15,0, 4,2, 11,0, 2,1, 23,0,
    1,5, 6,0, 2,1, 22,0, 3,2, 5,0, 2,1, 30,0,
    2,1, 28,0, 1,4, 1,0, 2,1, 27,0, 3,2, 2,1,
    30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1,
    30,0, 2,1, 7,0, 2,3, 8,0, 2,3, 11,0, 2,1,
    5,0, 6,2, 4,0, 6,2, 9,0, 2,1, 30,0, 2,1,
    30,0, 2,1, 3,2, 27,0, 33,1, 0,0
};
 
static const uint8_t level2_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 6,0, 6,1, 4,0,
    6,1, 8,0, 2,1, 11,0, 1,1, 4,0, 1,1, 13,0,
    2,1, 11,0, 1,1, 4,0, 1,1, 13,0, 2,1, 11,0,
    1,1, 4,3, 1,1, 13,0, 2,1, 11,0, 6,1, 13,0,
    2,1, 2,0, 1,5, 24,0, 1,5, 2,0, 2,1, 4,2,
    22,0, 4,2, 2,1, 30,0, 2,1, 28,0, 1,4, 1,0,
    2,1, 27,0, 3,2, 2,1, 5,0, 5,2, 8,0, 5,2,
    7,0, 2,1, 8,0, 1,5, 11,0, 1,5, 9,0, 2,1,
    13,0, 4,3, 13,0, 2,1, 12,0, 6,2, 12,0, 2,1,
    30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1,
    30,0, 2,1, 3,2, 27,0, 33,1, 0,0
};
 
static const uint8_t level3_rle[] = {
    33,1, 14,0, 1,4, 15,0, 2,1, 13,0, 3,2, 14,0,
    2,1, 12,0, 1,5, 3,0, 1,5, 13,0, 2,1, 11,0,
    1,2, 5,0, 1,2, 12,0, 2,1, 30,0, 2,1, 10,0,
    1,2, 7,0, 1,2, 11,0, 2,1, 13,0, 2,3, 15,0,
    2,1, 9,0, 1,2, 9,0, 1,2, 10,0, 2,1, 8,0,
    1,5, 11,0, 1,5, 9,0, 2,1, 8,0, 1,2, 11,0,
    1,2, 9,0, 2,1, 30,0, 2,1, 7,0, 1,2, 4,0,
    4,3, 5,0, 1,2, 8,0, 2,1, 30,0, 2,1, 6,0,
    1,2, 15,0, 1,2, 7,0, 2,1, 30,0, 2,1, 5,0,
    1,2, 17,0, 1,2, 6,0, 2,1, 10,0, 2,3, 5,0,
    2,3, 11,0, 2,1, 4,0, 1,2, 19,0, 1,2, 5,0,
    2,1, 30,0, 2,1, 3,0, 1,2, 21,0, 1,2, 4,0,
    2,1, 30,0, 2,1, 3,2, 27,0, 33,1, 0,0
};
 
static const uint8_t level4_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 25,0, 1,4, 4,0,
    2,1, 22,0, 5,2, 3,0, 2,1, 30,0, 2,1, 14,0,
    2,3, 2,0, 1,5, 11,0, 2,1, 16,0, 4,2, 10,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 22,0, 4,2, 4,0,
    2,1, 30,0, 2,1, 18,0, 1,5, 1,0, 2,3, 8,0,
    2,1, 16,0, 4,2, 10,0, 2,1, 30,0, 2,1, 14,0,
    2,3, 14,0, 2,1, 10,0, 4,2, 16,0, 2,1, 30,0,
    2,1, 6,0, 1,5, 1,0, 2,3, 20,0, 2,1, 4,0,
    4,2, 22,0, 2,1, 30,0, 2,1, 30,0, 2,1, 4,2,
    26,0, 33,1, 0,0
};
 
static const uint8_t level5_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 9,0, 2,3, 8,0,
    2,3, 4,0, 1,5, 1,0, 1,4, 2,0, 2,1, 28,2,
    2,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1,
    6,0, 1,5, 4,0, 2,3, 8,0, 2,3, 7,0, 2,1,
    2,0, 27,2, 1,0, 2,1, 30,0, 2,1, 30,0, 2,1,
    30,0, 2,1, 7,0, 2,3, 5,0, 1,5, 2,0, 2,3,
    11,0, 2,1, 28,2, 2,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 30,0, 2,1, 4,2, 26,0, 33,1, 0,0
};
 
static const uint8_t level6_rle[] = {
    33,1, 9,0, 1,1, 10,0, 1,1, 9,0, 2,1, 9,0,
    1,1, 10,0, 1,1, 9,0, 2,1, 9,0, 1,1, 10,0,
    1,1, 9,0, 2,1, 9,0, 1,1, 10,0, 1,1, 9,0,
    2,1, 9,0, 1,1, 10,0, 1,1, 9,0, 2,1, 9,0,
    1,1, 10,0, 1,1, 9,0, 2,1, 9,0, 1,1, 4,0,
    2,3, 4,0, 1,1, 9,0, 2,1, 4,0, 1,5, 4,0,
    1,1, 9,2, 1,0, 1,1, 4,0, 1,4, 4,0, 2,1,
    1,0, 8,2, 1,1, 10,0, 1,1, 8,2, 1,0, 2,1,
    30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 9,0, 1,1,
    4,0, 1,5, 5,0, 1,1, 9,0, 2,1, 9,0, 1,1,
    4,0, 2,3, 4,0, 1,1, 9,0, 2,1, 9,0, 1,1,
    9,2, 1,0, 1,1, 4,0, 1,5, 4,0, 2,1, 4,0,
    2,3, 3,0, 1,1, 10,0, 1,1, 3,0, 2,3, 4,0,
    2,1, 8,2, 1,0, 1,1, 10,0, 1,1, 8,2, 1,0,
    2,1, 9,0, 1,1, 10,0, 1,1, 9,0, 2,1, 9,0,
    1,1, 10,0, 1,1, 9,0, 2,1, 9,0, 1,1, 10,0,
    1,1, 9,0, 2,1, 9,0, 1,1, 10,0, 1,1, 9,0,
    2,1, 4,2, 5,0, 1,1, 10,0, 1,1, 9,0, 33,1,
    0,0
};
 
static const uint8_t level7_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 25,0, 1,4, 4,0,
    2,1, 13,0, 1,5, 7,0, 6,2, 3,0, 2,1, 11,0,
    5,2, 1,0, 2,3, 11,0, 2,1, 17,0, 2,3, 11,0,
    2,1, 5,0, 1,5, 24,0, 2,1, 3,0, 4,2, 23,0,
    2,1, 7,0, 2,3, 21,0, 2,1, 7,0, 2,3, 1,0,
    4,2, 16,0, 2,1, 22,0, 2,3, 6,0, 2,1, 17,0,
    4,2, 1,0, 2,3, 6,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 13,0, 1,5, 1,0, 2,3, 7,0, 4,2, 2,0,
    2,1, 11,0, 4,2, 2,3, 13,0, 2,1, 8,0, 2,3,
    20,0, 2,1, 5,0, 3,2, 2,3, 8,0, 3,2, 9,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 4,2,
    26,0, 33,1, 0,0
};
 
static const uint8_t level8_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 25,0, 1,4, 4,0,
    2,1, 17,0, 10,2, 3,0, 2,1, 6,0, 2,3, 2,0,
    1,5, 19,0, 2,1, 6,0, 2,3, 5,2, 17,0, 2,1,
    6,0, 2,3, 5,0, 2,3, 15,0, 2,1, 13,0, 2,3,
    5,2, 10,0, 2,1, 13,0, 2,3, 15,0, 2,1, 24,0,
    1,5, 5,0, 2,1, 22,0, 7,2, 1,0, 2,1, 20,0,
    2,3, 8,0, 2,1, 15,0, 5,2, 2,3, 8,0, 2,1,
    10,0, 1,5, 2,0, 2,3, 5,0, 2,3, 8,0, 2,1,
    8,0, 5,2, 2,3, 15,0, 2,1, 6,0, 2,3, 5,0,
    2,3, 15,0, 2,1, 6,2, 2,3, 22,0, 2,1, 6,0,
    2,3, 22,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 4,2, 26,0, 33,1, 0,0
};
 
static const uint8_t level9_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 26,0, 1,4, 3,0, 2,1, 24,0, 5,2, 1,0,
    2,1, 30,0, 2,1, 13,0, 2,3, 1,5, 1,3, 13,0,
    2,1, 10,0, 10,2, 10,0, 2,1, 3,0, 1,5, 3,0,
    2,1, 12,0, 2,1, 3,0, 1,5, 3,0, 2,1, 1,0,
    5,2, 1,0, 2,1, 12,0, 2,1, 1,0, 5,2, 1,0,
    2,1, 7,0, 2,1, 12,0, 2,1, 7,0, 2,1, 7,0,
    2,1, 12,0, 2,1, 7,0, 2,1, 7,0, 2,1, 12,0,
    2,1, 7,0, 2,1, 7,0, 2,1, 12,0, 2,1, 7,0,
    2,1, 1,0, 5,2, 1,0, 2,1, 3,0, 6,3, 3,0,
    2,1, 7,0, 2,1, 7,0, 2,1, 3,0, 6,3, 3,0,
    2,1, 7,0, 2,1, 7,0, 2,1, 12,0, 2,1, 7,0,
    2,1, 7,0, 2,1, 12,0, 2,1, 7,0, 2,1, 7,0,
    2,1, 12,0, 2,1, 7,0, 2,1, 7,0, 2,1, 12,0,
    2,1, 7,0, 2,1, 4,2, 3,0, 2,1, 12,0, 2,1,
    7,0, 33,1, 0,0
};
 
static const uint8_t level10_rle[] = {
    33,1, 5,0, 1,1, 11,0, 1,1, 12,0, 2,1, 2,0,
    1,4, 2,0, 1,1, 11,0, 1,1, 12,0, 2,1, 4,2,
    1,0, 1,1, 2,0, 1,5, 8,0, 1,1, 12,0, 2,1,
    5,0, 1,1, 4,2, 7,0, 1,1, 12,0, 2,1, 5,0,
    1,1, 8,0, 1,5, 2,0, 1,1, 12,0, 2,1, 5,0,
    1,1, 6,0, 4,2, 1,0, 1,1, 12,0, 2,1, 5,0,
    1,1, 5,0, 1,1, 5,0, 1,1, 5,0, 1,1, 6,0,
    2,1, 5,0, 1,1, 5,0, 1,1, 5,0, 1,1, 5,0,
    1,1, 6,0, 2,1, 5,0, 1,1, 5,0, 1,1, 5,0,
    1,1, 2,0, 2,3, 1,0, 1,1, 6,0, 2,1, 5,0,
    1,1, 5,0, 1,1, 5,0, 1,1, 4,2, 1,0, 1,1,
    6,0, 2,1, 5,0, 1,1, 5,0, 1,1, 5,0, 1,1,
    5,0, 1,1, 6,0, 2,1, 5,0, 1,1, 5,0, 1,1,
    5,0, 1,1, 5,0, 1,1, 6,0, 2,1, 5,0, 1,1,
    5,0, 1,1, 5,0, 1,1, 5,0, 1,1, 6,0, 2,1,
    5,0, 1,1, 5,0, 1,1, 5,0, 1,1, 5,0, 1,1,
    6,0, 2,1, 2,0, 2,3, 1,0, 1,1, 5,0, 1,1,
    2,0, 2,3, 1,0, 1,1, 5,0, 1,1, 6,0, 2,1,
    4,2, 1,0, 1,1, 2,0, 1,5, 2,0, 1,1, 4,2,
    1,0, 1,1, 5,0, 1,1, 4,2, 2,0, 2,1, 8,0,
    2,3, 1,0, 1,1, 8,0, 2,3, 1,0, 1,1, 6,0,
    2,1, 6,0, 4,2, 1,0, 1,1, 6,0, 4,2, 1,0,
    1,1, 6,0, 2,1, 11,0, 1,1, 11,0, 1,1, 6,0,
    2,1, 11,0, 1,1, 11,0, 1,1, 6,0, 2,1, 11,0,
    1,1, 11,0, 1,1, 6,0, 2,1, 4,2, 7,0, 1,1,
    11,0, 1,1, 6,0, 33,1, 0,0
};
 
static const uint8_t level11_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 11,0,
    1,5, 15,0, 1,4, 2,0, 2,1, 1,0, 5,2, 3,0,
    5,2, 3,0, 5,2, 2,0, 5,2, 1,0, 2,1, 30,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 5,0, 2,3, 4,0,
    2,3, 4,0, 2,3, 4,0, 2,3, 5,0, 2,1, 5,0,
    2,3, 4,0, 2,3, 2,0, 1,5, 1,0, 2,3, 4,0,
    2,3, 5,0, 2,1, 1,0, 4,2, 2,3, 4,2, 2,3,
    4,2, 2,3, 4,2, 2,3, 4,2, 1,0, 2,1, 5,0,
    2,3, 4,0, 2,3, 4,0, 2,3, 4,0, 2,3, 5,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 5,0, 2,3, 4,0,
    2,3, 4,0, 2,3, 4,0, 2,3, 5,0, 2,1, 5,0,
    2,3, 2,0, 1,5, 1,0, 2,3, 4,0, 2,3, 4,0,
    2,3, 5,0, 2,1, 5,2, 2,3, 4,2, 2,3, 4,2,
    2,3, 4,2, 2,3, 4,2, 1,0, 2,1, 5,0, 2,3,
    4,0, 2,3, 4,0, 2,3, 4,0, 2,3, 5,0, 2,1,
    30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 4,2, 26,0,
    33,1, 0,0
};
 
static const uint8_t level12_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 25,0, 1,4, 4,0,
    2,1, 23,0, 5,2, 2,0, 2,1, 16,0, 1,5, 2,0,
    3,3, 8,0, 2,1, 14,0, 4,2, 12,0, 2,1, 30,0,
    2,1, 6,0, 1,5, 2,0, 3,3, 18,0, 2,1, 5,0,
    3,2, 22,0, 2,1, 17,0, 3,3, 10,0, 2,1, 13,0,
    3,2, 14,0, 2,1, 30,0, 2,1, 30,0, 2,1, 21,0,
    3,2, 6,0, 2,1, 17,0, 3,3, 10,0, 2,1, 13,0,
    3,2, 14,0, 2,1, 6,0, 1,5, 2,0, 3,3, 18,0,
    2,1, 5,0, 3,2, 22,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 30,0, 2,1, 4,2, 26,0, 33,1, 0,0
};
 
static const uint8_t level13_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 26,0,
    1,4, 3,0, 2,1, 24,0, 5,2, 1,0, 2,1, 22,0,
    2,1, 6,0, 2,1, 18,0, 1,5, 3,0, 2,1, 6,0,
    2,1, 18,0, 2,3, 2,0, 2,1, 6,0, 2,1, 16,0,
    5,2, 1,0, 2,1, 6,0, 2,1, 14,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 10,0, 1,5, 3,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 10,0, 2,3, 2,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 8,0, 5,2, 1,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 6,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 2,0, 1,5, 3,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 3,0, 2,3, 1,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 6,0, 2,1, 1,0,
    4,2, 1,0, 2,1, 6,0, 2,1, 6,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 6,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 6,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 6,0, 2,1, 6,0,
    2,1, 6,0, 2,1, 6,0, 2,1, 6,0, 2,1, 6,0,
    2,1, 4,2, 2,0, 2,1, 6,0, 2,1, 6,0, 2,1,
    6,0, 33,1, 0,0
};
 
static const uint8_t level14_rle[] = {
    33,1, 14,0, 2,1, 14,0, 2,1, 14,0, 2,1, 14,0,
    2,1, 14,0, 2,1, 14,0, 2,1, 14,0, 2,1, 10,0,
    1,4, 3,0, 2,1, 14,0, 2,1, 8,0, 5,2, 1,0,
    2,1, 14,0, 2,1, 14,0, 2,1, 14,0, 2,1, 14,0,
    2,1, 14,0, 2,1, 6,0, 1,5, 1,3, 6,0, 2,1,
    14,0, 2,1, 4,0, 4,2, 6,0, 2,1, 14,0, 2,1,
    14,0, 2,1, 14,0, 2,1, 14,0, 2,1, 14,0, 2,1,
    14,0, 2,1, 14,0, 2,1, 8,0, 4,2, 2,0, 2,1,
    14,0, 2,1, 14,0, 2,1, 4,0, 2,3, 8,0, 2,1,
    14,0, 2,1, 1,0, 4,2, 3,0, 1,5, 5,0, 2,1,
    7,0, 2,3, 5,0, 2,1, 8,0, 2,3, 11,0, 4,2,
    5,0, 2,1, 6,0, 4,2, 9,0, 1,5, 10,0, 2,1,
    19,0, 2,3, 9,0, 2,1, 10,0, 3,2, 4,0, 3,2,
    10,0, 2,1, 30,0, 2,1, 4,2, 26,0, 33,1, 0,0
};
 
static const uint8_t level15_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 4,0, 22,1, 4,0, 2,1, 5,0, 2,3, 4,0,
    1,5, 13,0, 1,1, 4,0, 2,1, 9,0, 5,2, 7,0,
    3,2, 1,0, 1,1, 4,0, 2,1, 1,0, 3,2, 21,0,
    1,1, 4,0, 2,1, 7,0, 14,1, 4,0, 1,1, 4,0,
    2,1, 7,0, 1,1, 12,0, 1,1, 2,0, 2,3, 1,1,
    4,0, 2,1, 7,0, 1,1, 1,0, 2,3, 9,0, 1,1,
    4,0, 1,1, 4,0, 2,1, 7,0, 1,1, 2,0, 3,2,
    2,0, 1,4, 4,0, 1,1, 4,0, 1,1, 4,0, 2,1,
    7,0, 1,1, 6,0, 3,2, 3,0, 1,1, 4,0, 1,1,
    4,0, 2,1, 7,0, 1,1, 3,0, 10,1, 4,0, 1,1,
    4,0, 2,1, 7,0, 1,1, 4,0, 1,5, 9,0, 1,5,
    2,0, 1,1, 4,0, 2,1, 7,0, 1,1, 3,0, 4,2,
    6,0, 3,2, 1,0, 1,1, 4,0, 2,1, 7,0, 1,1,
    7,0, 2,3, 8,0, 1,1, 4,0, 2,1, 3,2, 4,0,
    19,1, 4,0, 2,1, 30,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 4,2, 26,0, 33,1, 0,0
};
 
static const uint8_t level16_rle[] = {
    33,1, 10,0, 2,1, 10,0, 2,1, 6,0, 2,1, 10,0,
    2,1, 3,0, 1,4, 6,0, 2,1, 6,0, 2,1, 10,0,
    2,1, 1,0, 5,2, 4,0, 2,1, 6,0, 2,1, 3,0,
    1,5, 6,0, 2,1, 10,0, 2,1, 6,0, 2,1, 1,0,
    4,2, 5,0, 2,1, 10,0, 2,1, 6,0, 2,1, 8,0,
    1,3, 1,0, 2,1, 2,0, 1,3, 5,0, 1,3, 1,0,
    2,1, 2,0, 1,5, 3,0, 2,1, 7,0, 1,2, 1,3,
    1,0, 2,1, 1,0, 1,2, 1,3, 4,0, 1,2, 1,3,
    1,0, 2,1, 1,0, 4,2, 1,0, 2,1, 4,0, 2,1,
    4,0, 2,1, 4,0, 2,1, 4,0, 2,1, 6,0, 2,1,
    4,0, 2,1, 4,0, 2,1, 4,0, 2,1, 4,0, 2,1,
    6,0, 2,1, 4,0, 2,1, 4,0, 2,1, 4,0, 2,1,
    4,0, 2,1, 6,0, 2,1, 4,0, 2,1, 4,0, 2,1,
    4,0, 2,1, 4,0, 2,1, 6,0, 2,1, 4,0, 2,1,
    4,0, 2,1, 4,0, 2,1, 4,0, 2,1, 6,0, 2,1,
    4,0, 2,1, 4,0, 2,1, 4,0, 2,1, 4,0, 2,1,
    6,0, 2,1, 4,0, 2,1, 4,0, 2,1, 2,0, 1,5,
    1,0, 2,1, 4,0, 2,1, 6,0, 2,1, 2,0, 1,3,
    1,0, 2,1, 2,0, 1,3, 1,0, 2,1, 2,0, 1,3,
    1,0, 2,1, 2,0, 1,3, 1,0, 2,1, 6,0, 2,1,
    1,0, 1,2, 1,3, 1,0, 2,1, 1,0, 1,2, 1,3,
    4,0, 1,2, 1,3, 1,0, 2,1, 1,0, 1,2, 1,3,
    4,0, 4,2, 1,0, 2,1, 4,0, 2,1, 10,0, 2,1,
    12,0, 2,1, 4,0, 2,1, 10,0, 2,1, 12,0, 2,1,
    4,0, 2,1, 10,0, 2,1, 12,0, 2,1, 4,0, 2,1,
    10,0, 2,1, 12,0, 2,1, 4,0, 2,1, 10,0, 2,1,
    12,0, 2,1, 4,2, 2,1, 10,0, 2,1, 12,0, 33,1,
    0,0
};
 
static const uint8_t level17_rle[] = {
    33,1, 30,0, 2,1, 25,0, 1,4, 4,0, 2,1, 23,0,
    4,2, 3,0, 2,1, 14,0, 3,2, 2,0, 2,3, 9,0,
    2,1, 7,0, 1,5, 11,0, 2,3, 9,0, 2,1, 6,0,
    2,2, 22,0, 2,1, 9,0, 2,3, 19,0, 2,1, 9,0,
    2,3, 1,0, 2,2, 16,0, 2,1, 15,0, 2,3, 2,0,
    1,5, 10,0, 2,1, 15,0, 2,3, 1,0, 2,2, 10,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 24,0, 2,2, 4,0,
    2,1, 21,0, 2,3, 7,0, 2,1, 18,0, 2,2, 1,0,
    2,3, 7,0, 2,1, 13,0, 1,5, 1,0, 2,3, 13,0,
    2,1, 12,0, 2,2, 1,0, 2,3, 13,0, 2,1, 9,0,
    2,3, 19,0, 2,1, 6,0, 2,2, 1,0, 2,3, 19,0,
    2,1, 30,0, 2,1, 30,0, 2,1, 4,2, 26,0, 33,1,
    0,0
};
 
static const uint8_t level18_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 13,0, 1,5, 10,0,
    1,4, 5,0, 2,1, 12,0, 4,2, 1,0, 2,3, 2,0,
    5,2, 4,0, 2,1, 5,0, 1,5, 11,0, 2,3, 11,0,
    2,1, 4,0, 3,2, 2,3, 4,0, 2,3, 15,0, 2,1,
    7,0, 2,3, 1,0, 3,2, 2,3, 1,0, 3,2, 11,0,
    2,1, 19,0, 2,3, 9,0, 2,1, 19,0, 2,3, 3,2,
    6,0, 2,1, 30,0, 2,1, 30,0, 2,1, 26,0, 3,2,
    1,0, 2,1, 12,0, 1,5, 11,0, 2,3, 4,0, 2,1,
    11,0, 3,2, 7,0, 3,2, 2,3, 4,0, 2,1, 9,0,
    2,3, 3,0, 2,3, 3,0, 2,3, 9,0, 2,1, 6,0,
    3,2, 2,3, 3,0, 2,3, 3,2, 2,3, 9,0, 2,1,
    4,0, 2,3, 24,0, 2,1, 4,2, 2,3, 24,0, 2,1,
    30,0, 2,1, 30,0, 2,1, 30,0, 2,1, 4,2, 26,0,
    33,1, 0,0
};
 
static const uint8_t level19_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 15,0, 1,4, 14,0,
    2,1, 12,0, 6,2, 12,0, 2,1, 30,0, 2,1, 7,0,
    16,1, 7,0, 2,1, 7,0, 16,1, 7,0, 2,1, 7,0,
    2,1, 2,3, 8,0, 2,3, 2,1, 7,0, 2,1, 7,0,
    2,1, 2,3, 8,0, 2,3, 2,1, 7,0, 2,1, 4,0,
    1,5, 2,0, 2,1, 12,0, 2,1, 2,0, 1,5, 4,0,
    2,1, 3,0, 3,2, 1,0, 2,1, 12,0, 2,1, 1,0,
    3,2, 3,0, 2,1, 7,0, 2,1, 4,0, 4,3, 4,0,
    2,1, 7,0, 2,1, 7,0, 2,1, 4,0, 4,2, 4,0,
    2,1, 7,0, 2,1, 7,0, 2,1, 12,0, 2,1, 7,0,
    2,1, 4,0, 2,3, 1,0, 2,1, 12,0, 2,1, 2,3,
    5,0, 2,1, 1,0, 3,2, 2,3, 1,0, 2,1, 12,0,
    2,1, 2,3, 2,2, 3,0, 2,1, 7,0, 2,1, 1,0,
    2,3, 3,0, 1,5, 2,0, 2,3, 1,0, 2,1, 7,0,
    2,1, 11,0, 8,2, 11,0, 2,1, 30,0, 2,1, 30,0,
    2,1, 30,0, 2,1, 4,2, 26,0, 33,1, 0,0
};
 
static const uint8_t level20_rle[] = {
    33,1, 30,0, 2,1, 30,0, 2,1, 15,0, 1,4, 14,0,
    2,1, 12,0, 6,2, 12,0, 2,1, 11,0, 8,1, 11,0,
    2,1, 30,0, 2,1, 7,0, 1,5, 2,3, 10,0, 1,3,
    1,5, 8,0, 2,1, 6,0, 2,2, 2,3, 10,0, 2,3,
    2,2, 6,0, 2,1, 30,0, 2,1, 9,0, 2,1, 8,0,
    2,1, 9,0, 2,1, 9,0, 2,1, 8,0, 2,1, 9,0,
    2,1, 1,0, 4,2, 4,0, 2,1, 8,0, 2,1, 4,0,
    4,2, 1,0, 2,1, 9,0, 2,1, 2,0, 4,3, 2,0,
    2,1, 9,0, 2,1, 9,0, 2,1, 1,0, 6,2, 1,0,
    2,1, 9,0, 2,1, 4,0, 2,1, 3,0, 2,1, 8,0,
    2,1, 3,0, 2,1, 4,0, 2,1, 4,0, 2,1, 3,2,
    2,1, 8,0, 2,1, 3,2, 2,1, 4,0, 2,1, 3,0,
    1,3, 2,1, 3,0, 2,1, 8,0, 2,1, 3,0, 1,1,
    1,3, 4,0, 2,1, 1,0, 2,2, 1,3, 2,1, 3,0,
    2,3, 4,0, 1,5, 3,0, 2,3, 3,0, 1,1, 1,3,
    3,2, 1,0, 2,1, 4,0, 2,1, 3,0, 2,1, 8,2,
    2,1, 3,0, 2,1, 4,0, 2,1, 4,0, 2,1, 3,0,
    2,1, 8,0, 2,1, 3,0, 2,1, 4,0, 2,1, 4,0,
    2,1, 3,0, 2,1, 8,0, 2,1, 3,0, 2,1, 4,0,
    2,1, 4,2, 2,1, 3,0, 2,1, 8,0, 2,1, 3,0,
    2,1, 4,0, 33,1, 0,0
};

 
static const uint8_t * const levels[ 20 ] = {
    level1_rle,
    level2_rle,
    level3_rle,
    level4_rle,
    level5_rle,
    level6_rle,
    level7_rle,
    level8_rle,
    level9_rle,
    level10_rle,
    level11_rle,
    level12_rle,
    level13_rle,
    level14_rle,
    level15_rle,
    level16_rle,
    level17_rle,
    level18_rle,
    level19_rle,
    level20_rle
};

 
static uint8_t current_level_map[ 24  *  32 ];

void level_load(uint8_t level_num)
{
    const uint8_t *p;
    uint16_t idx = 0;

    if (level_num >=  20 ) {
        return;
    }

    p = levels[level_num];

    while (p[0] != 0 && idx < ( 24  *  32 )) {
        uint8_t count = p[0];
        uint8_t tile = p[1];
        while (count > 0 && idx < ( 24  *  32 )) {
            current_level_map[idx++] = tile;
            count--;
        }
        p += 2;
    }
}

uint8_t level_get_tile(uint8_t x, uint8_t y)
{
    if (x >=  32  || y >=  24 ) return  1 ;
    return current_level_map[y *  32  + x];
}

void level_draw(uint8_t level_num)
{
    uint8_t x, y, tile;

    level_load(level_num);

    for (y = 0; y <  24 ; y++) {
        for (x = 0; x <  32 ; x++) {
            tile = level_get_tile(x, y);
            switch (tile) {
                case  1 :
                    sprite_draw(x, y, tile_wall_gfx);
                    break;
                case  2 :
                    sprite_draw(x, y, tile_platform_gfx);
                    break;
                case  3 :
                    sprite_draw(x, y, tile_hazard_gfx);
                    break;
                case  4 :
                    sprite_draw(x, y, tile_exit_gfx);
                    break;
                case  5 :
                    sprite_draw(x, y, tile_angel_gfx);
                    break;
                default:
                    break;
            }
        }
    }
}

uint8_t level_check_collision(uint8_t x, uint8_t y)
{
    uint8_t tile = level_get_tile(x, y);
    return (tile ==  1  || tile ==  3 ) ? 1 : 0;
}

uint8_t level_check_exit(uint8_t x, uint8_t y)
{
    return (level_get_tile(x, y) ==  4 ) ? 1 : 0;
}

uint8_t level_check_angel(uint8_t x, uint8_t y)
{
    return (level_get_tile(x, y) ==  5 ) ? 1 : 0;
}

void level_collect_angel(uint8_t x, uint8_t y)
{
    if (x <  32  && y <  24 ) {
        current_level_map[y *  32  + x] =  0 ;
        sprite_erase(x, y);
    }
}

