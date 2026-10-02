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
	GLOBAL _main
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _sprite_draw_masked
	GLOBAL _sprite_draw
	GLOBAL _isr_install
	GLOBAL _sound_fx_timeshift
	GLOBAL _sound_fx_hit
	GLOBAL _sound_fx_pickup
	GLOBAL _sound_beep
	GLOBAL _input_read_keys
	GLOBAL _video_print_at
	GLOBAL _video_set_border
	GLOBAL _video_cls
	GLOBAL _hud_draw
	GLOBAL _chrono_is_slowmo
	GLOBAL _chrono_get_energy
	GLOBAL _chrono_get_state
	GLOBAL _chrono_update
	GLOBAL _chrono_init
	GLOBAL _level_get_tile
	GLOBAL _level_check_exit
	GLOBAL _level_check_collision
	GLOBAL _level_draw
	GLOBAL _level_load
	GLOBAL _player_get_lives
	GLOBAL _player_get_y
	GLOBAL _player_get_x
	GLOBAL _player_reset_position
	GLOBAL _player_on_hit
	GLOBAL _player_draw
	GLOBAL _player_update
	GLOBAL _player_init
	GLOBAL _ffsll_callee
	GLOBAL _ffsll
	GLOBAL _strxfrm_callee
	GLOBAL _strxfrm
	GLOBAL _strupr_fastcall
	GLOBAL _strupr
	GLOBAL _strtok_r_callee
	GLOBAL _strtok_r
	GLOBAL _strtok_callee
	GLOBAL _strtok
	GLOBAL _strstrip_fastcall
	GLOBAL _strstrip
	GLOBAL _strstr_callee
	GLOBAL _strstr
	GLOBAL _strspn_callee
	GLOBAL _strspn
	GLOBAL _strsep_callee
	GLOBAL _strsep
	GLOBAL _strrstrip_fastcall
	GLOBAL _strrstrip
	GLOBAL _strrstr_callee
	GLOBAL _strrstr
	GLOBAL _strrspn_callee
	GLOBAL _strrspn
	GLOBAL _strrev_fastcall
	GLOBAL _strrev
	GLOBAL _strrcspn_callee
	GLOBAL _strrcspn
	GLOBAL _strrchr_callee
	GLOBAL _strrchr
	GLOBAL _strpbrk_callee
	GLOBAL _strpbrk
	GLOBAL _strnlen_callee
	GLOBAL _strnlen
	GLOBAL _strnicmp_callee
	GLOBAL _strnicmp
	GLOBAL _strndup_callee
	GLOBAL _strndup
	GLOBAL _strncpy_callee
	GLOBAL _strncpy
	GLOBAL _strncmp_callee
	GLOBAL _strncmp
	GLOBAL _strnchr_callee
	GLOBAL _strnchr
	GLOBAL _strncat_callee
	GLOBAL _strncat
	GLOBAL _strncasecmp_callee
	GLOBAL _strncasecmp
	GLOBAL _strlwr_fastcall
	GLOBAL _strlwr
	GLOBAL _strlen_fastcall
	GLOBAL _strlen
	GLOBAL _strlcpy_callee
	GLOBAL _strlcpy
	GLOBAL _strlcat_callee
	GLOBAL _strlcat
	GLOBAL _stricmp_callee
	GLOBAL _stricmp
	GLOBAL _strerror_fastcall
	GLOBAL _strerror
	GLOBAL _strdup_fastcall
	GLOBAL _strdup
	GLOBAL _strcspn_callee
	GLOBAL _strcspn
	GLOBAL _strcpy_callee
	GLOBAL _strcpy
	GLOBAL _strcoll_callee
	GLOBAL _strcoll
	GLOBAL _strcmp_callee
	GLOBAL _strcmp
	GLOBAL _strchrnul_callee
	GLOBAL _strchrnul
	GLOBAL _strchr_callee
	GLOBAL _strchr
	GLOBAL _strcat_callee
	GLOBAL _strcat
	GLOBAL _strcasecmp_callee
	GLOBAL _strcasecmp
	GLOBAL _stpncpy_callee
	GLOBAL _stpncpy
	GLOBAL _stpcpy_callee
	GLOBAL _stpcpy
	GLOBAL _memswap_callee
	GLOBAL _memswap
	GLOBAL _memset_wr_callee
	GLOBAL _memset_wr
	GLOBAL _memset_callee
	GLOBAL _memset
	GLOBAL _memrchr_callee
	GLOBAL _memrchr
	GLOBAL _memmove_callee
	GLOBAL _memmove
	GLOBAL _memmem_callee
	GLOBAL _memmem
	GLOBAL _memcpy_callee
	GLOBAL _memcpy
	GLOBAL _memcmp_callee
	GLOBAL _memcmp
	GLOBAL _memchr_callee
	GLOBAL _memchr
	GLOBAL _memccpy_callee
	GLOBAL _memccpy
	GLOBAL _ffsl_fastcall
	GLOBAL _ffsl
	GLOBAL _ffs_fastcall
	GLOBAL _ffs
	GLOBAL __strrstrip__fastcall
	GLOBAL __strrstrip_
	GLOBAL __memupr__callee
	GLOBAL __memupr_
	GLOBAL __memstrcpy__callee
	GLOBAL __memstrcpy_
	GLOBAL __memlwr__callee
	GLOBAL __memlwr_
	GLOBAL _rawmemchr_callee
	GLOBAL _rawmemchr
	GLOBAL _strnset_callee
	GLOBAL _strnset
	GLOBAL _strset_callee
	GLOBAL _strset
	GLOBAL _rindex_callee
	GLOBAL _rindex
	GLOBAL _index_callee
	GLOBAL _index
	GLOBAL _bzero_callee
	GLOBAL _bzero
	GLOBAL _bcopy_callee
	GLOBAL _bcopy
	GLOBAL _bcmp_callee
	GLOBAL _bcmp
	GLOBAL _intrinsic_swap_word_32_fastcall
	GLOBAL _intrinsic_swap_word_32
	GLOBAL _intrinsic_swap_endian_32_fastcall
	GLOBAL _intrinsic_swap_endian_32
	GLOBAL _intrinsic_swap_endian_16_fastcall
	GLOBAL _intrinsic_swap_endian_16
	GLOBAL _intrinsic_return_de
	GLOBAL _intrinsic_return_bc
	GLOBAL _intrinsic_exx
	GLOBAL _intrinsic_ex_de_hl
	GLOBAL _intrinsic_nop
	GLOBAL _intrinsic_im_2
	GLOBAL _intrinsic_im_1
	GLOBAL _intrinsic_im_0
	GLOBAL _intrinsic_retn
	GLOBAL _intrinsic_reti
	GLOBAL _intrinsic_halt
	GLOBAL _intrinsic_ei
	GLOBAL _intrinsic_di
	GLOBAL _intrinsic_stub
	GLOBAL _intrinsic_ini
	GLOBAL _intrinsic_outi
	GLOBAL _intrinsic_ldi
	GLOBAL _z80_otdr_callee
	GLOBAL _z80_otdr
	GLOBAL _z80_otir_callee
	GLOBAL _z80_otir
	GLOBAL _z80_outp_callee
	GLOBAL _z80_outp
	GLOBAL _z80_indr_callee
	GLOBAL _z80_indr
	GLOBAL _z80_inir_callee
	GLOBAL _z80_inir
	GLOBAL _z80_inp_fastcall
	GLOBAL _z80_inp
	GLOBAL _z80_set_int_state_fastcall
	GLOBAL _z80_set_int_state
	GLOBAL _z80_get_int_state
	GLOBAL _z80_delay_tstate_fastcall
	GLOBAL _z80_delay_tstate
	GLOBAL _z80_delay_ms_fastcall
	GLOBAL _z80_delay_ms
	GLOBAL _im2_remove_generic_callback_callee
	GLOBAL _im2_remove_generic_callback
	GLOBAL _im2_prepend_generic_callback_callee
	GLOBAL _im2_prepend_generic_callback
	GLOBAL _im2_append_generic_callback_callee
	GLOBAL _im2_append_generic_callback
	GLOBAL _im2_create_generic_isr_8080_callee
	GLOBAL _im2_create_generic_isr_8080
	GLOBAL _im2_create_generic_isr_callee
	GLOBAL _im2_create_generic_isr
	GLOBAL _im2_install_isr_callee
	GLOBAL _im2_install_isr
	GLOBAL _im2_init_fastcall
	GLOBAL _im2_init
	GLOBAL _in_mouse_kempston_wheel_delta
	GLOBAL _in_mouse_kempston_wheel
	GLOBAL _in_mouse_kempston_callee
	GLOBAL _in_mouse_kempston
	GLOBAL _in_mouse_kempston_setpos_callee
	GLOBAL _in_mouse_kempston_setpos
	GLOBAL _in_mouse_kempston_reset
	GLOBAL _in_mouse_kempston_init
	GLOBAL _in_mouse_amx_wheel_delta
	GLOBAL _in_mouse_amx_wheel
	GLOBAL _in_mouse_amx_callee
	GLOBAL _in_mouse_amx
	GLOBAL _in_mouse_amx_setpos_callee
	GLOBAL _in_mouse_amx_setpos
	GLOBAL _in_mouse_amx_reset
	GLOBAL _in_mouse_amx_init_callee
	GLOBAL _in_mouse_amx_init
	GLOBAL _in_stick_sinclair2
	GLOBAL _in_stick_sinclair1
	GLOBAL _in_stick_kempston
	GLOBAL _in_stick_fuller
	GLOBAL _in_stick_cursor
	GLOBAL _in_stick_keyboard_fastcall
	GLOBAL _in_stick_keyboard
	GLOBAL _in_wait_nokey
	GLOBAL _in_wait_key
	GLOBAL _in_test_key
	GLOBAL _in_pause_fastcall
	GLOBAL _in_pause
	GLOBAL _in_key_scancode_fastcall
	GLOBAL _in_key_scancode
	GLOBAL _in_key_pressed_fastcall
	GLOBAL _in_key_pressed
	GLOBAL _in_inkey
	GLOBAL _sp1_Validate_fastcall
	GLOBAL _sp1_Validate
	GLOBAL _sp1_Invalidate_fastcall
	GLOBAL _sp1_Invalidate
	GLOBAL _sp1_RestoreUpdateStruct_fastcall
	GLOBAL _sp1_RestoreUpdateStruct
	GLOBAL _sp1_RemoveUpdateStruct_fastcall
	GLOBAL _sp1_RemoveUpdateStruct
	GLOBAL _sp1_DrawUpdateStructAlways_fastcall
	GLOBAL _sp1_DrawUpdateStructAlways
	GLOBAL _sp1_DrawUpdateStructIfNotRem_fastcall
	GLOBAL _sp1_DrawUpdateStructIfNotRem
	GLOBAL _sp1_DrawUpdateStructIfVal_fastcall
	GLOBAL _sp1_DrawUpdateStructIfVal
	GLOBAL _sp1_DrawUpdateStructIfInv_fastcall
	GLOBAL _sp1_DrawUpdateStructIfInv
	GLOBAL _sp1_ValUpdateStruct_fastcall
	GLOBAL _sp1_ValUpdateStruct
	GLOBAL _sp1_InvUpdateStruct_fastcall
	GLOBAL _sp1_InvUpdateStruct
	GLOBAL _sp1_IterateUpdateRect_callee
	GLOBAL _sp1_IterateUpdateRect
	GLOBAL _sp1_IterateUpdateArr_callee
	GLOBAL _sp1_IterateUpdateArr
	GLOBAL _sp1_GetUpdateStruct_callee
	GLOBAL _sp1_GetUpdateStruct
	GLOBAL _sp1_UpdateNow
	GLOBAL _sp1_Initialize_callee
	GLOBAL _sp1_Initialize
	GLOBAL _sp1_ClearRectInv_callee
	GLOBAL _sp1_ClearRectInv
	GLOBAL _sp1_ClearRect_callee
	GLOBAL _sp1_ClearRect
	GLOBAL _sp1_PutTilesInv_callee
	GLOBAL _sp1_PutTilesInv
	GLOBAL _sp1_PutTiles_callee
	GLOBAL _sp1_PutTiles
	GLOBAL _sp1_GetTiles_callee
	GLOBAL _sp1_GetTiles
	GLOBAL _sp1_SetPrintPos_callee
	GLOBAL _sp1_SetPrintPos
	GLOBAL _sp1_PrintString_callee
	GLOBAL _sp1_PrintString
	GLOBAL _sp1_ScreenAttr_callee
	GLOBAL _sp1_ScreenAttr
	GLOBAL _sp1_ScreenStr_callee
	GLOBAL _sp1_ScreenStr
	GLOBAL _sp1_PrintAtInv_callee
	GLOBAL _sp1_PrintAtInv
	GLOBAL _sp1_PrintAt_callee
	GLOBAL _sp1_PrintAt
	GLOBAL _sp1_TileEntry_callee
	GLOBAL _sp1_TileEntry
	GLOBAL _sp1_RemoveCharStruct_fastcall
	GLOBAL _sp1_RemoveCharStruct
	GLOBAL _sp1_InsertCharStruct_callee
	GLOBAL _sp1_InsertCharStruct
	GLOBAL _sp1_InitCharStruct_callee
	GLOBAL _sp1_InitCharStruct
	GLOBAL _sp1_PreShiftSpr_callee
	GLOBAL _sp1_PreShiftSpr
	GLOBAL _sp1_GetSprClr_callee
	GLOBAL _sp1_GetSprClr
	GLOBAL _sp1_PutSprClr_callee
	GLOBAL _sp1_PutSprClr
	GLOBAL _sp1_GetSprClrAddr_callee
	GLOBAL _sp1_GetSprClrAddr
	GLOBAL _sp1_IterateUpdateSpr_callee
	GLOBAL _sp1_IterateUpdateSpr
	GLOBAL _sp1_IterateSprChar_callee
	GLOBAL _sp1_IterateSprChar
	GLOBAL _sp1_MoveSprPix_callee
	GLOBAL _sp1_MoveSprPix
	GLOBAL _sp1_MoveSprRel_callee
	GLOBAL _sp1_MoveSprRel
	GLOBAL _sp1_MoveSprAbs_callee
	GLOBAL _sp1_MoveSprAbs
	GLOBAL _sp1_DeleteSpr_fastcall
	GLOBAL _sp1_DeleteSpr
	GLOBAL _sp1_ChangeSprType_callee
	GLOBAL _sp1_ChangeSprType
	GLOBAL _sp1_AddColSpr_callee
	GLOBAL _sp1_AddColSpr
	GLOBAL _sp1_CreateSpr_callee
	GLOBAL _sp1_CreateSpr
	GLOBAL _SP1_DRAW_ATTR
	GLOBAL _SP1_DRAW_LOAD1RBIM
	GLOBAL _SP1_DRAW_LOAD1LBIM
	GLOBAL _SP1_DRAW_XOR1RB
	GLOBAL _SP1_DRAW_XOR1LB
	GLOBAL _SP1_DRAW_XOR1NR
	GLOBAL _SP1_DRAW_XOR1
	GLOBAL _SP1_DRAW_OR1RB
	GLOBAL _SP1_DRAW_OR1LB
	GLOBAL _SP1_DRAW_OR1NR
	GLOBAL _SP1_DRAW_OR1
	GLOBAL _SP1_DRAW_LOAD1RB
	GLOBAL _SP1_DRAW_LOAD1LB
	GLOBAL _SP1_DRAW_LOAD1NR
	GLOBAL _SP1_DRAW_LOAD1
	GLOBAL _SP1_DRAW_LOAD2RBIM
	GLOBAL _SP1_DRAW_LOAD2LBIM
	GLOBAL _SP1_DRAW_XOR2RB
	GLOBAL _SP1_DRAW_XOR2LB
	GLOBAL _SP1_DRAW_XOR2NR
	GLOBAL _SP1_DRAW_XOR2
	GLOBAL _SP1_DRAW_OR2RB
	GLOBAL _SP1_DRAW_OR2LB
	GLOBAL _SP1_DRAW_OR2NR
	GLOBAL _SP1_DRAW_OR2
	GLOBAL _SP1_DRAW_LOAD2RB
	GLOBAL _SP1_DRAW_LOAD2LB
	GLOBAL _SP1_DRAW_LOAD2NR
	GLOBAL _SP1_DRAW_LOAD2
	GLOBAL _SP1_DRAW_MASK2RB
	GLOBAL _SP1_DRAW_MASK2LB
	GLOBAL _SP1_DRAW_MASK2NR
	GLOBAL _SP1_DRAW_MASK2
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
	GLOBAL _sp1_struct_ss_prototype
	GLOBAL _sp1_struct_cs_prototype
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
_game_state:
	DEFS 1
_current_level:
	DEFS 1
_score:
	DEFS 2
_lives:
	DEFS 1
_frame_counter:
	DEFS 1
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
; Function show_title_screen
; ---------------------------------
_show_title_screen:
	ld	a,0x07
	push	af
	inc	sp
	call	_video_cls
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_video_set_border
	inc	sp
	ld	hl,___str_0
	push	hl
	ld	de,0x0903
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_1
	ex	(sp),hl
	ld	de,0x0606
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_2
	ex	(sp),hl
	ld	de,0x070a
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_3
	ex	(sp),hl
	ld	de,0x070c
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_4
	ex	(sp),hl
	ld	de,0x070d
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_5
	ex	(sp),hl
	ld	de,0x070e
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_6
	ex	(sp),hl
	ld	de,0x070f
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_7
	ex	(sp),hl
	ld	de,0x0513
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_8
	ex	(sp),hl
	ld	de,0x0516
	push	de
	call	_video_print_at
	pop	af
	pop	af
l_show_title_screen_00101:
	call	_input_read_keys
	bit	4, l
	jr	NZ,l_show_title_screen_00103
	ld	hl,0x0032
	call	_z80_delay_ms_fastcall
	jr	l_show_title_screen_00101
l_show_title_screen_00103:
	ld	hl,0x00c8
	jp	_z80_delay_ms_fastcall
	SECTION rodata_compiler
___str_0:
	DEFM "C H R O N O S"
	DEFB 0x00
	SECTION rodata_compiler
___str_1:
	DEFM "A Time-Bending Adventure"
	DEFB 0x00
	SECTION rodata_compiler
___str_2:
	DEFM "Controls:"
	DEFB 0x00
	SECTION rodata_compiler
___str_3:
	DEFM "Q/A   - Up/Down"
	DEFB 0x00
	SECTION rodata_compiler
___str_4:
	DEFM "O/P   - Left/Right"
	DEFB 0x00
	SECTION rodata_compiler
___str_5:
	DEFM "SPACE - Time Shift"
	DEFB 0x00
	SECTION rodata_compiler
___str_6:
	DEFM "M     - Pause"
	DEFB 0x00
	SECTION rodata_compiler
___str_7:
	DEFM "Press SPACE to begin..."
	DEFB 0x00
	SECTION rodata_compiler
___str_8:
	DEFM "(c) 2026 Chronos Project"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function show_game_over
; ---------------------------------
_show_game_over:
	ld	a,0x02
	push	af
	inc	sp
	call	_video_cls
	inc	sp
	ld	a,0x02
	push	af
	inc	sp
	call	_video_set_border
	inc	sp
	ld	hl,___str_9
	push	hl
	ld	de,0x0a08
	push	de
	call	_video_print_at
	pop	af
	ld	hl,___str_10
	ex	(sp),hl
	ld	de,0x070c
	push	de
	call	_video_print_at
	pop	af
	pop	af
	call	_sound_fx_hit
l_show_game_over_00101:
	call	_input_read_keys
	bit	4, l
	jr	NZ,l_show_game_over_00103
	ld	hl,0x0032
	call	_z80_delay_ms_fastcall
	jr	l_show_game_over_00101
l_show_game_over_00103:
	ld	hl,0x00c8
	jp	_z80_delay_ms_fastcall
	SECTION rodata_compiler
___str_9:
	DEFM "GAME  OVER"
	DEFB 0x00
	SECTION rodata_compiler
___str_10:
	DEFM "Press SPACE to retry"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function show_level_complete
; ---------------------------------
_show_level_complete:
	ld	a,0x04
	push	af
	inc	sp
	call	_video_cls
	inc	sp
	ld	a,0x04
	push	af
	inc	sp
	call	_video_set_border
	inc	sp
	ld	hl,___str_11
	push	hl
	ld	de,0x0808
	push	de
	call	_video_print_at
	pop	af
	pop	af
	call	_sound_fx_pickup
	ld	hl,0x07d0
	jp	_z80_delay_ms_fastcall
	SECTION rodata_compiler
___str_11:
	DEFM "LEVEL COMPLETE!"
	DEFB 0x00
	SECTION code_compiler
;	---------------------------------
; Function game_init
; ---------------------------------
_game_init:
	xor	a, a
	ld	hl,_score
	ld	(hl), a
	inc	hl
	ld	(hl), a
	ld	hl,_lives
	ld	(hl),0x03
	xor	a, a
	ld	(_current_level),a
	xor	a, a
	ld	(_frame_counter),a
	call	_player_init
	jp	_chrono_init
;	---------------------------------
; Function game_update
; ---------------------------------
_game_update:
	ld	hl,_frame_counter
	inc	(hl)
	call	_input_read_keys
	ld	b, l
	bit	5, b
	jr	Z,l_game_update_00102
	ld	hl,_game_state
	ld	(hl),0x02
	jp	l_game_update_00112
l_game_update_00102:
	push	bc
	push	bc
	inc	sp
	call	_chrono_update
	inc	sp
	inc	sp
	call	_player_update
	inc	sp
	call	_player_get_y
	ld	b, l
	push	bc
	call	_player_get_x
	ld	a, l
	inc	sp
	push	af
	inc	sp
	call	_level_check_collision
	pop	af
	ld	a, l
	or	a, a
	jr	Z,l_game_update_00106
	call	_player_on_hit
	call	_sound_fx_hit
	call	_player_get_lives
	ld	a, l
	or	a, a
	jr	NZ,l_game_update_00106
	ld	hl,_game_state
	ld	(hl),0x03
	jr	l_game_update_00112
l_game_update_00106:
	call	_player_get_y
	ld	b, l
	push	bc
	call	_player_get_x
	ld	a, l
	inc	sp
	push	af
	inc	sp
	call	_level_check_exit
	pop	af
	ld	a, l
	or	a, a
	jr	Z,l_game_update_00111
	ld	hl,_current_level
	inc	(hl)
	ld	a, (hl)
	sub	a,0x03
	jr	C,l_game_update_00108
	ld	hl,_game_state
	ld	(hl),0x03
	jr	l_game_update_00109
l_game_update_00108:
	ld	hl,_game_state
	ld	(hl),0x04
l_game_update_00109:
	jr	l_game_update_00112
l_game_update_00111:
	ld	a,0x07
	push	af
	inc	sp
	call	_video_cls
	inc	sp
	ld	a, (_current_level)
	push	af
	inc	sp
	call	_level_draw
	inc	sp
	call	_player_draw
	call	_chrono_get_energy
	ld	a, l
	push	af
	inc	sp
	ld	a, (_lives)
	push	af
	inc	sp
	ld	hl, (_score)
	push	hl
	call	_hud_draw
	pop	af
	pop	af
l_game_update_00112:
	ret
;	---------------------------------
; Function main
; ---------------------------------
_main:
	call	_isr_install
	ei
l_main_00111:
	ld	a,0x04
	ld	hl,_game_state
	sub	a, (hl)
	jr	C,l_main_00111
	ld	c, (hl)
	ld	b,0x00
	ld	hl,l_main_00143
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
l_main_00143:
	DEFW	l_main_00101
	DEFW	l_main_00102
	DEFW	l_main_00103
	DEFW	l_main_00107
	DEFW	l_main_00108
l_main_00101:
	call	_show_title_screen
	call	_game_init
	ld	hl,_game_state
	ld	(hl),0x01
	jr	l_main_00111
l_main_00102:
	halt
	call	_game_update
	jr	l_main_00111
l_main_00103:
	ld	hl,___str_12
	push	hl
	ld	de,0x0b0a
	push	de
	call	_video_print_at
	pop	af
	pop	af
l_main_00104:
	call	_input_read_keys
	bit	5, l
	jr	Z,l_main_00106
	ld	hl,0x0032
	call	_z80_delay_ms_fastcall
	jr	l_main_00104
l_main_00106:
	ld	hl,0x00c8
	call	_z80_delay_ms_fastcall
	ld	hl,_game_state
	ld	(hl),0x01
	jr	l_main_00111
l_main_00107:
	call	_show_game_over
	xor	a, a
	ld	(_game_state),a
	jr	l_main_00111
l_main_00108:
	call	_show_level_complete
	ld	a, (_current_level)
	push	af
	inc	sp
	call	_level_load
	inc	sp
	call	_player_reset_position
	ld	hl,_game_state
	ld	(hl),0x01
	jr	l_main_00111
	SECTION rodata_compiler
___str_12:
	DEFM "** PAUSED **"
	DEFB 0x00
	SECTION IGNORE
