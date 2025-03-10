; =============================================================================
; SHOT MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 TIPO DE DISPARO 
; =============================================================================

; -----------------------------------------------------------------------------
SHTINIT
; INITALIZES A SHOT
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
;            D1.W INITIAL X COORDINATE
;            D2.W INITIAL Y COORDINATE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)
            MOVE.W  D3,4(A0)
            RTS

; -----------------------------------------------------------------------------
SHTUPD
; UPDATES A SHOT BY MOVING IN FUNCTION OF 4(A0).
; 
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L A0-A1/D0-D7,-(A7)
            CMP.W #0,4(A0)         
            BEQ .ES_CERO          
            CMP.W #1,4(A0)         
            BEQ .ES_UNO                     
            CMP.W #2,4(A0)         
            BEQ .ES_DOS                   
            CMP.W #3,4(A0)         
            BEQ .ES_TRES          

.ES_CERO:
            ADD.W  #SHOTSPEED, (A0)
            BRA .COLLISION

.ES_UNO:
            SUB.W  #SHOTSPEED, (A0)
            BRA .COLLISION

.ES_DOS: 
            SUB.W   #SHOTSPEED, 2(A0)
            BRA .COLLISION

.ES_TRES:
            ADD.W   #SHOTSPEED, 2(A0)           
            
.COLLISION
            JSR CHKOBSTS
            TST.B D7
            BGE .END
            
            MOVE.W  (A0),D2                 ; PREPARE SHOT COORDINATES FOR
            MOVE.W  2(A0),D3                ; COLLISION CHECK   
            MOVE.W  #SHTWIDTH,D5
            MOVE.W  #SHTWIDTH,D7
            MOVE.L  A0,A1
            MOVE.W  #1,D0             ; LOOP THROUGH ALL ASTEROIDS
            JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .END
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            MOVE.W  #CUERPO,D4
            MOVE.W  #CUERPO,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .MUERTE                  ; IF COLLISION, EXPLODE IT
            MOVE.W  #1,D0
            JSR     DMMNEXTO
            BRA     .LOOP
            
.END        JSR     AGLKILL                 ; DESTROY SHOT
            MOVEM.L (A7)+,A0-A1/D0-D7
            RTS
            
.MUERTE   
            JSR     UTLRAND
            MOVE.W  D0, D7
            AND.B   #%00000111, D7
            TST.B   D7
            BNE     .NOSUELTA     
            
            CLR.W   D4            
            MOVE.W  D0, D7
            AND.B   #%00100000, D7
            TST.B   D7
            BEQ     .SPAWNOBJ
            ADDQ.W  #1,D4
            MOVE.W  D0, D7
            AND.B  #%01000000, D7
            TST.B   D7        
            BEQ .SPAWNOBJ                     
            ADDQ.W  #1,D4
            
.SPAWNOBJ   
            MOVE.W  D2,D1
            MOVE.W  D3,D2
            MOVE.W  D4,D3
            MOVE.W  #3,D0
            LEA     OBJINIT,A1
            LEA     OBJUPD,A2
            LEA     OBJPLOT,A3
            JSR     AGLADD
                                      
.NOSUELTA
            ADD.L   #8,A0
            JSR     MALOMUERTE             ; EXPLODE ASTEROID
            MOVE.L  A1,A0
            ADD.W   #ENEMSCORE,(PUNTUACION)    ; INCREASE SCORE
            BRA     .END
            
            
            
            RTS
            
; -----------------------------------------------------------------------------
SHTPLOT
; PLOTS THE SHOT.
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L     D0-D4,-(A7)
            
            MOVE.W      #80,D0   
            MOVE.L      #$00FFFFFF,D1
            TRAP        #15
            ADDQ.W      #1,D0
            TRAP        #15
            MOVE.W      (A0),D1
            MOVE.W      2(A0),D2
            MOVE.W      D1,D3
            MOVE.W      D2,D4
            ADD.W       #SHTHEIGH,D3
            ADD.W       #SHTHEIGH,D4
            MOVE.B      #87,D0
            TRAP        #15
            MOVEM.L     (A7)+,D0-D4
            RTS



CHKOBSTS
    MOVEM.L D0-D6/A4,-(A7)          ; STORE REGISTERS

    MOVE.W  2(A0),D0            ; Posición y del jugador
    DIVU.W  #MAPTILEL,D0            ; Dividir por el tamaño de los bloques para obtener la fila
    MOVE.W  (A0),D1            ; Posición x del jugador
    DIVU.W  #MAPTILEL,D1            ; Dividir por el tamaño de los bloques para obtener la columna

    MOVE.W  #MAPSCH,D2             ; Número de columnas en el mapa
    MULU.W  D0,D2                  ; MAPDATA = RowPos * NumColumns + ColumnPos
    ADD.W   D1,D2
    LEA     MAPDATA,A4              ; Obtener la dirección base de MAPDATA
    ADD.W   D2,A4                   ; Apuntar a la posición específica en MAPDATA

    MOVE.B  (A4),D6                 ; Obtener el valor de la celda en MAPDATA

    BTST    #0,D6                   ; ¿Es un obstáculo?
    BEQ     .END                    ; NO: Indicarlo
    MOVE.B  #$FF,D0                 ; SÍ: Preparar salida $FF

.END        MOVE.B  D0,D7             ; Salida preparada
    MOVEM.L (A7)+,D0-D6/A4          ; Restaurar registros
    RTS



; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS









*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
