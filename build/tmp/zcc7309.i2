
#line 1 "src/game/hud.c"
 


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





























































































































 
 






 
 














































#line 4 "src/game/hud.c"

#line 1 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"

 






#line 1 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch.h"

 





 





































#line 1 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/../../../libsrc/_DEVELOPMENT/target/zx/config_zx.h"









 













































































































































































































































































































































      













      





  





















   




































   




























































































































































































































































































































































































































































































































































































































































































































































































































































































































































#line 46 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch.h"


















#line 9 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"


#line 1 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/stddef.h"

 









typedef int           ptrdiff_t;



typedef unsigned int  size_t;


typedef unsigned char max_align_t;



typedef unsigned char wchar_t;
















#line 11 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"

#line 1 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/rect.h"

 







 

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



#line 12 "Z:\home\vboxuser\myrepos\Chronos\tools\z88dk\z88dk\lib\config\..\..\\include\_DEVELOPMENT\sdcc/arch/zx.h"

 






















 

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






#line 5 "src/game/hud.c"

#line 1 "src/game\hud.h"
 






void hud_draw(uint16_t score, uint8_t lives, uint8_t chrono_energy);



#line 6 "src/game/hud.c"

extern void video_print_at(uint8_t row, uint8_t col, const char *str);

static char score_buf[8];

static void uint16_to_str(uint16_t val, char *buf)
{
    int8_t i;
    buf[6] = '\0';
    for (i = 5; i >= 0; i--) {
        buf[i] = '0' + (val % 10);
        val /= 10;
    }
}

static void draw_energy_bar(uint8_t row, uint8_t col, uint8_t energy)
{
    uint8_t filled = energy / 10;
    uint8_t i;
    char bar[13];

    bar[0] = '[';
    for (i = 0; i < 10; i++) {
        bar[i + 1] = (i < filled) ? '=' : ' ';
    }
    bar[11] = ']';
    bar[12] = '\0';

    video_print_at(row, col, bar);
}

void hud_draw(uint16_t score, uint8_t lives, uint8_t chrono_energy)
{
    uint16_to_str(score, score_buf);
    video_print_at(0, 0, "SC:");
    video_print_at(0, 3, score_buf);

    score_buf[0] = 'L';
    score_buf[1] = ':';
    score_buf[2] = '0' + lives;
    score_buf[3] = '\0';
    video_print_at(0, 11, score_buf);

    video_print_at(0, 16, "TM:");
    draw_energy_bar(0, 19, chrono_energy);
}

