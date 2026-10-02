MODULE hud_c
LINE 0, "src/game/hud.c"

;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
; Processed by Z88DK
;--------------------------------------------------------

	EXTERN __divschar
	EXTERN __divschar_callee
	EXTERN __divsint
	EXTERN __divsint_callee
	EXTERN __divslong
	EXTERN __divslong_callee
	EXTERN __divslonglong
	EXTERN __divslonglong_callee
	EXTERN __divsuchar
	EXTERN __divsuchar_callee
	EXTERN __divuchar
	EXTERN __divuchar_callee
	EXTERN __divuint
	EXTERN __divuint_callee
	EXTERN __divulong
	EXTERN __divulong_callee
	EXTERN __divulonglong
	EXTERN __divulonglong_callee
	EXTERN __divuschar
	EXTERN __divuschar_callee
	EXTERN __modschar
	EXTERN __modschar_callee
	EXTERN __modsint
	EXTERN __modsint_callee
	EXTERN __modslong
	EXTERN __modslong_callee
	EXTERN __modslonglong
	EXTERN __modslonglong_callee
	EXTERN __modsuchar
	EXTERN __modsuchar_callee
	EXTERN __moduchar
	EXTERN __moduchar_callee
	EXTERN __moduint
	EXTERN __moduint_callee
	EXTERN __modulong
	EXTERN __modulong_callee
	EXTERN __modulonglong
	EXTERN __modulonglong_callee
	EXTERN __moduschar
	EXTERN __moduschar_callee
	EXTERN __mulint
	EXTERN __mulint_callee
	EXTERN __mullong
	EXTERN __mullong_callee
	EXTERN __mullonglong
	EXTERN __mullonglong_callee
	EXTERN __mulschar
	EXTERN __mulschar_callee
	EXTERN __mulsuchar
	EXTERN __mulsuchar_callee
	EXTERN __muluchar
	EXTERN __muluchar_callee
	EXTERN __muluschar
	EXTERN __muluschar_callee
	EXTERN __rlslonglong
	EXTERN __rlslonglong_callee
	EXTERN __rlulonglong
	EXTERN __rlulonglong_callee
	EXTERN __rrslonglong
	EXTERN __rrslonglong_callee
	EXTERN __rrulonglong
	EXTERN __rrulonglong_callee
	EXTERN ___mulsint2slong
	EXTERN ___mulsint2slong_callee
	EXTERN ___muluint2ulong
	EXTERN ___muluint2ulong_callee
	EXTERN ___sdcc_call_hl
	EXTERN ___sdcc_call_iy
	EXTERN ___sdcc_enter_ix
	EXTERN banked_call
	EXTERN _banked_ret
	EXTERN ___fs2schar
	EXTERN ___fs2schar_callee
	EXTERN ___fs2sint
	EXTERN ___fs2sint_callee
	EXTERN ___fs2slong
	EXTERN ___fs2slong_callee
	EXTERN ___fs2slonglong
	EXTERN ___fs2slonglong_callee
	EXTERN ___fs2uchar
	EXTERN ___fs2uchar_callee
	EXTERN ___fs2uint
	EXTERN ___fs2uint_callee
	EXTERN ___fs2ulong
	EXTERN ___fs2ulong_callee
	EXTERN ___fs2ulonglong
	EXTERN ___fs2ulonglong_callee
	EXTERN ___fsadd
	EXTERN ___fsadd_callee
	EXTERN ___fsdiv
	EXTERN ___fsdiv_callee
	EXTERN ___fseq
	EXTERN ___fseq_callee
	EXTERN ___fsgt
	EXTERN ___fsgt_callee
	EXTERN ___fslt
	EXTERN ___fslt_callee
	EXTERN ___fsmul
	EXTERN ___fsmul_callee
	EXTERN ___fsneq
	EXTERN ___fsneq_callee
	EXTERN ___fssub
	EXTERN ___fssub_callee
	EXTERN ___schar2fs
	EXTERN ___schar2fs_callee
	EXTERN ___sint2fs
	EXTERN ___sint2fs_callee
	EXTERN ___slong2fs
	EXTERN ___slong2fs_callee
	EXTERN ___slonglong2fs
	EXTERN ___slonglong2fs_callee
	EXTERN ___uchar2fs
	EXTERN ___uchar2fs_callee
	EXTERN ___uint2fs
	EXTERN ___uint2fs_callee
	EXTERN ___ulong2fs
	EXTERN ___ulong2fs_callee
	EXTERN ___ulonglong2fs
	EXTERN ___ulonglong2fs_callee
	EXTERN ____sdcc_2_copy_src_mhl_dst_deix
	EXTERN ____sdcc_2_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_deix
	EXTERN ____sdcc_4_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_mbc
	EXTERN ____sdcc_4_ldi_nosave_bc
	EXTERN ____sdcc_4_ldi_save_bc
	EXTERN ____sdcc_4_push_hlix
	EXTERN ____sdcc_4_push_mhl
	EXTERN ____sdcc_lib_setmem_hl
	EXTERN ____sdcc_ll_add_de_bc_hl
	EXTERN ____sdcc_ll_add_de_bc_hlix
	EXTERN ____sdcc_ll_add_de_hlix_bc
	EXTERN ____sdcc_ll_add_de_hlix_bcix
	EXTERN ____sdcc_ll_add_deix_bc_hl
	EXTERN ____sdcc_ll_add_deix_hlix
	EXTERN ____sdcc_ll_add_hlix_bc_deix
	EXTERN ____sdcc_ll_add_hlix_deix_bc
	EXTERN ____sdcc_ll_add_hlix_deix_bcix
	EXTERN ____sdcc_ll_asr_hlix_a
	EXTERN ____sdcc_ll_asr_mbc_a
	EXTERN ____sdcc_ll_copy_src_de_dst_hlix
	EXTERN ____sdcc_ll_copy_src_de_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_deix_dst_hl
	EXTERN ____sdcc_ll_copy_src_deix_dst_hlix
	EXTERN ____sdcc_ll_copy_src_deixm_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_desp_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_hl_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_deixm
	EXTERN ____sdcc_ll_lsl_hlix_a
	EXTERN ____sdcc_ll_lsl_mbc_a
	EXTERN ____sdcc_ll_lsr_hlix_a
	EXTERN ____sdcc_ll_lsr_mbc_a
	EXTERN ____sdcc_ll_push_hlix
	EXTERN ____sdcc_ll_push_mhl
	EXTERN ____sdcc_ll_sub_de_bc_hl
	EXTERN ____sdcc_ll_sub_de_bc_hlix
	EXTERN ____sdcc_ll_sub_de_hlix_bc
	EXTERN ____sdcc_ll_sub_de_hlix_bcix
	EXTERN ____sdcc_ll_sub_deix_bc_hl
	EXTERN ____sdcc_ll_sub_deix_hlix
	EXTERN ____sdcc_ll_sub_hlix_bc_deix
	EXTERN ____sdcc_ll_sub_hlix_deix_bc
	EXTERN ____sdcc_ll_sub_hlix_deix_bcix
	EXTERN ____sdcc_load_debc_deix
	EXTERN ____sdcc_load_dehl_deix
	EXTERN ____sdcc_load_debc_mhl
	EXTERN ____sdcc_load_hlde_mhl
	EXTERN ____sdcc_store_dehl_bcix
	EXTERN ____sdcc_store_debc_hlix
	EXTERN ____sdcc_store_debc_mhl
	EXTERN ____sdcc_cpu_pop_ei
	EXTERN ____sdcc_cpu_pop_ei_jp
	EXTERN ____sdcc_cpu_push_di
	EXTERN ____sdcc_outi
	EXTERN ____sdcc_outi_128
	EXTERN ____sdcc_outi_256
	EXTERN ____sdcc_ldi
	EXTERN ____sdcc_ldi_128
	EXTERN ____sdcc_ldi_256
	EXTERN ____sdcc_4_copy_srcd_hlix_dst_deix
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_dehl_dst_bcix
	EXTERN ____sdcc_4_and_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_cpl_src_mhl_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_or_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_hlix_dst_debc

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	GLOBAL _hud_draw
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _video_print_at
	GLOBAL _zx_pattern_fill_callee
	GLOBAL _zx_pattern_fill
	GLOBAL _zx_saddrpup_fastcall
	GLOBAL _zx_saddrpup
	GLOBAL _zx_saddrpright_callee
	GLOBAL _zx_saddrpright
	GLOBAL _zx_saddrpleft_callee
	GLOBAL _zx_saddrpleft
	GLOBAL _zx_saddrpdown_fastcall
	GLOBAL _zx_saddrpdown
	GLOBAL _zx_saddrcup_fastcall
	GLOBAL _zx_saddrcup
	GLOBAL _zx_saddrcright_fastcall
	GLOBAL _zx_saddrcright
	GLOBAL _zx_saddrcleft_fastcall
	GLOBAL _zx_saddrcleft
	GLOBAL _zx_saddrcdown_fastcall
	GLOBAL _zx_saddrcdown
	GLOBAL _zx_saddr2py_fastcall
	GLOBAL _zx_saddr2py
	GLOBAL _zx_saddr2px_fastcall
	GLOBAL _zx_saddr2px
	GLOBAL _zx_saddr2cy_fastcall
	GLOBAL _zx_saddr2cy
	GLOBAL _zx_saddr2cx_fastcall
	GLOBAL _zx_saddr2cx
	GLOBAL _zx_saddr2aaddr_fastcall
	GLOBAL _zx_saddr2aaddr
	GLOBAL _zx_py2saddr_fastcall
	GLOBAL _zx_py2saddr
	GLOBAL _zx_py2aaddr_fastcall
	GLOBAL _zx_py2aaddr
	GLOBAL _zx_pxy2saddr_callee
	GLOBAL _zx_pxy2saddr
	GLOBAL _zx_pxy2aaddr_callee
	GLOBAL _zx_pxy2aaddr
	GLOBAL _zx_px2bitmask_fastcall
	GLOBAL _zx_px2bitmask
	GLOBAL _zx_cy2saddr_fastcall
	GLOBAL _zx_cy2saddr
	GLOBAL _zx_cy2aaddr_fastcall
	GLOBAL _zx_cy2aaddr
	GLOBAL _zx_cxy2saddr_callee
	GLOBAL _zx_cxy2saddr
	GLOBAL _zx_cxy2aaddr_callee
	GLOBAL _zx_cxy2aaddr
	GLOBAL _zx_bitmask2px_fastcall
	GLOBAL _zx_bitmask2px
	GLOBAL _zx_aaddrcup_fastcall
	GLOBAL _zx_aaddrcup
	GLOBAL _zx_aaddrcright_fastcall
	GLOBAL _zx_aaddrcright
	GLOBAL _zx_aaddrcleft_fastcall
	GLOBAL _zx_aaddrcleft
	GLOBAL _zx_aaddrcdown_fastcall
	GLOBAL _zx_aaddrcdown
	GLOBAL _zx_aaddr2saddr_fastcall
	GLOBAL _zx_aaddr2saddr
	GLOBAL _zx_aaddr2py_fastcall
	GLOBAL _zx_aaddr2py
	GLOBAL _zx_aaddr2px_fastcall
	GLOBAL _zx_aaddr2px
	GLOBAL _zx_aaddr2cy_fastcall
	GLOBAL _zx_aaddr2cy
	GLOBAL _zx_aaddr2cx_fastcall
	GLOBAL _zx_aaddr2cx
	GLOBAL _zx_visit_wc_pix_callee
	GLOBAL _zx_visit_wc_pix
	GLOBAL _zx_visit_wc_attr_callee
	GLOBAL _zx_visit_wc_attr
	GLOBAL _zx_scroll_wc_up_pix_callee
	GLOBAL _zx_scroll_wc_up_pix
	GLOBAL _zx_scroll_wc_up_attr_callee
	GLOBAL _zx_scroll_wc_up_attr
	GLOBAL _zx_scroll_wc_up_callee
	GLOBAL _zx_scroll_wc_up
	GLOBAL _zx_scroll_up_pix_callee
	GLOBAL _zx_scroll_up_pix
	GLOBAL _zx_scroll_up_attr_callee
	GLOBAL _zx_scroll_up_attr
	GLOBAL _zx_scroll_up_callee
	GLOBAL _zx_scroll_up
	GLOBAL _zx_cls_wc_pix_callee
	GLOBAL _zx_cls_wc_pix
	GLOBAL _zx_cls_wc_attr_callee
	GLOBAL _zx_cls_wc_attr
	GLOBAL _zx_cls_wc_callee
	GLOBAL _zx_cls_wc
	GLOBAL _zx_cls_pix_fastcall
	GLOBAL _zx_cls_pix
	GLOBAL _zx_cls_attr_fastcall
	GLOBAL _zx_cls_attr
	GLOBAL _zx_cls_fastcall
	GLOBAL _zx_cls
	GLOBAL _zx_border_fastcall
	GLOBAL _zx_border
	GLOBAL _zx_tape_verify_block_callee
	GLOBAL _zx_tape_verify_block
	GLOBAL _zx_tape_save_block_callee
	GLOBAL _zx_tape_save_block
	GLOBAL _zx_tape_load_block_callee
	GLOBAL _zx_tape_load_block
	GLOBAL _GLOBAL_ZX_PORT_7FFD
	GLOBAL _GLOBAL_ZX_PORT_1FFD
	GLOBAL _GLOBAL_ZX_PORT_FE
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
defc _IO_FE	=	0x00fe
defc _IO_1FFD	=	0x1ffd
defc _IO_7FFD	=	0x7ffd
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION bss_compiler
_score_buf:
	DEFS 8
;--------------------------------------------------------
; ram data
;--------------------------------------------------------

IF 0

; .area _INITIALIZED removed by z88dk


ENDIF

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION code_crt_init
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION code_home
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION code_compiler
;	---------------------------------
; Function uint16_to_str
; ---------------------------------
_uint16_to_str:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	l,(ix+6)
	ld	h,(ix+7)
	ld	de,0x0006
	add	hl, de
	ld	(hl),0x00
	ld	c,0x05
l_uint16_to_str_00102:
	ld	a, c
	add	a,(ix+6)
	ld	e, a
	ld	a,0x00
	adc	a,(ix+7)
	ld	d, a
	push	bc
	push	de
	ld	hl,0x000a
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	__moduint_callee
	pop	de
	pop	bc
	ld	a, l
	add	a,0x30
	ld	(de), a
	push	bc
	ld	hl,0x000a
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	__divuint_callee
	pop	bc
	ld	(ix+4),l
	ld	(ix+5),h
	dec	c
	bit	7, c
	jr	Z,l_uint16_to_str_00102
	pop	ix
	ret
;	---------------------------------
; Function draw_energy_bar
; ---------------------------------
_draw_energy_bar:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl, -13
	add	hl, sp
	ld	sp, hl
	ld	a,(ix+6)
	ld	h,0x0a
	ld	l,a
	push	hl
	call	__divuchar_callee
	ld	c, l
	ld	hl,0
	add	hl, sp
	ld	(hl),0x5b
	ex	de,hl
	ld	b,0x00
l_draw_energy_bar_00102:
	ld	l, b
	inc	l
	ld	h,0x00
	add	hl, de
	ld	a, b
	sub	a, c
	jr	NC,l_draw_energy_bar_00106
	ld	a,0x3d
	jr	l_draw_energy_bar_00107
l_draw_energy_bar_00106:
	ld	a,0x20
l_draw_energy_bar_00107:
	ld	(hl), a
	inc	b
	ld	a, b
	sub	a,0x0a
	jr	C,l_draw_energy_bar_00102
	ld	(ix-2),0x5d
	ld	(ix-1),0x00
	push	de
	ld	h,(ix+5)
	ld	l,(ix+4)
	push	hl
	call	_video_print_at
	ld	sp,ix
	pop	ix
	ret
;	---------------------------------
; Function hud_draw
; ---------------------------------
_hud_draw:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	hl,_score_buf
	push	hl
	ld	l,(ix+4)
	ld	h,(ix+5)
	push	hl
	call	_uint16_to_str
	pop	af
	ld	hl,___str_0
	ex	(sp),hl
	xor	a, a
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_video_print_at
	pop	af
	ld	hl,_score_buf
	ex	(sp),hl
	ld	a,0x03
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_video_print_at
	pop	af
	pop	af
	ld	hl,0x3a4c
	ld	(_score_buf),hl
	ld	a,(ix+6)
	add	a,0x30
	ld	l,a
	ld	h,0x00
	ld	((_score_buf + 2)),hl
	ld	hl,_score_buf
	push	hl
	ld	a,0x0b
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_video_print_at
	pop	af
	ld	hl,___str_1
	ex	(sp),hl
	ld	a,0x10
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_video_print_at
	pop	af
	pop	af
	ld	d,(ix+7)
	ld	e,0x13
	push	de
	xor	a, a
	push	af
	inc	sp
	call	_draw_energy_bar
	pop	af
	inc	sp
	pop	ix
	ret
	SECTION rodata_compiler
___str_0:
	DEFM "SC:"
	DEFB 0x00
	SECTION rodata_compiler
___str_1:
	DEFM "TM:"
	DEFB 0x00
	SECTION IGNORE
