; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .______        ___      .__   __.  __  ___     _  _
; |   _  \      /   \     |  \ |  | |  |/  /    | || |
; |  |_)  |    /  ^  \    |   \|  | |  '  /     | || |_
; |   _  <    /  /_\  \   |  . `  | |    <      |__   _|
; |  |_)  |  /  _____  \  |  |\   | |  .  \        | |
; |______/  /__/     \__\ |__| \__| |__|\__\       |_|


                        org 49152                       ; Build the code to run at $C000
                        dispto zeuspage(4)              ;
                     ;  dispto $20000
Addrs4:
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; vortex tracker ii v1.0 pt3 player for zx spectrum
; (c)2004,2007 s.v.bulba <vorobey@mail.khstu.ru>
; http://bulba.untergrund.net (http://bulba.at.kz)

; mfx edition by intense
; warning: uses shadow registers hl',de',bc' for stack output!
; uncomment the 'ld hl,0x2758' line if used alongside basic

; release number
release:                equ "7"                         ;

; features
; --------
; -can be compiled at any address (i.e. no need rounding org
; address).
; -variables (vars) can be located at any address (not only after
; code block).
; -init subroutine detects module version and rightly generates
; both note and volume tables outside of code block (in vars).
; -two portamento (spc. command 3xxx) algorithms (depending of
; module version).
; -new 1.xx and 2.xx special command behaviour (only for pt v3.7
; and higher).
; -any tempo value are accepted (including tempo=1 and tempo=2).
; -fully compatible with ay_emul pt3 player codes.
; -see also notes at the end of this source code.

; limitations
; -----------
; -can run in ram only (self-modified code is used).

; warning!!! play subroutine can crash if no module are loaded
; into ram or init subroutine was not called before.

; call mute or init one more time to mute sound after stopping
; playing

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


tona:                   equ 0                           ;
tonb:                   equ 2                           ;
tonc:                   equ 4                           ;
noise:                  equ 6                           ;
mixer:                  equ 7                           ;
ampla:                  equ 8                           ;
amplb:                  equ 9                           ;
amplc:                  equ 10                          ;
env:                    equ 11                          ;
envtp:                  equ 13                          ;

; entry and other points
; start initialization
; start+3 initialization with module address in hl
; start+5 play one quark
; start+8 mute
; start+10 setup and status flags
; start+11 pointer to current position value in pt3 module;
; after init (start+11) points to postion0-1 (optimization)

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


setup:                  db 0                            ; set bit0 to 1, if you want to play without looping
                        ; bit7 is set each time, when loop point is passed
                        ; (hikaru) set bit 1 before calling start+5 to push the ay register data
                        ;         for the current frame into the stack.
                        ;         note that bit 1 resets automatically at exit
crpsptr:                dw 0                            ;

; identifier
                        db "=vtii pt3 player r.",release,"=";

checklp:                ld hl,setup                     ;
                        set 7,(hl)                      ;
                        bit 0,(hl)                      ;
                        ret z                           ;
                        pop hl                          ;
                        ld hl,delycnt                   ;
                        inc (hl)                        ;
                        ld hl,chana+chp_ntskcn          ;
                        inc (hl)                        ;
; mute:                   xor a                           ;
;                        ld h,a                          ;
;                        ld l,a                          ;
;                        ld (ayregs+ampla),a             ;
;                        ld (ayregs+amplb),hl            ;
;                        jp rout_a0                      ;

init1_4:

                        ; CALL SET_INTERUPT_TO_MUSIC


; hl - addressofmodule

                        ld (modaddr),hl                 ;
                        ld (mdaddr2),hl                 ;
                        push hl                         ;
                        ld de,100                       ;
                        add hl,de                       ;
                        ld a,(hl)                       ;
                        ld (delay),a                    ;
                        push hl                         ;
                        pop ix                          ;
                        add hl,de                       ;
                        ld (crpsptr),hl                 ;
                        ld e,(ix+102-100)               ;
                        add hl,de                       ;
                        inc hl                          ;
                        ld (lposptr),hl                 ;
                        pop de                          ;
                        ld l,(ix+103-100)               ;
                        ld h,(ix+104-100)               ;
                        add hl,de                       ;
                        ld (patsptr),hl                 ;
                        ld hl,169                       ;
                        add hl,de                       ;
                        ld (ornptrs),hl                 ;
                        ld hl,105                       ;
                        add hl,de                       ;
                        ld (samptrs),hl                 ;
                        ld hl,setup                     ;
                        res 7,(hl)                      ;

; note table data depacker
                        ld de,t_pack                    ;
                        ld bc,t1_+(2*49)-1              ;
tp_0:                   ld a,(de)                       ;
                        inc de                          ;
                        cp 15*2                         ;
                        jr nc,tp_1                      ;
                        ld h,a                          ;
                        ld a,(de)                       ;
                        ld l,a                          ;
                        inc de                          ;
                        jr tp_2                         ;
tp_1:                   push de                         ;
                        ld d,0                          ;
                        ld e,a                          ;
                        add hl,de                       ;
                        add hl,de                       ;
                        pop de                          ;
tp_2:                   ld a,h                          ;
                        ld (bc),a                       ;
                        dec bc                          ;
                        ld a,l                          ;
                        ld (bc),a                       ;
                        dec bc                          ;
                        sub 0xf0                        ; #f8*2
                        jr nz,tp_0                      ;

                        ld hl,vars                      ;
                        ld (hl),a                       ;
                        ld de,vars+1                    ;
                        ld bc,var0end-vars-1            ;
                        ldir                            ;
                        inc a                           ;
                        ld (delycnt),a                  ;
                        ld hl,0xf001                    ; h - chp_volume, l - chp_ntskcn
                        ld (chana+chp_ntskcn),hl        ;
                        ld (chanb+chp_ntskcn),hl        ;
                        ld (chanc+chp_ntskcn),hl        ;

                        ld hl,emptysamorn               ;
                        ld (adinpta),hl                 ; ptr to zero
                        ld (chana+chp_ornptr),hl        ; ornament 0 is "0,1,0"
                        ld (chanb+chp_ornptr),hl        ; in all versions from
                        ld (chanc+chp_ornptr),hl        ; 3.xx to 3.6x and vtii

                        ld (chana+chp_samptr),hl        ; s1 there is no default
                        ld (chanb+chp_samptr),hl        ; s2 sample in pt3, so, you
                        ld (chanc+chp_samptr),hl        ; s3 can comment s1,2,3; see
                        ; also emptysamorn comment

                        ld a,(ix+13-100)                ; extract version number
                        sub 0x30                        ;
                        jr c,bl20                       ;
                        cp 10                           ;
                        jr c,bl21                       ;
bl20:                   ld a,6                          ;
bl21:                   ld (version),a                  ;
                        push af                         ;
                        cp 4                            ;
                        ld a,(ix+99-100)                ; tone table number
                        rla                             ;
                        and 7                           ;

; notetablecreator (c) ivan roshin
; a - notetablenumber*2+versionfornotetable
; (xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..vtii1.0)

                        ld hl,nt_data                   ;
                        push de                         ;
                        ld d,b                          ;
                        add a,a                         ;
                        ld e,a                          ;
                        add hl,de                       ;
                        ld e,(hl)                       ;
                        inc hl                          ;
                        srl e                           ;
                        sbc a,a                         ;
                        and 0xa7                        ; #00 (nop) or #a7 (and a)
                        ld (bl3),a                      ;
                        ex de,hl                        ;
                        pop bc                          ; bc=t1_
                        add hl,bc                       ;

                        ld a,(de)                       ;
                        add a,high t_                   ;
                        ld c,a                          ;
                        adc a,low t_                    ;
                        sub c                           ;
                        ld b,a                          ;
                        push bc                         ;
                        ld de,nt_                       ;
                        push de                         ;

                        ld b,12                         ;
bl1:                    push bc                         ;
                        ld c,(hl)                       ;
                        inc hl                          ;
                        push hl                         ;
                        ld b,(hl)                       ;

                        push de                         ;
                        ex de,hl                        ;
                        ld de,23                        ;
                        ld ixh,8                        ;

bl2:                    srl b                           ;
                        rr c                            ;
bl3:                    nop                             ; db 0x19 ;and a or nop
                        ld a,c                          ;
                        adc a,d                         ; =adc 0
                        ld (hl),a                       ;
                        inc hl                          ;
                        ld a,b                          ;
                        adc a,d                         ;
                        ld (hl),a                       ;
                        add hl,de                       ;
                        dec ixh                         ;
                        jr nz,bl2                       ;

                        pop de                          ;
                        inc de                          ;
                        inc de                          ;
                        pop hl                          ;
                        inc hl                          ;
                        pop bc                          ;
                        djnz bl1                        ;

                        pop hl                          ;
                        pop de                          ;

                        ld a,e                          ;
                        cp high tcold_1                 ;
                        jr nz,corr_1                    ;
                        ld a,0xfd                       ;
                        ld (nt_+0x2e),a                 ;

corr_1:                 ld a,(de)                       ;
                        and a                           ;
                        jr z,tc_exit                    ;
                        rra                             ;
                        push af                         ;
                        add a,a                         ;
                        ld c,a                          ;
                        add hl,bc                       ;
                        pop af                          ;
                        jr nc,corr_2                    ;
                        dec (hl)                        ;
                        dec (hl)                        ;
corr_2:                 inc (hl)                        ;
                        and a                           ;
                        sbc hl,bc                       ;
                        inc de                          ;
                        jr corr_1                       ;

tc_exit:

                        pop af                          ;

; voltablecreator (c) ivan roshin
; a - versionforvolumetable (0..4 - 3.xx..3.4x;
                        ; 5.. - 3.5x..3.6x..vtii1.0)

                        cp 5                            ;
                        ld hl,0x11                      ;
                        ld d,h                          ;
                        ld e,h                          ;
                        ld a,0x17                       ;
                        jr nc,m1                        ;
                        dec l                           ;
                        ld e,l                          ;
                        xor a                           ;
m1:                     ld (m2),a                       ;

                        ld ix,vt_+16                    ;
                        ld c,0x10                       ;

initv2:                 push hl                         ;

                        add hl,de                       ;
                        ex de,hl                        ;
                        sbc hl,hl                       ;

initv1:                 ld a,l                          ;
m2:                     xor a                           ; db 0x7d
                        ld a,h                          ;
                        adc a,0                         ;
                        ld (ix),a                       ;
                        inc ix                          ;
                        add hl,de                       ;
                        inc c                           ;
                        ld a,c                          ;
                        and 15                          ;
                        jr nz,initv1                    ;

                        pop hl                          ;
                        ld a,e                          ;
                        cp 0x77                         ;
                        jr nz,m3                        ;
                        inc e                           ;
m3:                     ld a,c                          ;
                        and a                           ;
                        jr nz,initv2                    ;

                        jp rout_a0                      ;

; pattern decoder
pd_orsm:                ld (ix+chp_env_en-12),0         ;
                        call setorn                     ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        rrca                            ;

pd_sam:                 add a,a                         ;
pd_sam_:                ld e,a                          ;
                        ld d,0                          ;
                        ld hl,[samptrs]0x2121           ;
                        add hl,de                       ;
                        ld e,(hl)                       ;
                        inc hl                          ;
                        ld d,(hl)                       ;
                        ld hl,[modaddr]0x2121           ;
                        add hl,de                       ;
                        ld (ix+chp_samptr-12),l         ;
                        ld (ix+chp_samptr+1-12),h       ;
                        jr pd_loop                      ;

pd_vol:                 rlca                            ;
                        rlca                            ;
                        rlca                            ;
                        rlca                            ;
                        ld (ix+chp_volume-12),a         ;
                        jr pd_lp2                       ;

pd_eoff:                ld (ix+chp_env_en-12),a         ;
                        ld (ix+chp_psinor-12),a         ;
                        jr pd_lp2                       ;

pd_sore:                dec a                           ;
                        jr nz,pd_env                    ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld (ix+chp_nntskp-12),a         ;
                        jr pd_lp2                       ;

pd_env:                 call setenv                     ;
                        jr pd_lp2                       ;

pd_orn:                 call setorn                     ;
                        jr pd_loop                      ;

pd_esam:                ld (ix+chp_env_en-12),a         ;
                        ld (ix+chp_psinor-12),a         ;
                        call nz,setenv                  ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        jr pd_sam_                      ;

ptdecod:                ld a,(ix+chp_note-12)           ;
                        ld (prnote+1),a                 ;
                        ld l,(ix+chp_crtnsl-12)         ;
                        ld h,(ix+chp_crtnsl+1-12)       ;
                        ld (prslide),hl                 ;

pd_loop:                ld de,0x2010                    ;
pd_lp2:                 ld a,(bc)                       ;
                        inc bc                          ;
                        add a,e                         ;
                        jr c,pd_orsm                    ;
                        add a,d                         ;
                        jr z,pd_fin                     ;
                        jr c,pd_sam                     ;
                        add a,e                         ;
                        jr z,pd_rel                     ;
                        jr c,pd_vol                     ;
                        add a,e                         ;
                        jr z,pd_eoff                    ;
                        jr c,pd_sore                    ;
                        add a,96                        ;
                        jr c,pd_note                    ;
                        add a,e                         ;
                        jr c,pd_orn                     ;
                        add a,d                         ;
                        jr c,pd_nois                    ;
                        add a,e                         ;
                        jr c,pd_esam                    ;
                        add a,a                         ;
                        ld e,a                          ;
                        ld hl,spccoms-0x20e0            ; +#ff20-#2000
                        add hl,de                       ;
                        ld e,(hl)                       ;
                        inc hl                          ;
                        ld d,(hl)                       ;
                        push de                         ;
                        jr pd_loop                      ;

pd_nois:                ld (ns_base),a                  ;
                        jr pd_lp2                       ;

pd_rel:                 res 0,(ix+chp_flags-12)         ;
                        jr pd_res                       ;

pd_note:                ld (ix+chp_note-12),a           ;
                        set 0,(ix+chp_flags-12)         ;
                        xor a                           ;

pd_res:                 ld (pdsp_),sp                   ;
                        ld sp,ix                        ;
                        ld h,a                          ;
                        ld l,a                          ;
                        push hl                         ;
                        push hl                         ;
                        push hl                         ;
                        push hl                         ;
                        push hl                         ;
                        push hl                         ;
                        ld sp,[pdsp_]0x3131             ;

pd_fin:                 ld a,(ix+chp_nntskp-12)         ;
                        ld (ix+chp_ntskcn-12),a         ;
                        ret                             ;

c_portm:                res 2,(ix+chp_flags-12)         ;
                        ld a,(bc)                       ;
                        inc bc                          ;
; skip precalculated tone delta (because
; cannot be right after pt3 compilation)
                        inc bc                          ;
                        inc bc                          ;
                        ld (ix+chp_tnsldl-12),a         ;
                        ld (ix+chp_tslcnt-12),a         ;
                        ld de,nt_                       ;
                        ld a,(ix+chp_note-12)           ;
                        ld (ix+chp_sltont-12),a         ;
                        add a,a                         ;
                        ld l,a                          ;
                        ld h,0                          ;
                        add hl,de                       ;
                        ld a,(hl)                       ;
                        inc hl                          ;
                        ld h,(hl)                       ;
                        ld l,a                          ;
                        push hl                         ;
prnote:                 ld a,0x3e                       ;
                        ld (ix+chp_note-12),a           ;
                        add a,a                         ;
                        ld l,a                          ;
                        ld h,0                          ;
                        add hl,de                       ;
                        ld e,(hl)                       ;
                        inc hl                          ;
                        ld d,(hl)                       ;
                        pop hl                          ;
                        sbc hl,de                       ;
                        ld (ix+chp_tndelt-12),l         ;
                        ld (ix+chp_tndelt+1-12),h       ;
                        ld e,(ix+chp_crtnsl-12)         ;
                        ld d,(ix+chp_crtnsl+1-12)       ;
                        ld a,[version]0x3e              ;
                        cp 6                            ;
                        jr c,oldprtm                    ; old 3xxx for pt v3.5-
                        ld de,[prslide]0x1111           ;
                        ld (ix+chp_crtnsl-12),e         ;
                        ld (ix+chp_crtnsl+1-12),d       ;
oldprtm:                ld a,(bc)                       ; signed tone step
                        inc bc                          ;
                        ex af,af'                       ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        and a                           ;
                        jr z,nosig                      ;
                        ex de,hl                        ;
nosig:                  sbc hl,de                       ;
                        jp p,set_stp                    ;
                        cpl                             ;
                        ex af,af'                       ;
                        neg                             ;
                        ex af,af'                       ;
set_stp:                ld (ix+chp_tslstp+1-12),a       ;
                        ex af,af'                       ;
                        ld (ix+chp_tslstp-12),a         ;
                        ld (ix+chp_conoff-12),0         ;
                        ret                             ;

c_gliss:                set 2,(ix+chp_flags-12)         ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld (ix+chp_tnsldl-12),a         ;
                        and a                           ;
                        jr nz,gl36                      ;
                        ld a,(version)                  ; alco pt3.7+
                        cp 7                            ;
                        sbc a,a                         ;
                        inc a                           ;
gl36:                   ld (ix+chp_tslcnt-12),a         ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ex af,af'                       ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        jr set_stp                      ;

c_smpos:                ld a,(bc)                       ;
                        inc bc                          ;
                        ld (ix+chp_psinsm-12),a         ;
                        ret                             ;

c_orpos:                ld a,(bc)                       ;
                        inc bc                          ;
                        ld (ix+chp_psinor-12),a         ;
                        ret                             ;

c_vibrt:                ld a,(bc)                       ;
                        inc bc                          ;
                        ld (ix+chp_onoffd-12),a         ;
                        ld (ix+chp_conoff-12),a         ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld (ix+chp_offond-12),a         ;
                        xor a                           ;
                        ld (ix+chp_tslcnt-12),a         ;
                        ld (ix+chp_crtnsl-12),a         ;
                        ld (ix+chp_crtnsl+1-12),a       ;
                        ret                             ;

c_engls:                ld a,(bc)                       ;
                        inc bc                          ;
                        ld (env_del),a                  ;
                        ld (curedel),a                  ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld l,a                          ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld h,a                          ;
                        ld (esldadd),hl                 ;
                        ret                             ;

c_delay:                ld a,(bc)                       ;
                        inc bc                          ;
                        ld (delay),a                    ;
                        ret                             ;

setenv:                 ld (ix+chp_env_en-12),e         ;
                        ld (ayregs+envtp),a             ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld h,a                          ;
                        ld a,(bc)                       ;
                        inc bc                          ;
                        ld l,a                          ;
                        ld (envbase),hl                 ;
                        xor a                           ;
                        ld (ix+chp_psinor-12),a         ;
                        ld (curedel),a                  ;
                        ld h,a                          ;
                        ld l,a                          ;
                        ld (curesld),hl                 ;
c_nop:                  ret                             ;

setorn:                 add a,a                         ;
                        ld e,a                          ;
                        ld d,0                          ;
                        ld (ix+chp_psinor-12),d         ;
                        ld hl,[ornptrs]0x2121           ;
                        add hl,de                       ;
                        ld e,(hl)                       ;
                        inc hl                          ;
                        ld d,(hl)                       ;
                        ld hl,[mdaddr2]0x2121           ;
                        add hl,de                       ;
                        ld (ix+chp_ornptr-12),l         ;
                        ld (ix+chp_ornptr+1-12),h       ;
                        ret                             ;

; all 16 addresses to protect from broken pt3 modules
spccoms:                dw c_nop                        ;
                        dw c_gliss                      ;
                        dw c_portm                      ;
                        dw c_smpos                      ;
                        dw c_orpos                      ;
                        dw c_vibrt                      ;
                        dw c_nop                        ;
                        dw c_nop                        ;
                        dw c_engls                      ;
                        dw c_delay                      ;
                        dw c_nop                        ;
                        dw c_nop                        ;
                        dw c_nop                        ;
                        dw c_nop                        ;
                        dw c_nop                        ;
                        dw c_nop                        ;

chregs:                 xor a                           ;
                        ld (ampl),a                     ;
                        bit 0,(ix+chp_flags)            ;
                        push hl                         ;
                        jp z,ch_exit                    ;
                        ld (csp_),sp                    ;
                        ld l,(ix+chp_ornptr)            ;
                        ld h,(ix+chp_ornptr+1)          ;
                        ld sp,hl                        ;
                        pop de                          ;
                        ld h,a                          ;
                        ld a,(ix+chp_psinor)            ;
                        ld l,a                          ;
                        add hl,sp                       ;
                        inc a                           ;
                        cp d                            ;
                        jr c,ch_orps                    ;
                        ld a,e                          ;
ch_orps:                ld (ix+chp_psinor),a            ;
                        ld a,(ix+chp_note)              ;
                        add a,(hl)                      ;
                        jp p,ch_ntp                     ;
                        xor a                           ;
ch_ntp:                 cp 96                           ;
                        jr c,ch_nok                     ;
                        ld a,95                         ;
ch_nok:                 add a,a                         ;
                        ex af,af'                       ;
                        ld l,(ix+chp_samptr)            ;
                        ld h,(ix+chp_samptr+1)          ;
                        ld sp,hl                        ;
                        pop de                          ;
                        ld h,0                          ;
                        ld a,(ix+chp_psinsm)            ;
                        ld b,a                          ;
                        add a,a                         ;
                        add a,a                         ;
                        ld l,a                          ;
                        add hl,sp                       ;
                        ld sp,hl                        ;
                        ld a,b                          ;
                        inc a                           ;
                        cp d                            ;
                        jr c,ch_smps                    ;
                        ld a,e                          ;
ch_smps:                ld (ix+chp_psinsm),a            ;
                        pop bc                          ;
                        pop hl                          ;
                        ld e,(ix+chp_tnacc)             ;
                        ld d,(ix+chp_tnacc+1)           ;
                        add hl,de                       ;
                        bit 6,b                         ;
                        jr z,ch_noac                    ;
                        ld (ix+chp_tnacc),l             ;
                        ld (ix+chp_tnacc+1),h           ;
ch_noac:                ex de,hl                        ;
                        ex af,af'                       ;
                        ld l,a                          ;
                        ld h,0                          ;
                        ld sp,nt_                       ;
                        add hl,sp                       ;
                        ld sp,hl                        ;
                        pop hl                          ;
                        add hl,de                       ;
                        ld e,(ix+chp_crtnsl)            ;
                        ld d,(ix+chp_crtnsl+1)          ;
                        add hl,de                       ;
                        ld sp,[csp_]0x3131              ;
                        ex (sp),hl                      ;
                        xor a                           ;
                        or (ix+chp_tslcnt)              ;
                        jr z,ch_amp                     ;
                        dec (ix+chp_tslcnt)             ;
                        jr nz,ch_amp                    ;
                        ld a,(ix+chp_tnsldl)            ;
                        ld (ix+chp_tslcnt),a            ;
                        ld l,(ix+chp_tslstp)            ;
                        ld h,(ix+chp_tslstp+1)          ;
                        ld a,h                          ;
                        add hl,de                       ;
                        ld (ix+chp_crtnsl),l            ;
                        ld (ix+chp_crtnsl+1),h          ;
                        bit 2,(ix+chp_flags)            ;
                        jr nz,ch_amp                    ;
                        ld e,(ix+chp_tndelt)            ;
                        ld d,(ix+chp_tndelt+1)          ;
                        and a                           ;
                        jr z,ch_stpp                    ;
                        ex de,hl                        ;
ch_stpp:                sbc hl,de                       ;
                        jp m,ch_amp                     ;
                        ld a,(ix+chp_sltont)            ;
                        ld (ix+chp_note),a              ;
                        xor a                           ;
                        ld (ix+chp_tslcnt),a            ;
                        ld (ix+chp_crtnsl),a            ;
                        ld (ix+chp_crtnsl+1),a          ;
ch_amp:                 ld a,(ix+chp_cramsl)            ;
                        bit 7,c                         ;
                        jr z,ch_noam                    ;
                        bit 6,c                         ;
                        jr z,ch_amin                    ;
                        cp 15                           ;
                        jr z,ch_noam                    ;
                        inc a                           ;
                        jr ch_svam                      ;
ch_amin:                cp -15                          ;
                        jr z,ch_noam                    ;
                        dec a                           ;
ch_svam:                ld (ix+chp_cramsl),a            ;
ch_noam:                ld l,a                          ;
                        ld a,b                          ;
                        and 15                          ;
                        add a,l                         ;
                        jp p,ch_apos                    ;
                        xor a                           ;
ch_apos:                cp 16                           ;
                        jr c,ch_vol                     ;
                        ld a,15                         ;
ch_vol:                 or (ix+chp_volume)              ;
                        ld l,a                          ;
                        ld h,0                          ;
                        ld de,vt_                       ;
                        add hl,de                       ;
                        ld a,(hl)                       ;
ch_env:                 bit 0,c                         ;
                        jr nz,ch_noen                   ;
                        or (ix+chp_env_en)              ;
ch_noen:                ld (ampl),a                     ;
                        bit 7,b                         ;
                        ld a,c                          ;
                        jr z,no_ensl                    ;
                        rla                             ;
                        rla                             ;
                        sra a                           ;
                        sra a                           ;
                        sra a                           ;
                        add a,(ix+chp_crensl)           ; see comment below
                        bit 5,b                         ;
                        jr z,no_enac                    ;
                        ld (ix+chp_crensl),a            ;
no_enac:                ld hl,addtoen                   ;
                        add a,(hl)                      ; bug in pt3 - need word here.
                        ; fix it in next version?
                        ld (hl),a                       ;
                        jr ch_mix                       ;
no_ensl:                rra                             ;
                        add a,(ix+chp_crnssl)           ;
                        ld (addtons),a                  ;
                        bit 5,b                         ;
                        jr z,ch_mix                     ;
                        ld (ix+chp_crnssl),a            ;
ch_mix:                 ld a,b                          ;
                        rra                             ;
                        and 0x48                        ;
ch_exit:                ld hl,ayregs+mixer              ;
                        or (hl)                         ;
                        rrca                            ;
                        ld (hl),a                       ;
                        pop hl                          ;
                        xor a                           ;
                        or (ix+chp_conoff)              ;
                        ret z                           ;
                        dec (ix+chp_conoff)             ;
                        ret nz                          ;
                        xor (ix+chp_flags)              ;
                        ld (ix+chp_flags),a             ;
                        rra                             ;
                        ld a,(ix+chp_onoffd)            ;
                        jr c,ch_ondl                    ;
                        ld a,(ix+chp_offond)            ;
ch_ondl:                ld (ix+chp_conoff),a            ;
                        ret                             ;

play:                   xor a                           ;
                        ld (addtoen),a                  ;
                        ld (ayregs+mixer),a             ;
                        dec a                           ;
                        ld (ayregs+envtp),a             ;
                        ld hl,delycnt                   ;
                        dec (hl)                        ;
                        jr nz,pl2                       ;
                        ld hl,chana+chp_ntskcn          ;
                        dec (hl)                        ;
                        jr nz,pl1b                      ;
                        ld bc,[adinpta]0x0101           ;
                        ld a,(bc)                       ;
                        and a                           ;
                        jr nz,pl1a                      ;
                        ld d,a                          ;
                        ld (ns_base),a                  ;
                        ld hl,(crpsptr)                 ;
                        inc hl                          ;
                        ld a,(hl)                       ;
                        inc a                           ;
                        jr nz,plnlp                     ;
                        call checklp                    ;
                        ld hl,[lposptr]0x2121           ;
                        ld a,(hl)                       ;
                        inc a                           ;
plnlp                   ld (crpsptr),hl                 ;
                        dec a                           ;
                        add a,a                         ;
                        ld e,a                          ;
                        rl d                            ;
                        ld hl,[patsptr]0x2121           ;
                        add hl,de                       ;
                        ld de,(modaddr)                 ;
                        ld (psp_),sp                    ;
                        ld sp,hl                        ;
                        pop hl                          ;
                        add hl,de                       ;
                        ld b,h                          ;
                        ld c,l                          ;
                        pop hl                          ;
                        add hl,de                       ;
                        ld (adinptb),hl                 ;
                        pop hl                          ;
                        add hl,de                       ;
                        ld (adinptc),hl                 ;
                        ld sp,[psp_]0x3131              ;
pl1a:                   ld ix,chana+12                  ;
                        call ptdecod                    ;
                        ld (adinpta),bc                 ;

pl1b:                   ld hl,chanb+chp_ntskcn          ;
                        dec (hl)                        ;
                        jr nz,pl1c                      ;
                        ld ix,chanb+12                  ;
                        ld bc,[adinptb]0x0101           ;
                        call ptdecod                    ;
                        ld (adinptb),bc                 ;

pl1c:                   ld hl,chanc+chp_ntskcn          ;
                        dec (hl)                        ;
                        jr nz,pl1d                      ;
                        ld ix,chanc+12                  ;
                        ld bc,[adinptc]0x0101           ;
                        call ptdecod                    ;
                        ld (adinptc),bc                 ;

delay:                  equ $+1                         ;
pl1d:                   ld a,0x3e                       ;
                        ld (delycnt),a                  ;

pl2:                    ld ix,chana                     ;
                        ld hl,(ayregs+tona)             ;
                        call chregs                     ;
                        ld (ayregs+tona),hl             ;
                        ld a,(ampl)                     ;
                        ld (ayregs+ampla),a             ;
                        ld ix,chanb                     ;
                        ld hl,(ayregs+tonb)             ;
                        call chregs                     ;
                        ld (ayregs+tonb),hl             ;
                        ld a,(ampl)                     ;
                        ld (ayregs+amplb),a             ;
                        ld ix,chanc                     ;
                        ld hl,(ayregs+tonc)             ;
                        call chregs                     ;
;       ld a,(ampl) ;ampl = ayregs+amplc
;       ld (ayregs+amplc),a
                        ld (ayregs+tonc),hl             ;

                        ld hl,(ns_base_addtons)         ;
                        ld a,h                          ;
                        add a,l                         ;
                        ld (ayregs+noise),a             ;

addtoen:                equ $+1                         ;
                        ld a,0x3e                       ;
                        ld e,a                          ;
                        add a,a                         ;
                        sbc a,a                         ;
                        ld d,a                          ;
                        ld hl,(envbase)                 ;
                        add hl,de                       ;
                        ld de,(curesld)                 ;
                        add hl,de                       ;
                        ld (ayregs+env),hl              ;

                        xor a                           ;
                        ld hl,curedel                   ;
                        or (hl)                         ;
                        jr z,rout_a0                    ;
                        dec (hl)                        ;
                        jr nz,rout                      ;
env_del:                equ $+1                         ;
                        ld a,0x3e                       ;
                        ld (hl),a                       ;
esldadd:                equ $+1                         ;
                        ld hl,0x2121                    ;
                        add hl,de                       ;
                        ld (curesld),hl                 ;

rout:                   xor a                           ;
rout_a0:                ld hl,setup                     ;
                        bit 1,(hl)                      ;
                        jr nz,rstk                      ;
                        ld hl,ayregs                    ;
MANUAL_SOUND:
                        ld de,65471                     ;
                        ld bc,65533                     ;

lout:                   out (c),a                       ;
                        ld b,e                          ;
                        outi                            ;
                        ld b,d                          ;
                        inc a                           ;
                        cp 13                           ;
                        jr nz,lout                      ;
                        out (c),a                       ;
                        ld a,(hl)                       ;
                        and a                           ;
                        ret m                           ;
                        ld b,e                          ;
                        out (c),a                       ;
                        ret                             ;
rstk:
                        res 1,(hl)                      ;
                        ld (rstksp_+1),sp               ;
                        ld sp,ayregs                    ;
                        pop bc                          ;
                        pop de                          ;
                        pop hl                          ;
                        pop af                          ;
                        exx                             ;
                        pop bc                          ;
                        pop de                          ;
                        pop hl                          ;
rstksp_:
                        ld sp,0                         ;
                        ex (sp),hl                      ;
                        push de                         ;
                        push bc                         ;
                        exx                             ;
                        push af                         ;
                        push hl                         ;
                        push de                         ;
                        push bc                         ;
        ; ld hl,0x2758
                        exx                             ;
                        jp (hl)                         ;



nt_data:                db (t_new_0-t1_)*2              ;
                        db tcnew_0-t_                   ;
                        db (t_old_0-t1_)*2+1            ;
                        db tcold_0-t_                   ;
                        db (t_new_1-t1_)*2+1            ;
                        db tcnew_1-t_                   ;
                        db (t_old_1-t1_)*2+1            ;
                        db tcold_1-t_                   ;
                        db (t_new_2-t1_)*2              ;
                        db tcnew_2-t_                   ;
                        db (t_old_2-t1_)*2              ;
                        db tcold_2-t_                   ;
                        db (t_new_3-t1_)*2              ;
                        db tcnew_3-t_                   ;
                        db (t_old_3-t1_)*2              ;
                        db tcold_3-t_                   ;

t_:

tcold_0:                db 0x00+1,0x04+1,0x08+1,0x0a+1,0x0c+1,0x0e+1,0x12+1,0x14+1;
                        db 0x18+1,0x24+1,0x3c+1,0       ;
tcold_1:                db 0x5c+1,0                     ;
tcold_2:                db 0x30+1,0x36+1,0x4c+1,0x52+1,0x5e+1,0x70+1,0x82,0x8c,0x9c;
                        db 0x9e,0xa0,0xa6,0xa8,0xaa,0xac,0xae,0xae,0;
tcnew_3:                db 0x56+1                       ;
tcold_3:                db 0x1e+1,0x22+1,0x24+1,0x28+1,0x2c+1,0x2e+1,0x32+1,0xbe+1,0;
tcnew_0:                db 0x1c+1,0x20+1,0x22+1,0x26+1,0x2a+1,0x2c+1,0x30+1,0x54+1;
                        db 0xbc+1,0xbe+1,0              ;
tcnew_1:                equ tcold_1                     ;
tcnew_2:                db 0x1a+1,0x20+1,0x24+1,0x28+1,0x2a+1,0x3a+1,0x4c+1,0x5e+1;
                        db 0xba+1,0xbc+1,0xbe+1,0       ;

emptysamorn:            equ $-1                         ;
                        db 1,0,0x90                     ; delete #90 if you don't need default sample

; first 12 values of tone tables (packed)

t_pack:
                        db 0x06ec*2/256,0xd8            ; #06ec*2
                        db 0x0755-0x06ec                ;
                        db 0x07c5-0x0755                ;
                        db 0x083b-0x07c5                ;
                        db 0x08b8-0x083b                ;
                        db 0x093d-0x08b8                ;
                        db 0x09ca-0x093d                ;
                        db 0x0a5f-0x09ca                ;
                        db 0x0afc-0x0a5f                ;
                        db 0x0ba4-0x0afc                ;
                        db 0x0c55-0x0ba4                ;
                        db 0x0d10-0x0c55                ;
                        db 0x066d*2/256,0xda            ; #066d*2
                        db 0x06cf-0x066d                ;
                        db 0x0737-0x06cf                ;
                        db 0x07a4-0x0737                ;
                        db 0x0819-0x07a4                ;
                        db 0x0894-0x0819                ;
                        db 0x0917-0x0894                ;
                        db 0x09a1-0x0917                ;
                        db 0x0a33-0x09a1                ;
                        db 0x0acf-0x0a33                ;
                        db 0x0b73-0x0acf                ;
                        db 0x0c22-0x0b73                ;
                        db 0x0cda-0x0c22                ;
                        db 0x0704*2/256,0x08            ; #0704*2
                        db 0x076e-0x0704                ;
                        db 0x07e0-0x076e                ;
                        db 0x0858-0x07e0                ;
                        db 0x08d6-0x0858                ;
                        db 0x095c-0x08d6                ;
                        db 0x09ec-0x095c                ;
                        db 0x0a82-0x09ec                ;
                        db 0x0b22-0x0a82                ;
                        db 0x0bcc-0x0b22                ;
                        db 0x0c80-0x0bcc                ;
                        db 0x0d3e-0x0c80                ;
                        db 0x07e0*2/256,0xc0            ; #07e0*2
                        db 0x0858-0x07e0                ;
                        db 0x08e0-0x0858                ;
                        db 0x0960-0x08e0                ;
                        db 0x09f0-0x0960                ;
                        db 0x0a88-0x09f0                ;
                        db 0x0b28-0x0a88                ;
                        db 0x0bd8-0x0b28                ;
                        db 0x0c80-0x0bd8                ;
                        db 0x0d60-0x0c80                ;
                        db 0x0e10-0x0d60                ;
                        db 0x0ef8-0x0e10                ;

; vars from here can be stripped
; you can move vars to any other address

vars:

; channelsvars
        ; struct chp
; reset group
chp_psinor:             equ 0                           ;
chp_psinsm:             equ 1                           ;
chp_cramsl:             equ 2                           ;
chp_crnssl:             equ 3                           ;
chp_crensl:             equ 4                           ;
chp_tslcnt:             equ 5                           ;
chp_crtnsl:             equ 6                           ; dw
chp_tnacc:              equ 8                           ; dw
chp_conoff:             equ 10                          ;
; reset group

chp_onoffd:             equ 11                          ;

; ix for ptdecod here (+12)
chp_offond:             equ 12                          ;
chp_ornptr:             equ 13                          ; dw
chp_samptr:             equ 15                          ; dw
chp_nntskp:             equ 17                          ;
chp_note:               equ 18                          ;
chp_sltont:             equ 19                          ;
chp_env_en:             equ 20                          ;
chp_flags:              equ 21                          ;
                        ; enabled - 0,simplegliss - 2
chp_tnsldl:             equ 22                          ;
chp_tslstp:             equ 23                          ; dw
chp_tndelt:             equ 25                          ; dw
chp_ntskcn:             equ 27                          ;
chp_volume:             equ 28                          ;

chp:                    equ chp_volume+1                ;

chana:                  ds chp                          ;
chanb:                  ds chp                          ;
chanc:                  ds chp                          ;

; globalvars
delycnt:                db 0                            ;
curesld:                dw 0                            ;
curedel:                db 0                            ;
ns_base_addtons:
ns_base:                db 0                            ;
addtons:                db 0                            ;

ayregs:

vt_:                    ds 256                          ; createdvolumetableaddress

envbase:                equ vt_+14                      ;

t1_:                    equ vt_+16                      ; tone tables data depacked here

t_old_1:                equ t1_                         ;
t_old_2:                equ t_old_1+24                  ;
t_old_3:                equ t_old_2+24                  ;
t_old_0:                equ t_old_3+2                   ;
t_new_0:                equ t_old_0                     ;
t_new_1:                equ t_old_1                     ;
t_new_2:                equ t_new_0+24                  ;
t_new_3:                equ t_old_3                     ;

nt_:                    ds 192                          ; creatednotetableaddress

; local var
ampl:                   equ ayregs+amplc                ;

var0end:                equ vt_+16                      ; init zeroes from vars to var0end-1

varsend:                equ $                           ;

; mdladdr:                equ $                           ;

; release 0 steps:
; 11.sep.2004 - note tables creator
; 12.sep.2004 - volume tables creator; init subroutine
; 13.sep.2004 - play counters, position counters
; 14.sep.2004 - patterns decoder subroutine
; 15.sep.2004 - resting (no code)
; 16.sep.2004 - chregs subroutine; global debugging; 1st stable
; version was born
; 17.sep.2004 - debugging and optimization. first release!
; release 1 steps:
; 20.sep.2004 - local vars moved to code (selfmodified code
; smaller and faster)
; 22.sep.2004 - added mute sound entry at start+8; position
; pointer moved to start+11; added setup and status byte at
; start+10 noloop mode and loop passed flags added
; release 2 steps:
; 28.sep.2004 - optimization: code around chregs's volume and
; vibrato faster now; zeroing pd_res through stack; ton and ampl
; moved from channel vars to global ones; first position selector
; removed from init; optimization for packers(ivan roshin method)
; release 3 steps:
; 2.oct.2004 - optimization in init and pd_loop (thanks to ivan
; roshin)
; 4.oct.2004 - load delay from (hl) in init (2 bytes shorter)
; 5.oct.2004 - optimization in pd_loop (->pd_lp2)
; 7.oct.2004 - swaping some commands for better packing
; release 4 steps:
; 9.oct.2004 - optimization around ld hl,spccoms (thanks to ivan
; roshin); in ptdecod swapped bc and de to optimize c_portm;
; removed sam and orn len and loop channel vars; chregs totally
; optimized
; release 5 steps:
; 11.oct.2004 - pd_orsm and c_portm optimized; ivan roshin's
; volume tables creator algorithm (51 bytes shorter than mine)
; 12.oct.2004 - ivan roshin's note tables creator algorithm (74
; bytes shorter than mine)
; release 6 steps:
; 14.oct.2004 - loop and next position calculations moved to init
; 15.oct.2004 - adinpt moved to code
; 19.oct.2004 - env_del moved to code
; 20.oct.2004 - version push and pop (1 byte shorter, thanks to
; ivan roshin)
; 22.oct.2004 - env_en moved from flags' bit to byte (shorter and
; faster code)
; 25.oct.2004 - setenv optimized
; 29.oct.2004 - optimized around addtoen (sbc a,a, thanks to ivan
; roshin)
; 3.nov.2004 - note tables data was compressed; with depacker it
; is 9 bytes shorter than uncompressed (thanks to ivan roshin)
; 4.nov.2004 - default sample and ornament both are fixed now
; and placed into code block (6 bytes shorter)
; 7.nov.2004 - ld a,(ns_base):ld l,a changed to ld hl,(ns_base)
; (thanks to dima bystrov)
; 9.nov.2004 - ns_base and addtons are merged to ns_base_addtons;
; ld a,255 changed to dec a (at start of play); added rout_a0
; 12.nov.2004 - ntskcn&volume are merged (8 bytes smaller init);
; ld bc,t1_ changed to push de...pop bc in note table creator
; 19.dec.2004 - nt_data reorganized (6 bytes shorter, thanks to
; ivan roshin); c_portm and c_gliss are merged via set_stp (48
; tacts slower, but 8 bytes smaller, thanks to ivan roshin)
; release 7 steps:
; 29.apr.2007 - sjasm adaptation; new 1.xx and 2.xx
; interpretation for pt 3.7+.
; 7.sep.2017 - modified by hikaru/intense: generalized asm syntax
; for improved compatibility, added stack output (see setup byte)

; tests in immation tester v1.0 by andy man/pos (thanks to
; himik's zxz for help):
; module name/author     min tacts       max tacts       average
; spleen/nik-o           1720            9256            5500
; chuta/miguel           1720            9496            5500
; zhara/macros           4536            8744            5500

; size:
; code block #676 bytes
; variables #21d bytes (can be stripped)
; size in ram #676+#21d=#893 (2195) bytes

; notes:
; pro tracker 3.4r can not be detected by header, so pt3.4r tone
; tables really used only for modules of 3.3 and older versions.
; end
;       savebin "vortex.bin",start,end-start



MUSIC_DATA_4:

                        DEFM "ProTracker 3.7 compilation of cygnostitle                      by ";
                        DEFM "davidsaphier/em00k2018           ";


                        DEFB 4,6,22,9,224,0,0,0         ;
                        DEFB 137,9,187,9,217,9,0,0      ;
                        DEFB 27,10,73,10,183,10,197,10  ;
                        DEFB 247,10,25,11,0,0,0,0       ;
                        DEFB 0,0,0,0,0,0,0,0            ;
                        DEFB 0,0,0,0,0,0,0,0            ;
                        DEFB 0,0,0,0,0,0,0,0            ;
                        DEFB 0,0,0,0,0,0,0,0            ;
                        DEFB 0,0,0,0,0,0,179,11         ;
                        DEFB 182,11,187,11,192,11,200,11;
                        DEFB 205,11,0,0,0,0,0,0         ;
                        DEFB 0,0,0,0,0,0,0,0            ;
                        DEFB 0,0,0,0,211,11,18,21       ;
                        DEFB 21,24,24,30,27,0,3,6       ;
                        DEFB 6,9,9,12,12,9,9,15         ;
                        DEFB 15,18,21,27,255,66,2,158   ;
                        DEFB 2,10,3,125,3,228,3,81      ;
                        DEFB 4,196,4,110,5,10,3,0       ;
                        DEFB 6,170,6,60,7,141,7,170     ;
                        DEFB 6,57,8,138,8,170,6,52      ;
                        DEFB 9,34,1,48,1,105,1,142      ;
                        DEFB 1,146,1,150,1,196,1,227    ;
                        DEFB 1,237,1,1,2,25,2,41        ;
                        DEFB 2,196,1,244,1,237,1,30     ;
                        DEFB 0,8,18,64,207,8,177,64     ;
                        DEFB 130,3,4,0,0,255,4,207      ;
                        DEFB 63,177,1,116,32,177,3,208  ;
                        DEFB 177,2,116,116,177,8,116,116;
                        DEFB 116,177,4,116,177,2,116,116;
                        DEFB 177,8,116,214,69,203,177,1 ;
                        DEFB 123,121,177,3,118,202,177,1;
                        DEFB 123,121,177,3,118,195,177,1;
                        DEFB 123,121,177,4,118,0,209,204;
                        DEFB 177,48,82,211,207,177,2,116;
                        DEFB 214,69,201,177,1,123,121,177;
                        DEFB 3,118,197,177,1,123,121,177;
                        DEFB 3,118,194,177,1,123,121,177;
                        DEFB 2,118,0,177,16,192,0,177   ;
                        DEFB 16,208,0,244,2,206,177,1   ;
                        DEFB 94,192,202,101,206,94,215,65;
                        DEFB 207,192,209,68,206,94,177,2;
                        DEFB 82,177,1,94,215,65,207,192 ;
                        DEFB 209,68,206,99,94,215,65,207;
                        DEFB 192,209,68,206,94,177,2,82 ;
                        DEFB 0,244,2,206,177,1,94,192   ;
                        DEFB 202,101,206,177,2,94,177,1 ;
                        DEFB 94,177,2,82,177,1,94,192   ;
                        DEFB 99,94,192,94,177,2,82,0    ;
                        DEFB 240,4,207,177,4,116,116,116;
                        DEFB 116,0,177,2,192,177,14,192 ;
                        DEFB 0,240,4,207,177,4,116,211  ;
                        DEFB 116,210,116,211,116,0,244,2;
                        DEFB 206,177,1,94,192,202,101,206;
                        DEFB 177,2,94,177,1,94,177,2    ;
                        DEFB 82,177,4,94,89,0,240,4     ;
                        DEFB 207,177,6,116,177,3,116,104;
                        DEFB 177,2,116,211,104,0,211,177;
                        DEFB 4,128,202,177,6,128,214,68 ;
                        DEFB 205,177,1,125,196,208,205,123;
                        DEFB 196,208,205,121,196,208,0,209;
                        DEFB 79,206,177,1,94,192,192,94 ;
                        DEFB 192,94,177,2,82,177,1,94   ;
                        DEFB 192,192,94,192,94,177,2,192;
                        DEFB 177,1,96,192,192,96,192,96 ;
                        DEFB 177,2,84,177,1,96,192,192  ;
                        DEFB 96,192,96,177,2,192,177,1  ;
                        DEFB 97,192,192,97,192,97,177,2 ;
                        DEFB 85,177,1,97,192,192,97,192 ;
                        DEFB 97,177,2,192,177,1,99,192  ;
                        DEFB 192,99,192,99,177,2,87,177 ;
                        DEFB 1,99,192,192,99,192,97,177 ;
                        DEFB 2,85,0,240,4,207,177,1     ;
                        DEFB 116,213,123,121,118,211,116,213;
                        DEFB 123,121,118,210,116,213,123,121;
                        DEFB 118,211,116,213,123,121,118,210;
                        DEFB 116,213,125,123,120,211,116,213;
                        DEFB 125,123,120,210,116,213,125,123;
                        DEFB 120,211,116,213,125,211,123,213;
                        DEFB 120,210,116,213,127,123,121,211;
                        DEFB 116,213,127,123,121,210,116,213;
                        DEFB 127,123,121,211,116,213,127,123;
                        DEFB 121,210,116,213,128,125,123,211;
                        DEFB 116,213,128,211,125,213,123,210;
                        DEFB 116,211,128,213,125,211,116,116;
                        DEFB 213,128,211,125,213,123,0,214;
                        DEFB 67,205,177,1,118,196,208,205;
                        DEFB 111,125,196,208,205,113,177,4;
                        DEFB 130,177,1,125,196,208,205,123;
                        DEFB 196,208,205,121,196,208,205,120;
                        DEFB 196,208,205,123,125,196,177,2;
                        DEFB 208,205,177,4,130,177,1,125;
                        DEFB 196,208,205,123,196,208,205,120;
                        DEFB 196,208,202,133,132,128,203,133;
                        DEFB 132,128,204,133,132,128,133,205;
                        DEFB 132,128,133,132,128,133,177,2;
                        DEFB 135,196,177,1,208,205,135,196;
                        DEFB 177,2,208,205,177,1,135,196;
                        DEFB 208,205,142,196,208,205,135,202;
                        DEFB 208,205,130,196,208,205,133,196;
                        DEFB 208,0,255,2,206,177,1,94   ;
                        DEFB 192,202,101,206,94,192,94,177;
                        DEFB 2,82,177,1,94,192,202,99   ;
                        DEFB 206,177,2,94,177,1,94,177  ;
                        DEFB 2,82,177,1,96,192,202,103  ;
                        DEFB 206,96,192,96,177,2,84,177 ;
                        DEFB 1,96,192,192,96,192,96,177 ;
                        DEFB 2,192,177,1,97,192,202,104 ;
                        DEFB 206,97,192,97,177,2,85,177 ;
                        DEFB 1,97,192,92,97,192,97,177  ;
                        DEFB 2,192,177,1,99,192,94,99   ;
                        DEFB 192,99,177,2,87,177,1,99   ;
                        DEFB 192,192,99,192,97,177,2,85 ;
                        DEFB 0,240,4,207,177,1,116,213  ;
                        DEFB 123,121,118,211,116,213,123,121;
                        DEFB 118,210,116,213,123,121,118,211;
                        DEFB 116,213,123,121,118,210,116,213;
                        DEFB 125,123,120,211,116,213,125,123;
                        DEFB 120,210,116,213,125,123,120,211;
                        DEFB 116,213,125,211,123,213,120,210;
                        DEFB 116,213,127,123,121,211,116,213;
                        DEFB 127,123,121,210,116,213,127,123;
                        DEFB 121,211,116,213,127,123,121,210;
                        DEFB 116,213,128,125,123,211,116,213;
                        DEFB 128,211,125,213,123,210,116,211;
                        DEFB 128,213,125,211,204,116,116,213;
                        DEFB 128,211,125,213,123,0,214,69;
                        DEFB 205,177,1,118,196,208,205,111;
                        DEFB 125,196,208,205,113,177,4,130;
                        DEFB 177,1,125,196,208,205,123,196;
                        DEFB 208,205,121,196,208,205,120,196;
                        DEFB 208,205,123,125,196,177,2,208;
                        DEFB 205,177,4,130,177,1,125,196;
                        DEFB 208,205,123,196,208,205,120,196;
                        DEFB 208,202,133,132,128,203,133,132;
                        DEFB 128,204,133,132,128,133,205,132;
                        DEFB 128,133,132,128,133,177,2,135;
                        DEFB 196,177,1,208,205,135,196,177;
                        DEFB 2,208,205,177,1,135,196,208;
                        DEFB 205,142,196,208,205,135,202,208;
                        DEFB 205,130,196,208,205,133,196,208;
                        DEFB 0,244,2,206,177,1,94,192   ;
                        DEFB 202,101,206,94,215,65,207,118;
                        DEFB 209,68,206,94,177,2,82,177 ;
                        DEFB 1,94,215,65,207,118,209,68 ;
                        DEFB 206,99,94,215,65,207,118,209;
                        DEFB 68,206,94,177,2,82,177,1   ;
                        DEFB 96,192,202,103,206,96,215,65;
                        DEFB 207,120,209,68,206,96,177,2;
                        DEFB 84,177,1,96,215,65,207,120 ;
                        DEFB 192,209,68,206,96,215,65,207;
                        DEFB 120,209,68,206,96,177,2,192;
                        DEFB 177,1,97,192,202,104,206,97;
                        DEFB 215,66,207,121,209,68,206,97;
                        DEFB 177,2,85,177,1,97,215,66   ;
                        DEFB 207,121,209,68,206,92,97,215;
                        DEFB 66,207,121,209,68,206,97,177;
                        DEFB 2,192,177,1,99,192,94,99   ;
                        DEFB 215,66,207,123,209,68,206,99;
                        DEFB 177,2,87,177,1,99,215,66   ;
                        DEFB 207,123,192,209,68,206,99,215;
                        DEFB 66,207,123,209,68,206,97,177;
                        DEFB 2,85,0,255,4,207,177,1     ;
                        DEFB 116,213,69,123,121,118,211,79;
                        DEFB 116,213,69,123,121,118,210,79;
                        DEFB 116,213,69,123,121,118,211,79;
                        DEFB 116,213,69,123,121,118,210,79;
                        DEFB 116,213,69,125,123,120,211,79;
                        DEFB 116,213,69,125,123,120,210,79;
                        DEFB 116,213,69,125,123,120,211,79;
                        DEFB 116,213,69,125,211,79,123,213;
                        DEFB 69,120,210,79,116,213,69,127;
                        DEFB 123,121,211,79,116,213,69,127;
                        DEFB 123,121,210,79,116,213,69,127;
                        DEFB 123,121,211,79,116,213,69,127;
                        DEFB 123,121,210,79,116,213,69,128;
                        DEFB 125,123,211,79,116,213,69,128;
                        DEFB 211,79,125,213,69,123,210,79;
                        DEFB 116,211,128,213,69,125,211,79;
                        DEFB 204,116,116,213,69,128,211,79;
                        DEFB 125,213,69,123,0,244,2,206 ;
                        DEFB 177,1,92,192,202,80,206,92 ;
                        DEFB 215,66,207,116,209,68,206,92;
                        DEFB 177,2,80,177,1,92,215,66   ;
                        DEFB 207,116,209,68,206,85,92,215;
                        DEFB 66,207,116,209,68,206,92,177;
                        DEFB 2,80,177,1,92,192,202,80   ;
                        DEFB 206,92,215,66,207,116,209,68;
                        DEFB 206,92,177,2,80,177,1,92   ;
                        DEFB 215,66,207,116,85,209,68,206;
                        DEFB 92,215,66,207,116,209,68,206;
                        DEFB 92,177,2,80,177,1,97,192   ;
                        DEFB 202,104,206,97,215,66,207,121;
                        DEFB 209,68,206,97,177,2,85,177 ;
                        DEFB 1,97,215,66,207,121,209,68 ;
                        DEFB 206,92,97,215,66,207,121,209;
                        DEFB 68,206,97,177,2,192,177,1  ;
                        DEFB 99,192,94,99,215,66,207,123;
                        DEFB 209,68,206,99,177,2,87,177 ;
                        DEFB 1,99,215,66,207,123,192,209;
                        DEFB 68,206,99,215,66,207,123,209;
                        DEFB 68,206,97,177,2,85,0,255   ;
                        DEFB 4,207,177,1,116,213,69,108 ;
                        DEFB 111,116,211,79,116,213,69,108;
                        DEFB 111,116,210,79,116,213,69,108;
                        DEFB 113,116,211,79,116,213,69,108;
                        DEFB 113,116,210,79,116,213,69,108;
                        DEFB 113,116,211,79,116,213,69,108;
                        DEFB 113,116,210,79,116,213,69,108;
                        DEFB 113,116,211,79,116,213,69,106;
                        DEFB 211,79,123,213,69,116,210,79;
                        DEFB 116,213,69,109,116,120,211,79;
                        DEFB 116,213,69,109,116,120,210,79;
                        DEFB 116,213,69,109,116,120,211,79;
                        DEFB 116,213,69,116,120,121,210,79;
                        DEFB 116,213,69,123,127,130,211,79;
                        DEFB 116,213,69,123,211,79,125,213;
                        DEFB 69,130,210,79,116,211,128,213;
                        DEFB 69,127,211,79,204,116,116,213;
                        DEFB 69,123,211,79,125,213,69,130;
                        DEFB 0,214,69,206,177,2,116,177 ;
                        DEFB 1,192,202,208,201,177,2,116;
                        DEFB 206,177,1,116,201,116,192,202;
                        DEFB 116,201,177,2,116,206,177,1;
                        DEFB 121,202,116,206,177,4,123,201;
                        DEFB 123,206,177,2,123,192,201,111;
                        DEFB 206,177,1,128,192,177,2,116;
                        DEFB 177,4,125,201,177,2,125,206;
                        DEFB 177,4,121,201,177,6,121,206;
                        DEFB 177,4,123,201,123,195,177,8;
                        DEFB 123,0,244,16,206,177,1,101 ;
                        DEFB 192,202,89,206,101,215,65,194;
                        DEFB 125,216,68,206,101,177,2,89;
                        DEFB 177,1,101,215,65,194,125,216;
                        DEFB 68,206,87,101,215,65,194,125;
                        DEFB 216,68,206,101,177,2,89,177;
                        DEFB 1,97,192,202,104,206,97,215;
                        DEFB 66,207,121,216,68,206,97,177;
                        DEFB 2,85,177,1,97,215,66,207   ;
                        DEFB 121,216,68,206,92,97,215,66;
                        DEFB 207,121,216,68,206,97,177,2;
                        DEFB 192,209,177,1,101,216,192,202;
                        DEFB 89,206,101,215,65,194,125,216;
                        DEFB 68,206,101,177,2,89,177,1  ;
                        DEFB 101,215,65,194,125,216,68,206;
                        DEFB 87,101,215,65,194,125,216,68;
                        DEFB 206,101,177,2,89,177,1,99  ;
                        DEFB 192,94,99,215,66,207,123,216;
                        DEFB 68,206,99,177,2,87,177,1   ;
                        DEFB 99,215,66,207,123,192,216,68;
                        DEFB 206,99,215,66,207,123,216,68;
                        DEFB 206,97,177,2,109,0,177,3   ;
                        DEFB 208,218,67,207,177,2,120,177;
                        DEFB 1,192,177,2,120,120,201,120;
                        DEFB 207,118,116,118,201,116,207,177;
                        DEFB 1,120,192,177,4,120,201,120;
                        DEFB 196,177,2,120,177,3,192,207;
                        DEFB 177,2,120,177,1,192,120,201;
                        DEFB 120,207,177,2,120,201,120,207;
                        DEFB 118,116,123,201,177,1,116,207;
                        DEFB 120,201,177,2,123,207,118,201;
                        DEFB 123,207,120,123,201,120,0,216;
                        DEFB 79,206,177,1,101,192,202,89;
                        DEFB 206,101,215,65,194,125,216,68;
                        DEFB 206,101,177,2,89,177,1,101 ;
                        DEFB 215,65,194,125,216,68,206,87;
                        DEFB 101,215,65,194,125,216,68,206;
                        DEFB 101,177,2,89,177,1,97,192  ;
                        DEFB 202,104,206,97,215,66,207,121;
                        DEFB 216,68,206,97,177,2,85,177 ;
                        DEFB 1,97,215,66,207,121,216,68 ;
                        DEFB 206,92,97,215,66,207,121,216;
                        DEFB 68,206,97,177,2,192,177,1  ;
                        DEFB 101,192,202,89,206,101,215,65;
                        DEFB 194,125,216,68,206,101,177,2;
                        DEFB 89,177,1,101,215,65,194,125;
                        DEFB 216,68,206,87,101,215,65,194;
                        DEFB 125,216,68,206,101,177,2,89;
                        DEFB 177,1,99,192,94,99,215,66  ;
                        DEFB 207,123,216,68,206,99,177,2;
                        DEFB 87,177,1,99,215,66,207,123 ;
                        DEFB 192,216,68,206,99,215,66,207;
                        DEFB 123,216,68,206,97,177,2,109;
                        DEFB 0,177,3,208,218,68,207,177 ;
                        DEFB 1,132,195,208,192,207,177,2;
                        DEFB 132,132,201,132,207,130,128,130;
                        DEFB 201,128,207,177,1,132,192,177;
                        DEFB 4,132,214,204,177,2,116,123;
                        DEFB 120,177,3,192,218,207,177,1;
                        DEFB 132,195,208,192,207,132,201,132;
                        DEFB 207,177,2,132,201,132,207,130;
                        DEFB 128,135,201,177,1,128,207,132;
                        DEFB 201,177,2,135,207,130,201,135;
                        DEFB 207,132,135,201,132,0,11,12;
                        DEFB 62,174,0,0,2,173,0,0       ;
                        DEFB 62,140,0,0,2,171,0,0       ;
                        DEFB 2,138,0,0,62,170,0,0       ;
                        DEFB 2,138,0,0,2,137,0,0        ;
                        DEFB 2,137,0,0,2,137,0,0        ;
                        DEFB 2,136,0,0,2,136,0,0        ;
                        DEFB 6,7,0,14,0,1,0,141         ;
                        DEFB 192,1,0,140,0,2,0,139      ;
                        DEFB 32,2,0,137,160,2,0,133     ;
                        DEFB 192,2,0,128,0,0,15,16      ;
                        DEFB 6,15,250,0,4,14,244,1      ;
                        DEFB 2,13,238,2,0,12,132,3      ;
                        DEFB 0,11,26,4,0,10,226,4       ;
                        DEFB 0,9,120,5,0,24,0,0         ;
                        DEFB 0,23,0,0,0,22,0,0          ;
                        DEFB 0,21,0,0,0,20,0,0          ;
                        DEFB 0,19,0,0,0,18,0,0          ;
                        DEFB 0,17,0,0,0,0,0,0           ;
                        DEFB 8,11,0,11,0,0,0,9          ;
                        DEFB 0,0,0,7,0,0,0,133          ;
                        DEFB 0,0,0,132,0,0,0,131        ;
                        DEFB 0,0,1,144,0,0,1,144        ;
                        DEFB 0,0,1,144,0,0,1,144        ;
                        DEFB 0,0,1,144,0,0,6,27         ;
                        DEFB 1,141,0,0,1,140,0,0        ;
                        DEFB 1,140,0,0,1,140,0,0        ;
                        DEFB 1,140,0,0,1,139,0,0        ;
                        DEFB 1,139,0,0,1,139,0,0        ;
                        DEFB 1,139,5,0,1,139,9,0        ;
                        DEFB 1,138,5,0,1,138,0,0        ;
                        DEFB 1,138,251,255,1,138,247,255;
                        DEFB 1,138,251,255,1,138,0,0    ;
                        DEFB 1,138,0,0,1,138,0,0        ;
                        DEFB 1,138,0,0,1,138,0,0        ;
                        DEFB 1,137,2,0,1,137,2,0        ;
                        DEFB 1,138,254,255,1,138,254,255;
                        DEFB 1,138,0,0,1,139,0,0        ;
                        DEFB 1,139,0,0,1,3,30,137       ;
                        DEFB 0,0,30,137,253,255,30,136  ;
                        DEFB 254,255,11,12,62,174,0,0   ;
                        DEFB 2,174,0,0,62,141,0,0       ;
                        DEFB 2,171,0,0,3,138,0,0        ;
                        DEFB 63,169,0,0,3,135,0,0       ;
                        DEFB 3,134,0,0,3,133,0,0        ;
                        DEFB 3,132,0,0,3,130,0,0        ;
                        DEFB 3,129,0,0,3,8,0,28         ;
                        DEFB 17,1,0,155,2,0,0,154       ;
                        DEFB 3,0,0,152,4,0,0,151        ;
                        DEFB 5,0,0,151,0,0,0,150        ;
                        DEFB 0,0,0,149,0,0,32,38        ;
                        DEFB 0,140,0,0,0,140,0,0        ;
                        DEFB 0,139,0,0,0,139,0,0        ;
                        DEFB 0,138,0,0,0,138,0,0        ;
                        DEFB 0,138,0,0,0,137,0,0        ;
                        DEFB 0,137,0,0,0,137,0,0        ;
                        DEFB 0,136,0,0,0,136,0,0        ;
                        DEFB 0,136,0,0,0,135,0,0        ;
                        DEFB 0,135,0,0,0,135,0,0        ;
                        DEFB 0,134,0,0,0,134,0,0        ;
                        DEFB 0,134,0,0,0,134,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,133,0,0,0,133,0,0        ;
                        DEFB 0,1,0,0,3,0,3,7            ;
                        DEFB 0,3,0,4,7,3,6,0            ;
                        DEFB 0,12,0,0,0,2,3,250         ;
                        DEFB 0,0,3,4,0,12,12,0          ;
                        DEFB 0,1,0                      ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; New ALIEN Torpedo graphics

                        align 256                       ;
ALIEN_TORPEDO_GRAPHICS_4:

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 2                       ;
                        defb 0, 3                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 192, 0                     ;
                        defb 64, 0                      ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 3                       ;
                        defb 0, 7                       ;
                        defb 0, 4                       ;
                        defb 0, 3                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 192, 0                     ;
                        defb 96, 0                      ;
                        defb 32, 0                      ;
                        defb 192, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 7                       ;
                        defb 0, 15                      ;
                        defb 0, 8                       ;
                        defb 0, 15                      ;
                        defb 0, 7                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 96, 0                      ;
                        defb 112, 0                     ;
                        defb 16, 0                      ;
                        defb 112, 0                     ;
                        defb 224, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 15                      ;
                        defb 0, 27                      ;
                        defb 0, 31                      ;
                        defb 0, 16                      ;
                        defb 0, 31                      ;
                        defb 0, 15                      ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 240, 0                     ;
                        defb 120, 0                     ;
                        defb 120, 0                     ;
                        defb 8, 0                       ;
                        defb 120, 0                     ;
                        defb 240, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 7                       ;
                        defb 0, 25                      ;
                        defb 0, 39                      ;
                        defb 0, 63                      ;
                        defb 0, 32                      ;
                        defb 0, 63                      ;
                        defb 0, 31                      ;
                        defb 0, 7                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 224, 0                     ;
                        defb 120, 0                     ;
                        defb 124, 0                     ;
                        defb 124, 0                     ;
                        defb 4, 0                       ;
                        defb 108, 0                     ;
                        defb 120, 0                     ;
                        defb 224, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 7                       ;
                        defb 0, 25                      ;
                        defb 0, 39                      ;
                        defb 0, 127                     ;
                        defb 0, 127                     ;
                        defb 0, 64                      ;
                        defb 0, 127                     ;
                        defb 0, 63                      ;
                        defb 0, 31                      ;
                        defb 0, 7                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 224, 0                     ;
                        defb 120, 0                     ;
                        defb 124, 0                     ;
                        defb 126, 0                     ;
                        defb 126, 0                     ;
                        defb 2, 0                       ;
                        defb 126, 0                     ;
                        defb 116, 0                     ;
                        defb 120, 0                     ;
                        defb 224, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;8
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 15                      ;
                        defb 0, 50                      ;
                        defb 0, 78                      ;
                        defb 0, 254                     ;
                        defb 0, 254                     ;
                        defb 0, 128                     ;
                        defb 0, 254                     ;
                        defb 0, 126                     ;
                        defb 0, 62                      ;
                        defb 0, 15                      ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 240, 0                     ;
                        defb 124, 0                     ;
                        defb 126, 0                     ;
                        defb 127, 0                     ;
                        defb 127, 0                     ;
                        defb 1, 0                       ;
                        defb 127, 0                     ;
                        defb 114, 0                     ;
                        defb 108, 0                     ;
                        defb 240, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 15                      ;
                        defb 0, 58                      ;
                        defb 0, 230                     ;
                        defb 1, 158                     ;
                        defb 3, 254                     ;
                        defb 2, 0                       ;
                        defb 2, 0                       ;
                        defb 3, 254                     ;
                        defb 1, 254                     ;
                        defb 0, 254                     ;
                        defb 0, 62                      ;
                        defb 0, 15                      ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 240, 0                     ;
                        defb 124, 0                     ;
                        defb 127, 0                     ;
                        defb 127, 128                   ;
                        defb 127, 192                   ;
                        defb 0, 64                      ;
                        defb 0, 64                      ;
                        defb 127, 192                   ;
                        defb 121, 128                   ;
                        defb 103, 0                     ;
                        defb 124, 0                     ;
                        defb 240, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 0, 31                      ;
                        defb 0, 114                     ;
                        defb 1, 206                     ;
                        defb 3, 30                      ;
                        defb 7, 254                     ;
                        defb 4, 0                       ;
                        defb 4, 0                       ;
                        defb 7, 254                     ;
                        defb 3, 254                     ;
                        defb 1, 254                     ;
                        defb 0, 126                     ;
                        defb 0, 31                      ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 0, 0                       ;
                        defb 248, 0                     ;
                        defb 126, 0                     ;
                        defb 127, 128                   ;
                        defb 127, 192                   ;
                        defb 127, 224                   ;
                        defb 0, 32                      ;
                        defb 0, 32                      ;
                        defb 127, 224                   ;
                        defb 126, 192                   ;
                        defb 121, 128                   ;
                        defb 102, 0                     ;
                        defb 248, 0                     ;
                        defb 0, 0                       ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        defb 0, 0                       ;
                        defb 0, 7                       ;
                        defb 0, 62                      ;
                        defb 0, 198                     ;
                        defb 3, 30                      ;
                        defb 6, 126                     ;
                        defb 15, 254                    ;
                        defb 8, 0                       ;
                        defb 8, 0                       ;
                        defb 15, 254                    ;
                        defb 7, 254                     ;
                        defb 3, 254                     ;
                        defb 0, 254                     ;
                        defb 0, 62                      ;
                        defb 0, 7                       ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 224, 0                     ;
                        defb 124, 0                     ;
                        defb 127, 0                     ;
                        defb 127, 192                   ;
                        defb 127, 224                   ;
                        defb 127, 240                   ;
                        defb 0, 16                      ;
                        defb 0, 16                      ;
                        defb 127, 240                   ;
                        defb 126, 96                    ;
                        defb 120, 192                   ;
                        defb 99, 0                      ;
                        defb 124, 0                     ;
                        defb 224, 0                     ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;12
                        defb 0, 0                       ;
                        defb 0, 15                      ;
                        defb 0, 122                     ;
                        defb 1, 198                     ;
                        defb 7, 14                      ;
                        defb 12, 126                    ;
                        defb 31, 254                    ;
                        defb 48, 0                      ;
                        defb 48, 0                      ;
                        defb 31, 254                    ;
                        defb 15, 254                    ;
                        defb 7, 254                     ;
                        defb 1, 254                     ;
                        defb 0, 126                     ;
                        defb 0, 15                      ;
                        defb 0, 0                       ;

                        defb 0, 0                       ;
                        defb 240, 0                     ;
                        defb 126, 0                     ;
                        defb 127, 128                   ;
                        defb 127, 224                   ;
                        defb 127, 240                   ;
                        defb 127, 248                   ;
                        defb 0, 8                       ;
                        defb 0, 8                       ;
                        defb 127, 248                   ;
                        defb 126, 48                    ;
                        defb 112, 224                   ;
                        defb 67, 128                    ;
                        defb 126, 0                     ;
                        defb 240, 0                     ;
                        defb 0, 0                       ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GGGG:                   defb 0, 63                      ;
                        defb 1, 226                     ;
                        defb 7, 14                      ;
                        defb 28, 62                     ;
                        defb 49, 254                    ;
                        defb 103, 254                   ;
                        defb 255, 254                   ;
                        defb 128, 0                     ;
                        defb 128, 0                     ;
                        defb 255, 254                   ;
                        defb 127, 254                   ;
                        defb 63, 254                    ;
                        defb 31, 254                    ;
                        defb 7, 254                     ;
                        defb 1, 254                     ;
                        defb 0, 63                      ;

                        defb 252, 0                     ;
                        defb 255, 128                   ;
                        defb 255, 224                   ;
                        defb 255, 248                   ;
                        defb 255, 252                   ;
                        defb 255, 254                   ;
                        defb 255, 255                   ;
                        defb 128, 1                     ;
                        defb 128, 1                     ;
                        defb 255, 255                   ;
                        defb 255, 230                   ;
                        defb 255, 140                   ;
                        defb 252, 56                    ;
                        defb 240, 224                   ;
                        defb 199, 128                   ;
                        defb 252, 0                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LARGE_ALIEN_TORPEDO1_4:

                        defb 0, 0, 0, 0, 7, 255, 255, 224, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 255, 255, 255, 255, 0, 0, 0, 0;
                        defb 0, 0, 0, 31, 224, 31, 255, 255, 248, 0, 0, 0;
                        defb 0, 0, 3, 255, 0, 120, 31, 255, 255, 192, 0, 0;
                        defb 0, 0, 63, 224, 7, 248, 31, 255, 255, 252, 0, 0;
                        defb 0, 1, 252, 0, 255, 248, 31, 255, 255, 255, 128, 0;
                        defb 0, 7, 192, 15, 255, 248, 31, 255, 255, 255, 224, 0;
                        defb 0, 31, 128, 255, 255, 248, 31, 255, 255, 255, 248, 0;
                        defb 0, 126, 3, 255, 255, 248, 31, 255, 255, 255, 254, 0;
                        defb 1, 240, 31, 255, 255, 248, 31, 255, 255, 255, 255, 128;
                        defb 3, 207, 255, 255, 255, 248, 31, 255, 255, 255, 255, 192;
                        defb 7, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 224;
                        defb 15, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 240;
                        defb 31, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 248;
                        defb 63, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 252;
                        defb 63, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124;
                        defb 127, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126;
                        defb 127, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126;
                        defb 255, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127;
                        defb 255, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127;
                        defb 255, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127;
                        defb 127, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126;
                        defb 127, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 254;
                        defb 63, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 252;
                        defb 63, 255, 255, 255, 255, 248, 31, 255, 255, 255, 255, 252;
                        defb 31, 255, 255, 255, 255, 248, 31, 255, 255, 255, 254, 248;
                        defb 15, 255, 255, 255, 255, 248, 31, 255, 255, 255, 225, 240;
                        defb 7, 255, 255, 255, 255, 248, 31, 255, 255, 255, 3, 224;
                        defb 3, 255, 255, 255, 255, 248, 31, 255, 255, 248, 15, 192;
                        defb 1, 255, 255, 255, 255, 248, 31, 255, 255, 224, 127, 128;
                        defb 0, 127, 255, 255, 255, 248, 31, 255, 255, 1, 254, 0;
                        defb 0, 31, 255, 255, 255, 248, 31, 255, 252, 7, 248, 0;
                        defb 0, 3, 255, 255, 255, 248, 31, 255, 240, 63, 192, 0;
                        defb 0, 0, 255, 255, 255, 248, 31, 254, 0, 255, 0, 0;
                        defb 0, 0, 31, 255, 255, 248, 31, 252, 7, 248, 0, 0;
                        defb 0, 0, 1, 255, 255, 255, 255, 255, 255, 128, 0, 0;
                        defb 0, 0, 0, 15, 255, 255, 255, 255, 240, 0, 0, 0;
                        defb 0, 0, 0, 0, 127, 255, 255, 254, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 3, 255, 255, 192, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;

LARGE_ALIEN_TORPEDO2_4:

                        defb 0, 0, 0, 0, 0, 0, 0, 31, 255, 255, 255, 248, 0, 0, 0, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 3, 255, 255, 255, 255, 255, 192, 0, 0, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 15, 255, 255, 255, 255, 255, 255, 255, 240, 0, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 1, 255, 255, 224, 7, 255, 255, 255, 255, 255, 128, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 63, 255, 0, 0, 31, 255, 255, 255, 255, 255, 252, 0, 0, 0, 0;
                        defb 0, 0, 0, 3, 255, 240, 0, 0, 127, 255, 255, 255, 255, 255, 255, 192, 0, 0, 0;
                        defb 0, 0, 0, 15, 248, 0, 15, 255, 254, 0, 255, 255, 255, 255, 255, 240, 0, 0, 0;
                        defb 0, 0, 0, 127, 128, 1, 255, 255, 254, 0, 255, 255, 255, 255, 255, 254, 0, 0, 0;
                        defb 0, 0, 7, 254, 0, 63, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 224, 0, 0;
                        defb 0, 0, 63, 240, 7, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 252, 0, 0;
                        defb 0, 0, 255, 192, 127, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 0, 0;
                        defb 0, 1, 255, 7, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 128, 0;
                        defb 0, 7, 252, 31, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 224, 0;
                        defb 0, 31, 240, 127, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 248, 0;
                        defb 0, 127, 224, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 254, 0;
                        defb 0, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 0;
                        defb 1, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 128;
                        defb 3, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 192;
                        defb 7, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 224;
                        defb 15, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 240;
                        defb 31, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 248;
                        defb 31, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 248;
                        defb 63, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 252;
                        defb 63, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 252;
                        defb 127, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 254;
                        defb 127, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 254;
                        defb 255, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 255;
                        defb 255, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 255;
                        defb 255, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 255;
                        defb 255, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255;
                        defb 255, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255;
                        defb 127, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 254;
                        defb 127, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 254;
                        defb 63, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 252;
                        defb 63, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 252;
                        defb 31, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 255, 255, 248;
                        defb 15, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 254, 15, 240;
                        defb 7, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 248, 31, 224;
                        defb 3, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 224, 63, 192;
                        defb 1, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 128, 127, 128;
                        defb 0, 255, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 255, 1, 255, 0;
                        defb 0, 127, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 252, 7, 254, 0;
                        defb 0, 31, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 240, 15, 248, 0;
                        defb 0, 7, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 255, 192, 63, 224, 0;
                        defb 0, 1, 255, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 254, 0, 255, 128, 0;
                        defb 0, 0, 127, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 240, 7, 254, 0, 0;
                        defb 0, 0, 15, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 255, 0, 31, 240, 0, 0;
                        defb 0, 0, 1, 255, 255, 255, 255, 255, 254, 0, 255, 255, 255, 240, 0, 255, 128, 0, 0;
                        defb 0, 0, 0, 127, 255, 255, 255, 255, 254, 0, 255, 255, 255, 0, 3, 254, 0, 0, 0;
                        defb 0, 0, 0, 15, 255, 255, 255, 255, 254, 0, 255, 255, 0, 0, 63, 240, 0, 0, 0;
                        defb 0, 0, 0, 0, 255, 255, 255, 255, 254, 0, 255, 240, 0, 7, 255, 128, 0, 0, 0;
                        defb 0, 0, 0, 0, 15, 255, 255, 255, 255, 255, 248, 0, 0, 63, 248, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 127, 255, 255, 255, 255, 240, 0, 127, 254, 0, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 3, 255, 255, 255, 255, 241, 255, 255, 192, 0, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 15, 255, 255, 255, 255, 255, 240, 0, 0, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 0, 3, 255, 255, 255, 192, 0, 0, 0, 0, 0, 0, 0;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SELECT_LEVEL_MESSAGE_4:
; Message for left window for Select Level
                        DEFM "TO    "                   ; 30
                        DEFM "START "                   ;
                        DEFM "SELECT"                   ;
                        DEFM "KEYS  "                   ;
                        DEFM "1 - 5 "                   ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SELECT_LEVEL_MESSAGE_BLANK_DATA_4:
; Message for left window for clearing window
                        DEFM "      "                   ; 30
                        DEFM "      "                   ;
                        DEFM "      "                   ;
                        DEFM "      "                   ;
                        DEFM "      "                   ;    124


; Clear basic message (left window)
SELECT_LEVEL_MESSAGE_BLANK_4:

                        LD HL,SELECT_LEVEL_MESSAGE_BLANK_DATA_4;

                        JP SETUP_BASIC_TEXT_4           ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; DISPLAY SELECT LEVEL TEXT
DISPLAY_SELECT_LEVEL_TEXT_4:

                        LD HL,SELECT_LEVEL_MESSAGE_4    ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialise basic text collumn row
SETUP_BASIC_TEXT_4:

                        LD (MESSAGE_POINTER_31231BASIC),HL;

                        LD A,25                         ; 1                          ;  Collumn 1
                        LD (TEXT_COLLUMN_31324BASIC),A  ; Setup text collumn
                        LD A,18                         ; row 18
                        LD (TEXT_ROW_31325BASIC),A      ; Setup text row

                        CALL DISPLAY_TEXT               ;

                        RET                             ; 4

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup 100 sectors for current game

SETUP_SECTORS_4:        ;Setup game sectors             ;

                        LD HL,DEFAULT_SECTOR_DATA1_4    ; Get current level sector field
                        LD A,(LEVEL)                    ; Get level
                        LD DE,20                        ; Setup DE for addition of 20 for each data block

LEVEL_DATA_SELECT_LOOP_4:
                        ADD HL,DE                       ; Add 30 to level data pointer to go to next block
                        DEC A                           ; Take 1 from level selector loop counter
                        JR NZ,LEVEL_DATA_SELECT_LOOP_4  ; Jump back until the correct data block is selected
; Data block is chosen
SKIP_LEVEL_DATA_SELECT_LOOP_4:;Copy the sector default data to the live sector data map;

                        LD DE,SECTOR_DATA_b30624_4      ; Point to second sector. First sector always blank
                        XOR A                           ; A=0
                        LD (DE),A                       ; Setup first sector to nothing
                        INC DE                          ; Move to next sector data location
                        LD A,R                          ; Get random number
                        AND 4                           ; Up to 4
                        ADD A,E                         ; Add to A which is already 0
                        LD E,A                          ; Setup DE for sector data location
                        LD BC,100                       ; 100 sectors to setup, sector 0 always blank
                        LDIR                            ; Copy data

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTOR_DATA_b30624_4:

                        ; 0 No icon                        ;7 Cross ship icon 3
                        ; 1 One alien                      ;8 Cross ship icon 4
                        ; 2 Two aliens                     ;9 Planet icon 1
                        ; 3 Three aliens                   ;10 Planet icon 2
                        ; 4 Large alien icon               ;11 Planet icon 3
                        ; 5 Cross ship icon 1              ;12 Planet icon 4
                        ; 6 Cross ship icon 2
; Default level select data
                        DB 1,1,0,1,0,1                  ;
                        DB 0,1,1,1,0,0                  ;
DEFAULT_SECTOR_DATA1_4:
                        DB 0,1,1,1,0,1                  ;
                        DB 0,0,1,9,1,1                  ;
                        DB 1,0,9,1,0,0                  ;
                        DB 9,0,0,1,9,1                  ;
                        DB 1,1,9,0,0,0                  ;
DEFAULT_SECTOR_DATA2_4:
                        DB 0,9,0,0,1,1                  ;
                        DB 0,1,2,1,0,0                  ;
                        DB 1,1,0,2,0,1                  ;
                        DB 1,2,0,9,0,0                  ;
                        DB 1,9,0,1,2,1                  ;

DEFAULT_SECTOR_DATA3_4:
                        DB 0,0,2,2,0,1                  ;
                        DB 0,10,3,10,2,1                ;
                        DB 2,10,0,2,9,10                ;
                        DB 0,9,10,3,2,1                 ;
                        DB 2,2,10,0,0,0                 ;
DEFAULT_SECTOR_DATA4_4:
                        DB 0,4,0,9,2,1                  ;
                        DB 9,2,2,3,9,0                  ;
                        DB 2,2,9,0,10,1                 ;
                        DB 2,4,0,10,0,0                 ;
                        DB 2,10,9,4,2,1                 ;
DEFAULT_SECTOR_DATA5_4:
                        DB 0,4,3,4,0,1                  ;
                        DB 0,0,2,10,2,1                 ;
                        DB 2,4,0,4,0,2                  ;
                        DB 9,3,0,10,4,3                 ;
                        DB 3,4,0,0,4,0                  ;
DEFAULT_SECTOR_DATA6_4:
                        DB 0,4,4,10,4,4                 ;
                        DB 0,2,2,2,0,0                  ;
                        DB 2,4,10,4,0,1                 ;
                        DB 4,2,0,4,10,0                 ;
                        DB 3,10,4,2,4,4                 ;

DEFAULT_SECTOR_DATA7_4:
                        DB 0,3,4,2,4,1                  ;
                        DB 3,4,2,10,2,1                 ;
                        DB 4,0,10,2,4,0                 ;
                        DB 0,3,4,2,3,3                  ;
                        DB 3,3,4,1,4,0                  ;

                        DB 0,1,4,1,4,0                  ;
                        DB 0,4,1,4,0,1                  ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scroll text in the radar to left 8 pixels.
SCROLLLINELEFTB_4:
                        LD B,8                          ; Move left 8 pixels
; Calls here with B=1 for 1 pixel scroll
OVERAL_SCROLL_LEFT_LOOP_4:
                        PUSH BC                         ; Save BC

                        LD HL,22494-64-32               ; Last screen address location of radar to scroll

                        LD B,4                          ; 4 text lines
SCROLL_PIXEL_LINES2_4:
                        PUSH BC                         ; Save text lines loop
                        PUSH HL                         ; Save address

                        LD B,8                          ; 8 pixel lines
SCROLL_PIXEL_LINES_4:
                        PUSH BC                         ; Save pixel lines loop
                        PUSH HL                         ; Save screen address

                        LD B,5                          ; 5 collumns
                        OR A                            ; Set carry
SCROLLNEXTBYTEB_4:

                        RL (HL)                         ; Rotate left content of screen at HL
                        DEC HL                          ; Move screen location to the left

                        DJNZ SCROLLNEXTBYTEB_4          ; Scroll back to complete all 6 collumns for current text line

                        POP HL                          ; Restore screen address
                        DEC H                           ; Move up 1 hires line

                        POP BC                          ; Restore 8 pixel lines loop
                        DJNZ SCROLL_PIXEL_LINES_4       ; Jump back to scroll all 8 pixel lines for current text line

                        LD B,200                        ;
SCROLL_DELAY_LOOP_4:
                        DJNZ SCROLL_DELAY_LOOP_4        ;

                        POP HL                          ; Restore screen address
                        LD DE,32                        ; Add for top of next text line
                        ADD HL,DE                       ; Move address to bottom of next text line

                        POP BC                          ; Restore text lines loop
                        DJNZ SCROLL_PIXEL_LINES2_4      ; Jump back to complete all text lines

                        POP BC                          ; Restore BC
                        DJNZ OVERAL_SCROLL_LEFT_LOOP_4  ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Radar alien graphics
RADAR_ALIEN_GRAPHICS0_4:;Radar alien graphics           ;

; 0 Blank
                        defb 0, 0, 15, 246, 31, 252, 24, 24, 48, 28, 48, 60, 48, 108, 48, 204;
                        defb 49, 140, 51, 12, 54, 12, 60, 12, 24, 24, 63, 248, 111, 240, 0, 0;


; 1 Alien radar    +32

                        defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 128, 3, 192, 31, 248;
                        defb 63, 252, 15, 240, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;

; 2 Alien radar   +32
                        defb 0, 0, 0, 0, 6, 0, 15, 0, 127, 224, 255, 240, 63, 192, 0, 0;
                        defb 0, 96, 0, 240, 7, 254, 15, 255, 3, 252, 0, 0, 0, 0, 0, 0;

; 3 Alien radar   +32

                        defb 0, 0, 0, 0, 6, 0, 63, 192, 127, 224, 31, 128, 0, 48, 1, 254;
                        defb 3, 255, 0, 252, 0, 0, 12, 0, 127, 128, 255, 192, 63, 0, 0, 0;

; 4 Alien radar   +32
                        defb 6, 0, 63, 192, 127, 224, 31, 128, 0, 48, 1, 254, 3, 255, 0, 252;
                        defb 12, 0, 127, 128, 255, 192, 63, 0, 0, 48, 1, 254, 3, 255, 0, 252;

; Alien planet    +32

                        defb 0, 0, 0, 0, 0, 0, 0, 0, 15, 48, 59, 248, 9, 48, 7, 128;
                        defb 0, 0, 0, 0, 7, 192, 29, 184, 50, 236, 101, 218, 234, 183, 0, 0;

; Landing planet  +32
RADAR_ALIEN_GRAPHICS1_4:
                        defb 0, 0, 3, 192, 13, 176, 18, 232, 37, 220, 42, 188, 69, 254, 83, 246;
                        defb 69, 234, 75, 190, 37, 252, 35, 60, 17, 200, 12, 176, 3, 192, 0, 0;
                        ; 192




                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; 13 BYTES TO LOOKUP HAS TO STAY HERE
                        ;  align 256                       ; Put these on page boundaries
METER_BAR_LOOKUP1_4:    ;39 BYTES                       ;
                        ; DB 0,0,0,0
                        DB %00000000,%00000000,%00000000,0;
                        DB %01000000,%00000000,%00000000,0;
                        DB %01010000,%00000000,%00000000,0;
                        DB %01010100,%00000000,%00000000,0;
                        DB %01010101,%00000000,%00000000,0;
                        DB %01010101,%01000000,%00000000,0;
                        DB %01010101,%01010000,%00000000,0;
                        DB %01010101,%01010100,%00000000,0;
                        DB %01010101,%01010101,%00000000,0;
                        DB %01010101,%01010101,%01000000,0;
                        DB %01010101,%01010101,%01010000,0;
                        DB %01010101,%01010101,%01010100,0;
                        DB %01010101,%01010101,%01010101,0;
                        DB %01010101,%01010101,%01010101,0;
                        DB %01010101,%01010101,%01010101,0;
                        DB %01010101,%01010101,%01010101,0;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Setup data for bars  A=Bar number HAS TO STAY HERE
BARS_SETUP_4:
                        LD IY,METER_BAR_LOOKUP1_4       ; Start of meter bar graphic lookup table
                        ; Lookup meter bar graphics A=graphic block number
                        ADD A,A                         ; Multiply graphic block number by 4
                        ADD A,A                         ;
                        LD E,A                          ; DE=addition for graphic address
                        LD D,0                          ;
                        ADD IY,DE                       ; Add graphic address adiditon to graphic table
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display bars in meters - Called with HL=screen start address
DISPLAY_METER_BARS_4:
                        LD A,5                          ; 5 pixel lines to fill
RESET_POWER_METER_LOOP2_4:
                        PUSH AF                         ; Save outer loop
                        PUSH HL                         ; Save screen address
                        LD A,(IY+0)                     ; Get first meter segment data
                        AND 85                          ; Mask bars
                        LD (HL),A                       ; Set current screen address to graphic
                        INC L                           ; Move to next screen address
                        LD A,(IY+1)                     ; Get second meter segment data
                        AND 85                          ; Mask bars
                        LD (HL),A                       ; Set current screen address to graphic
                        INC L                           ; Move to next screen address
                        LD A,(IY+2)                     ; Get third meter segment data
                        AND 85                          ; Mask bars
                        LD (HL),A                       ; Set current screen address to graphic
                        POP HL                          ; Restore screen address

                        INC H                           ; Move down 1 hires line
                        POP AF                          ; Restore outer loop
                        DEC A                           ; Take 1 from outer loop
                        JR NZ,RESET_POWER_METER_LOOP2_4 ; Jump back to fill all 7 lines
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COLOUR_RADAR_4:
                        LD HL,23129                     ;
                        LD DE,RADAR_ATTR_DATA_4         ;
                        LD B,5                          ;
COLOUR_RADAR_LOOP1_4:
                        PUSH BC                         ;

                        LD B,6                          ;
COLOUR_RADAR_LOOP2_4:
                        LD A,(DE)                       ;
                        LD (HL),A                       ;
                        INC DE                          ;
                        INC HL                          ;
                        DJNZ COLOUR_RADAR_LOOP2_4       ;

                        PUSH DE                         ;
                        LD DE,26                        ;
                        ADD HL,DE                       ;
                        POP DE                          ;
                        POP BC                          ;
                        DJNZ COLOUR_RADAR_LOOP1_4       ;
                        RET                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ATTR data to colour radar
RADAR_ATTR_DATA_4:
                        defb 8, 8, 8, 8, 8, 8           ;
                        defb 8, 5, 5, 8, 8, 8           ;
                        defb 9, 9, 79, 79, 9, 9         ;
                        defb 9, 9, 79, 79, 9, 9         ;
                        defb 8, 8, 8, 8, 8, 8           ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display icons in radar
DISPLAY_RADAR_ICONS_4:  ;Display icons in radar         ;

                        LD A,(SCROLLLINELEFTB_COUNTER)  ; Get scroll radar counter
                        OR A                            ; Is it at 0 for no scrolling hapening?
                        RET NZ                          ; Return if not
DISPLAY_RADAR_ICONSB_4:
; Display sector number in radar


                        LD A,19                         ; Display sector number on row 19
                        LD (TEXT_STRING_COORDINATEX_4+1),A ; UP/DOWN
                        LD A,29                         ; Display sector number on collumn 29
                        LD (TEXT_STRING_COORDINATEY_4+1),A ;    LEFT/RIGH
                        LD A, (RADAR_SELECT_SECTOR_STORE); Get sector number into A
                        LD B,A                          ; Set number to display
                        CALL DISPLAY_NUMBER_4           ; Display the number in the radar

; Display icon in radar
                        CALL GET_RADAR_ICON_POINTER_4     ; Get current sector value into A

                        LD HL,RADAR_ALIEN_GRAPHICS0_4   ; Point HL to Radar icon graphics data (First is blank)

                        OR A                            ; Is the current sector 0?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so

                        LD DE,32                        ; Setup DE for addition

                        ADD HL,DE                       ; Move to next radar icon graphic data
                        CP 1                            ; Is it icon for one alien?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so
                        ADD HL,DE                       ; Move to next radar icon graphic data
                        CP 2                            ; Is it icon for two alien?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so
                        ADD HL,DE                       ; Move to next radar icon graphic data
                        CP 3                            ; Is it icon for three alien?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so
                        ADD HL,DE                       ; Move to next radar icon graphic data
                        CP 4                            ; Is it icon for four alien?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so
; Planet radar icons
                        ADD HL,DE                       ; Move to next radar icon graphic data
                        CP 9                            ; Is it icon for planet confrontation?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so
                        ADD HL,DE                       ; Move to next radar icon graphic data
                        CP 10                           ; Is it icon for landing only planet?
                        JR Z,SKIP_RADAR_ICON_SELECTION  ; Skip selecting icon if so

                        RET                             ;

SKIP_RADAR_ICON_SELECTION:

                        ; HL=Icon graphic data pointer
                        LD (SETUP_NEXT_HALF+1),HL       ;

                        LD B,2                          ; 2 collumns for graphic
DISPLAY_ICON_GRAPHIC_LOOP1:
                        PUSH BC                         ;
                        LD DE,20608+30                  ; DE now holds screen address

                        LD B,2                          ; 2 text lines
DISPLAY8X8_ICON_HALVE2:
                        PUSH BC                         ; Save text lines loop
                        PUSH HL                         ; Save graphic data address
                        PUSH DE                         ; Save start screen address
                        LD B,8                          ; 8 hires lines
DISPLAY8X8_ICON_HALVE:

                        LD A,(HL)                       ; Get icon data
                        LD (DE),A                       ; Place to screen
                        INC HL                          ; Move to next icon data
                        INC HL                          ;
                        INC D                           ;
                        DJNZ DISPLAY8X8_ICON_HALVE      ;

                        POP DE                          ; Restore start screen address
                        ; Move down to next text text row
                        DI
                        EX DE,HL                        ; Swap DE and HL so we can use DE for addition
                        LD DE,32                        ; Setup DE for maths
                        ADD HL,DE                       ; Move down 1 text line
                        EX DE,HL                        ; Swap back DE and HL
                        EI
                        POP HL                          ; Restore icon data pointer
                        LD BC,16                        ; Setup DE for addition
                        ADD HL,BC                       ; Add 16 to HL to move to next graphic data
                        POP BC                          ; Restore text lines loop
                        DJNZ DISPLAY8X8_ICON_HALVE2     ; Jump back for text lines loop

                        ;  PUSH BC                         ; Save all registers
                        ;  PUSH HL                         ;
                        ;  PUSH DE                         ;
                        ;  PUSH BC                         ;
                        ; EXX
                        CALL SCROLLLINELEFTB_4          ; Scroll radar left 8 pixels
                        ; EXX
                        ;  POP BC                          ; Restore all registers
                        ;  POP DE                          ;
                        ;  POP HL                          ;
                        ;  POP BC                          ;



SETUP_NEXT_HALF:        LD HL,0                         ; Restore icon data pointer
                        INC HL                          ;

                        POP BC                          ; Restore graphic collumns loop
                        DJNZ DISPLAY_ICON_GRAPHIC_LOOP1 ; Jump back to complete graphics collumns

                        ; CALL SCROLLLINELEFTB            ; Scroll radar left 8 pixels

                        LD A,8                          ; Set radar scroll counter to 8
                        LD (SCROLLLINELEFTB_COUNTER),A  ; Reset scroll radar counter


                        RET                             ; Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

STORE_POINTER_4:          DB 0
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Restore radar pointer to current sector after L is pressed but no hyperdrive. Also when fire is pressed
RESTORE_RADAR_POINTER_TO_CURRENT_4:
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; Get sector map location
                        LD (STORE_POINTER_4),A
                        ;  LD A,(SECTOR_VALUE_MEMORY)      ; Get current sector value
                        ;  LD (MAP_SELECT_STORE_NUMBER_b30583),A ; Restore radar cursor
                        LD A,(RADAR_MOVE_TIMER)         ;
                        CP 0                            ;
                        CALL Z,DISPLAY_RADAR_ICONSB_4   ;
                        LD A,(STORE_POINTER_4)
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get address for flashing square into HL, A=Sector type
GET_SECTOR_TABLE_POINTER_c30613_4:

                        LD A,(MAP_SELECT_STORE_NUMBER_b30583) ; Map flashing square location store number 0 to 17
GET_RADAR_ICON_4:
                        LD HL,SECTOR_DATA_b30624_4      ; Sector data table used for map and sector select
                        LD D,0                          ; Setup DE for addition
                        LD E,A                          ;
                        ADD HL,DE                       ; Move to correct sector in table
                        LD A,(HL)                       ; Get sector type into A. Used to find out current sector type
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get the current radar icon
GET_RADAR_ICON_POINTER_4:

                        LD A,(RADAR_SELECT_SECTOR_STORE) ; Map flashing square location store number 0 to 17
                        JP GET_RADAR_ICON_4               ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_FIGURES_LOOP_4:       ; B=TOTAL TO INCREMENT HL=DATA LOCATION;
                        PUSH HL                         ; Save data pointer address
                        ; PUSH BC                         ; Save loop
                        CALL INCREMENT_FIGURES          ; Add 1 to the figure
                        ; POP BC                          ; Restore loop
                        POP HL                          ; Restore data pointer
                        DJNZ SET_FIGURES_LOOP_4           ; Jump back until figure is set
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update the sector value - Used at start of each sector
UPDATE_SECTOR_VALUE_4:
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; A=Sector type

                        LD (CURRENT_SECTOR_VALUE),A     ; Update sector value

                        LD A,(RADAR_MOVE_TIMER)         ; Get radar move timer
                        CP 0                            ; Is it 0 for not moved?
                        RET NZ                          ; If we are moving the radar than skip doing any more with radar for now

                        CALL SELECT_LEVEL_MESSAGE_BLANK_4 ; Clear radar


                        CALL DISPLAY_RADAR_ICONSB_4     ; Update radar
SKIP_RESTORING_RADAR_POINTER2:
                        RET                             ; Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset figures
RESET_FIGURE_DATA_4:
                        LD HL,NUMBER_STORE_4              ; Initialise the number
                        LD A,48                         ; A="0"
                        LD (HL),A                       ; Set first figure to 0
                        INC HL                          ; Move to next figure
                        LD (HL),A                       ; Set first figure to 0
                        INC HL                          ; Move to next figure
                        LD (HL),A                       ; Set first figure to 0
                        INC HL                          ; Move to next figure
                        LD (HL),A                       ; Set first figure to 0
                        RET                             ; Return
; -------------------------------------------------------------------------------------------------
; Number data store

NUMBER_STORE_4:           DEFM "0000"                     ;
                        DEFB 255                        ; End of string flag

; ----------------------------------------------------------------------------------------
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display a number Called with B=figure to display
DISPLAY_NUMBER_4:

                        CALL RESET_FIGURE_DATA_4        ; Reset the figure data

                        LD A,B                          ;
                        CP 0                            ; Are we displaying number 0?
                        JR Z,SKIP_NUMBER_INCREMENT_4    ; If so then skip the increment

; Increment the data to the correct string of numbers to display
                        LD HL,NUMBER_STORE_4+3          ; Point to the last digit in the number data store
                        ;   LD C,2                          ;
                        CALL SET_FIGURES_LOOP_4         ;

SKIP_NUMBER_INCREMENT_4:
; Display the figure

                        LD HL,NUMBER_STORE_4+2          ; Point to Score data
TEXT_STRING_COORDINATEX_4:LD D,10                       ; Set screen print row
TEXT_STRING_COORDINATEY_4:LD E,10                       ; Set screen print collumn
                        ; LD B,2                          ;
DISPLAY_NUMBER_LOOP1_4:
                        LD A,(HL)                       ;
                        CP 255                          ;
                        RET Z                           ;

                        PUSH HL                         ;
                        PUSH DE                         ;
                        CALL DISPLAY_8X8_TEXT_c26682    ;
                        POP DE                          ;
                        POP HL                          ;
                        INC HL                          ;
                        INC E                           ;
                        JP DISPLAY_NUMBER_LOOP1_4       ;
                        RET                             ;

Addre4:                  equ *-1
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        if *> 58500                                     ;
                        zeuserror "out of room"         ;
        endif                                           ;



