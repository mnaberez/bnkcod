    .area CODE1 (ABS)
    .org 0xa000

    index = 0x1f            ;Pointer: Utility (various uses)
    cinv = 0x90             ;BASIC 2-4 CINV interrupt vector
    cbinv = 0x92            ;BASIC 2-4 BRK instruction interrupt vector
    bufpnt1 = 0xbb          ;Pointer: Tape I/O Buffer #1
    bufpnt2 = 0xbc          ;Pointer: Tape I/O Buffer #1
    bitci = 0xbe            ;Cassette temp
    mem_00ff = 0x00ff       ;Unused
    stack = 0x0100          ;Bottom of the stack
    mem_03fa = 0x03fa       ;Usused
    mem_03fb = 0x03fb       ;Unused
    expram   = 0x9000       ;SuperPET expansion RAM area
    mem_e455 = 0xe455       ;EDITOR
    mem_e600 = 0xe600       ;EDITOR
    banksel  = 0xeffc       ;SuperPET bank select latch
    mem_fcc0 = 0xfcc0       ;KERNAL

lab_a000:
    jmp [expram]            ;a000  6c 00 90

lab_a003:
    sei                     ;a003  78
    ldx #0x34               ;a004  a2 34
    stx cinv                ;a006  86 90
    ldx #0xa0               ;a008  a2 a0
    stx cinv+1              ;a00a  86 91
    ldx #0x69               ;a00c  a2 69
    stx cbinv               ;a00e  86 92
    ldx #0xa0               ;a010  a2 a0
    stx cbinv+1             ;a012  86 93
    cli                     ;a014  58
    ldx #0x00               ;a015  a2 00
    stx bitci               ;a017  86 be
    stx bufpnt1             ;a019  86 bb
    stx bufpnt2             ;a01b  86 bc
    rts                     ;a01d  60

lab_a01e:
    jsr mem_fcc0            ;a01e  20 c0 fc
    lda #0x78               ;a021  a9 78
    sta cbinv               ;a023  85 92
    lda #0xd4               ;a025  a9 d4
    sta cbinv+1             ;a027  85 93
    lda #0xa4               ;a029  a9 a4
    sta mem_03fa            ;a02b  8d fa 03
    lda #0xd7               ;a02e  a9 d7
    sta mem_03fb            ;a030  8d fb 03
    rts                     ;a033  60

lab_a034:
    lda stack+5,x           ;a034  bd 05 01
    cmp #0x2b               ;a037  c9 2b
    bne lab_a045            ;a039  d0 0a
    lda stack+6,x           ;a03b  bd 06 01
    cmp #0xf9               ;a03e  c9 f9
    bne lab_a045            ;a040  d0 03
    jsr mem_fcc0            ;a042  20 c0 fc

lab_a045:
    lda #0xa0               ;a045  a9 a0
    pha                     ;a047  48
    lda #0x52               ;a048  a9 52
    pha                     ;a04a  48
    php                     ;a04b  08
    pha                     ;a04c  48
    pha                     ;a04d  48
    pha                     ;a04e  48
    jmp mem_e455            ;a04f  4c 55 e4

lab_a052:
    lda expram+2            ;a052  ad 02 90
    pha                     ;a055  48
    lda expram+3            ;a056  ad 03 90
    sta banksel             ;a059  8d fc ef
    jsr sub_a066            ;a05c  20 66 a0
    pla                     ;a05f  68
    sta banksel             ;a060  8d fc ef
    jmp mem_e600            ;a063  4c 00 e6

sub_a066:
    jmp [expram+4]          ;a066  6c 04 90

lab_a069:
    lda index               ;a069  a5 1f
    pha                     ;a06b  48
    lda index+1             ;a06c  a5 20
    pha                     ;a06e  48
    ldy stack+6,x           ;a06f  bc 06 01
    lda stack+5,x           ;a072  bd 05 01
    bne lab_a078            ;a075  d0 01
    dey                     ;a077  88

lab_a078:
    sty index+1             ;a078  84 20
    tay                     ;a07a  a8
    dey                     ;a07b  88
    sty index               ;a07c  84 1f
    ldy #0x00               ;a07e  a0 00
    lda [index],y           ;a080  b1 1f
    tay                     ;a082  a8
    pla                     ;a083  68
    sta index+1             ;a084  85 20
    pla                     ;a086  68
    sta index               ;a087  85 1f
    tya                     ;a089  98
    bmi lab_a0aa            ;a08a  30 1e

    .byte 0x9d, 0xff, 0x00  ;force absolute addressing for identical assembly
   ;sta mem_00ff,x          ;a08c  9d ff 00

    ldy #0x06               ;a08f  a0 06
lab_a091:
    pla                     ;a091  68
    sta stack,x             ;a092  9d 00 01
    inx                     ;a095  e8
    dey                     ;a096  88
    bne lab_a091            ;a097  d0 f8
    lda expram+2            ;a099  ad 02 90
    pha                     ;a09c  48
    txa                     ;a09d  8a
    sec                     ;a09e  38
    sbc #0x08               ;a09f  e9 08
    tax                     ;a0a1  aa
    txs                     ;a0a2  9a
    pla                     ;a0a3  68
    sta banksel             ;a0a4  8d fc ef
    jmp mem_e600            ;a0a7  4c 00 e6

lab_a0aa:
    lda stack+7,x           ;a0aa  bd 07 01
    pha                     ;a0ad  48
    ldy #0x06               ;a0ae  a0 06

lab_a0b0:
    lda stack+6,x           ;a0b0  bd 06 01
    sta stack+7,x           ;a0b3  9d 07 01
    dex                     ;a0b6  ca
    dey                     ;a0b7  88
    bne lab_a0b0            ;a0b8  d0 f6
    pla                     ;a0ba  68
    sta banksel             ;a0bb  8d fc ef
    pla                     ;a0be  68
    jmp mem_e600            ;a0bf  4c 00 e6
