
; -----------------------------------------------------------------------------
GAMEINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     INITPROT
            MOVE.W  #2,VIDAS
            MOVE.W  #0,PUNTUACION
            
            JSR DMMINIT
            RTS

; -----------------------------------------------------------------------------

; ------------------------------------------------------------------------------
GAMEUPD
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
        MOVEM.L D0/A0-A3,-(A7)
        MOVE.B  (SCRCYCCT),D0
        CMP.W   #100,PUNTUACION     ; Compara PUNTUACION con 100
        BLO     lessThan100         ; Salta si PUNTUACION < 100
        CMP.W   #500,PUNTUACION     ; Compara PUNTUACION con 500
        BLO     between100And500    ; Salta si 100 <= PUNTUACION < 500
        CMP.W   #800,PUNTUACION     ; Compara PUNTUACION con 800
        BLO     between500And800    ; Salta si 500 <= PUNTUACION < 800
        BRA     between800And1000   ; Si no, está entre 800 y 1000

lessThan100:
        AND.B   #%00111111,D0       ; Aplica si PUNTUACION < 100
        BRA     endCheck            ; Salta al final

between100And500:
        AND.B   #%00011111,D0       ; Aplica si 100 <= PUNTUACION < 500
        BRA     endCheck            ; Salta al final

between500And800:
        AND.B   #%00001111,D0       ; Aplica si 500 <= PUNTUACION < 800
        BRA     endCheck            ; Salta al final

between800And1000:
        AND.B   #%00000111,D0       ; Aplica si 800 <= PUNTUACION <= 1000

endCheck:   
        BNE     .GOUPD
        LEA     INITMALO,A1
        LEA     MALOUPD,A2
        LEA     MALOPLOT,A3
        MOVE.W  #1,D0
        JSR     AGLADD
.GOUPD          
        JSR     PROTUPD
        JSR     AGLUPD
                
        BTST    #0,(VIDAS)
        BNE     .NEXT  
        CMP     #1000,PUNTUACION
        BGE     .NEXT
        BRA     .END
                

.NEXT
        MOVE.W  #2,(STANEXT)
.END
        MOVEM.L (A7)+,D0/A0-A3
        RTS

; ------------------------------------------------------------------------------


; ------------------------------------------------------------------------------
GAMEPLOT
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
    JSR     MAPPRINT
    JSR     AGLPLOT
    JSR     PROTPLOT
    JSR     SCRPLOT
    RTS















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
