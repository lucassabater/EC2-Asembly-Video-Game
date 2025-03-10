; ==============================================================================
; SYSTEM
; ==============================================================================
            
; ------------------------------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.L  #KBDUPD,($80+KBDUPTN*4)
            MOVE.L  #SCRTIM,($60+SCRINTN*4)
            MOVE.L  #MOUREAD,($80+TRNMREAD*4)

            JSR     SCRINIT
            JSR     KBDINIT
            JSR     MOUINIT
            JSR     DMMINIT
            JSR     SNDINIT
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$D8FF,(A7)
            RTE


; ------------------------------------------------------------------------------
SNDINIT
;INICIALIZAMOS EL SONIDO DEL SISTEMA
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)           
            CLR.B   D1
            LEA     .SNDLIST,A0
.LOOP       MOVE.L  (A0)+,D0
            BEQ     .DONE
            MOVE.L  D0,A1
            
            MOVE.B  #71,D0
            TRAP    #15
            ADDQ.B  #1,D1
            
            BRA     .LOOP
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
.SNDHIT     DC.B    'SND/HIT.wav',0
.SNDSHOT    DC.B    'SND/MISS.wav',0
.SNDSLOW    DC.B    'SND/slow.wav',0
.SNDBOOM    DC.B    'SND/explosion.wav',0
.SNDLIST    DC.L    .SNDHIT,.SNDSHOT,.SNDSLOW,.SNDBOOM,0

; ------------------------------------------------------------------------------
SNDPLAY
;SUBRUTINA PARA QUE LOS SONIDOS SE ESCUCHEN
; ------------------------------------------------------------------------------

            MOVEM.W D0-D1,-(A7)
            MOVE.B  #72,D0
            MOVE.B  D7,D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTS
                   
; ------------------------------------------------------------------------------
SCRINIT
; INIT SCREEN. SET SCREEN RESOLUTION, SET WINDOWED MODE, CLEAR SCREEN,
; ENABLE DOUBLE BUFFER, ENABLE TIMED INTERRUPT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D2,-(A7)

            ; SET SCREEN RESOLUTION
            MOVE.B  #33,D0
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1
            TRAP    #15
            
            ; SET WINDOWED MODE
            MOVE.L  #1,D1
            TRAP    #15
            
            ; CLEAR SCREEN
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            JSR     ISCINIT
            
            ; ENABLE DOUBLE BUFFER
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            ; ENABLE TIMED INTERRUPT
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$80|SCRINTN,D2
            MOVE.L  #20,D3
            TRAP    #15
            
            ; CLEAR INTERRUPT COUNTER
            CLR.W   (SCRINTCT)
            
            MOVEM.L (A7)+,D0-D2
            
            RTS

; ------------------------------------------------------------------------------
SCRPLOT
; UPDATES DOUBLE BUFFER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            ; SWITCH BUFFERS
            MOVE.B  #94,D0
            TRAP    #15
            
            ; CLEAR HIDDEN BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTS

; ------------------------------------------------------------------------------
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)
            ADDQ.B  #1,(SCRCYCCT)
            RTE

; ------------------------------------------------------------------------------
KBDINIT
; INIT KEYBOARD
; 7 -> FIRE UP
; 6 -> FIRE LEFT
; 5 -> FIRE DOWN
; 4 -> FIRE RIGHT
; 3 -> UP
; 2 -> LEFT
; 1 -> DOWN
; 0 -> RIGHT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS

KBDUPD
            MOVEM.L D0-D3,-(A7)
            
            ; READ FIRST PART PART
            MOVE.B  #19,D0
            MOVE.L  #$26<<24+$25<<16+$28<<8+$27,D1
            TRAP    #15

            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK
            
            ; READ SECOND PART
            MOVE.B  #19,D0
            MOVE.L  #'W'<<24+'A'<<16+'S'<<8+'D',D1
            TRAP    #15

            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK
            
            ; COMPUTE KBDEDGE
            MOVE.B  (KBDVAL),D0
            NOT.B   D0
            AND.B   D2,D0
            MOVE.B  D0,(KBDEDGE)
            
            ; STORE KBDVAL
            MOVE.B  D2,(KBDVAL)
            
            MOVEM.L (A7)+,D0-D3

            RTE
            
.PACK       MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP
            RTS
; ------------------------------------------------------------------------------
MOUINIT
; INITS MOUSE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.L   (MOUPOSY)
            CLR.W   (MOUBUT)
            RTS

; ------------------------------------------------------------------------------
MOUREAD
; READS MOUSE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #61,D0
            CLR.B   D1
            TRAP    #15
            MOVE.L  D1,(MOUPOSY)
            MOVE.B  (MOUBUT),D1
            MOVE.B  D0,(MOUBUT)
            NOT.B   D1
            AND.B   D1,D0
            MOVE.B  D0,(MOUEDGE)
            MOVEM.L (A7)+,D0-D1
            RTE


















*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
