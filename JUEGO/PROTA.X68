*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

INITPROT:
    MOVE.W  #SCRWIDTH/2,XPROTA
    MOVE.W  #SCRHEIGH/2,YPROTA
    MOVE.W  #0,PROTAPOW
    MOVE.W  #PROTSPED, MALOSPED
    MOVE.W  #0,NDISPAROS
    RTS

PROTUPD:           
    MOVEM.L  D0-D1,-(A7)
    MOVE.L   D7,-(A7)
    ;UPDATE COORDINATE
    MOVE.W  (XPROTA),D0
    ADD.W   #CUERPO/2,D0        
    MOVE.W  (YPROTA),D1
    ADD.W   #CUERPO/2,D1
    BTST.B  #3,(KBDVAL)
    BNE     .CHKUP
    BTST.B  #2,(KBDVAL)
    BNE     .CHKLFT                        
    BTST.B  #1,(KBDVAL)             ;CHECK FOR MOVEMENT
    BNE     .CHKDWN
    BTST.B  #0,(KBDVAL)
    BNE     .CHKRGT
    BRA     .DONE
    
.CHKUP         
    SUB.W   #PROTSPED,D1
    BRA     .COLLUP   
.CHKRGT         
    ADD.W   #PROTSPED,D0                ;MOVEMENT
    BRA     .COLLRGT
.CHKDWN    
    ADD.W   #PROTSPED,D1
    BRA     .COLLDWN
.CHKLFT     
    SUB.W   #PROTSPED,D0
    BRA     .COLLLFT

.COLLUP
    CMP.W   #20,D1
    BHI     .DONE
    ADD.W   #PROTSPED,D1
    BRA     .DONE   
.COLLDWN
    CMP.W   #SCRHEIGH-10,D1             ;COLLISION WITH SCREEN MARGINS
    BLO     .DONE
    SUB.W   #PROTSPED,D1
    BRA     .DONE
.COLLRGT
    CMP.W   #SCRWIDTH-10,D0
    BLO     .DONE
    SUB.W   #PROTSPED,D0
    BRA     .DONE
.COLLLFT
    CMP.W   #20,D0
    BHI     .DONE
    ADD.W   #PROTSPED,D0   
       
.DONE
    MOVE.B  #$00,D7
    SUB.W   #CUERPO/2,D0
    SUB.W   #CUERPO/2,D1       
    MOVE.W  D0,(XPROTA)
    MOVE.W  D1,(YPROTA)
    
    MOVEM.L A1-A3/D2-D3,-(A7)   
    BTST.B  #7,(KBDEDGE)
    BNE     .CHKSHOTU
    BTST.B  #6,(KBDEDGE)
    BNE     .CHKSHOTL                       
    BTST.B  #5,(KBDEDGE)                    ;CHECK FOR SHOOTING
    BNE     .CHKSHOTD
    BTST.B  #4,(KBDEDGE)
    BNE     .CHKSHOTR
    BRA     .COLLISIONEN
    
.CHKSHOTU
    MOVE.W  #2,D3
    BRA .DONE2
.CHKSHOTL                                       ;SET DIRECTION OF SHOT
    MOVE.W  #1,D3
    BRA .DONE2
.CHKSHOTD
    MOVE.W  #3,D3
    BRA .DONE2
.CHKSHOTR
    MOVE.W  #0,D3
      
.DONE2
    MOVE.W  #PROTSPED,MALOSPED
    LEA     SHTINIT,A1
    LEA     SHTUPD,A2                           ;CREATE SHOT
    LEA     SHTPLOT,A3
    MOVE.W  #2,D0
    MOVE.W  (XPROTA),D1
    MOVE.W  (YPROTA),D2
    
    CMP     #0,PROTAPOW
    BNE     .PODER
    JSR     AGLADD
    BRA     .COLLISIONEN
    
.PODER
    CLR D3
    JSR     AGLADD
    ADDQ.W  #1,D3
    JSR     AGLADD
    ADDQ.W  #1,D3
    JSR     AGLADD                              ;CREATE 4 SHOTS IF POWER
    ADDQ.W  #1,D3
    JSR     AGLADD
    SUB.W   #1,NDISPAROS
    CMP     #0,NDISPAROS
    BNE     .COLLISIONEN

.FINPOW
    MOVE.W  #0,PROTAPOW
            
.COLLISIONEN
    MOVE.W  (XPROTA),D2                 
    MOVE.W  (YPROTA),D3                 
    MOVE.W  #CUERPO,D5                      ;COLLISION WITH ENEMYS
    MOVE.W  #CUERPO,D7
    MOVE.W  #1,D0                   
    JSR     DMMFRSTO
.LOOP       
    CMP.L   #0,A0
    BEQ     .END
    MOVE.W  8(A0),D0
    MOVE.W  10(A0),D1
    MOVE.W  #CUERPO,D4
    MOVE.W  #CUERPO,D6
    JSR     UTLCHCOL                            ;LOOP ALL ENEMYS
    TST.B   D0
    BNE     .MUERTE                  
    MOVE.W  #1,D0
    JSR     DMMNEXTO
    BRA     .LOOP
    
.END        
    JSR     AGLKILL                 
    BRA     .END2
    
.MUERTE     
    ADD.L   #8,A0
    JSR     MALOMUERTE                         ;KILL ENEMY
    SUB.W   #1,VIDAS                           ;DECREASE LIFE
    BRA     .END
            
 
.END2   
    MOVEM.L (A7)+,A1-A3/D2-D3
    MOVE.L  (A7)+,D7
    MOVEM.L  (A7)+,D0-D1
    RTS

;-------------------------------------------------------------------------
PROTPLOT:
    MOVEM.L D0-D5/A1,-(A7)
    
    MOVE.W  #80,D0   
    MOVE.L  #$00808080,D1
    TRAP    #15
    
    MOVE.W  #81,D0   
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    
    CLR.L   D1
    MOVE.W  #87,D0
    MOVE.W  (XPROTA),D1
    MOVE.W  (YPROTA),D2
    MOVE.W  #CUERPO,D3
    MOVE.W  #CUERPO,D4
    ADD.W   D1,D3          ; Calcular posición x final del cuadrado
    ADD.W   D2,D4          ; Calcular posición y final del cuadrado
    TRAP    #15            ; Llamada al sistema para dibujar el cuadrado
    
    MOVE.W  #88,D0   
    MOVE.W  (XPROTA),D1  ; Posición x inicial del círculo (centrado)
    MOVE.W  (YPROTA),D2  ; Posición y inicial del círculo (centrado) 
    SUB.W   #5,D1          ; Calcular posición x final del círculo
    SUB.W   #20,D2 
    MOVE.W  #35,D3
    MOVE.W  #35,D4
    ADD.W   D1,D3          ; Calcular posición x final del círculo
    ADD.W   D2,D4          ; Calcular posición y final del círculo
    TRAP    #15            ; Llamada al sistema para dibujar el círculo
    
    MOVE.W  #81,D0   
    MOVE.L  #$00808080,D1
    TRAP    #15
    
    MOVE.W  #80,D0   
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    
    MOVE.W  #88,D0 
    MOVE.W  (XPROTA),D1  ; Posición x inicial del círculo (centrado)
    MOVE.W  (YPROTA),D2  ; Posición y inicial del círculo (centrado) 
    ADD.W   #17,D1       ; Calcular posición x final del círculo
    SUB.W   #6,D2 
    MOVE.W  #6,D3
    MOVE.W  #6,D4
    ADD.W   D1,D3          ; Calcular posición x final del círculo
    ADD.W   D2,D4          ; Calcular posición y final del círculo
    TRAP    #15            ; Llamada al sistema para dibujar el círculo
    
    MOVE.W  (XPROTA),D1  ; Posición x inicial del círculo (centrado)
    MOVE.W  (YPROTA),D2  ; Posición y inicial del círculo (centrado) 
    ADD.W   #1,D1          ; Calcular posición x final del círculo
    SUB.W   #8,D2 
    MOVE.W  #10,D3
    MOVE.W  #10,D4
    ADD.W   D1,D3          ; Calcular posición x final del círculo
    ADD.W   D2,D4          ; Calcular posición y final del círculo
    TRAP    #15            ; Llamada al sistema para dibujar el círculo
    
    MOVE.W  (VIDAS),D5
    MOVE.W  #VIDA1_X,D1
    MOVE.W  #VIDAS_Y,D2  ; Posición y inicial del círculo (centrado)  
    MOVE.W  D1,D3
    MOVE.W  D2,D4
    ADD.W   #VIDA_TAM,D3          ; Calcular posición x final del círculo
    ADD.W   #VIDA_TAM,D4          ; Calcular posición y final del círculo
    TRAP    #15                   ; Llamada al sistema para dibujar el círculo
    CMP     #0,D5
    BLE     .END_VIDAS
    MOVE.W  #VIDA2_X,D1
    MOVE.W  D1,D3
    ADD.W   #VIDA_TAM, D3
    TRAP    #15
    CMP     #1,D5
    BLE     .END_VIDAS
    MOVE.W  #VIDA3_X,D1
    MOVE.W  D1,D3
    ADD.W   #VIDA_TAM, D3
    TRAP    #15
    
.END_VIDAS    
    

    MOVE.W  #TXT_X<<8|TXT_Y, D1
    MOVE.B  #11,D0
    TRAP    #15
    CLR.L   D1
    MOVE.W  (PUNTUACION),D1
    MOVE.B  #17,D0
    TRAP    #15
       
    MOVEM.L (A7)+,D0-D5/A1
    
    RTS












*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
