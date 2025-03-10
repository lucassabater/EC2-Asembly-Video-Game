*-----------------------------------------------------------
* Title      :
* Written by :
* XMALO   (A0)
* YMALO  2(A0)
* Date       :
* Description:
*-----------------------------------------------------------
INITMALO:

            MOVEM.L D0/A1,-(A7)
            JSR     UTLRAND
            AND.L   #$0000000C,D0
            LEA     .POSMALO,A1
            MOVE.L  (A1,D0),(A0)
            MOVEM.L (A7)+,D0/A1
            RTS

.POSMALO    DC.W    320,0     
            DC.W    320,480      
            DC.W    0,240      
            DC.W    640,240       

    MOVE.W  #320, (A0)
    CMP.L   #0,SPAWN
    BEQ     .SPAWN
    MOVE.W  #0,SPAWN
    BRA     .FIN
.SPAWN
    MOVE.W  #480,SPAWN    
.FIN    
    MOVE.L  (SPAWN),2(A0)
    RTS

MALOUPD:
    MOVEM.L  D0-D3/A1,-(A7)
    LEA     MALOSPED,A1          ; Cargar la dirección de MALOSPED en A1
    MOVE.W  (A1),D4              ; Cargar el valor de MALOSPED en D4
    MOVE.W  (XPROTA),D0
    MOVE.W  (YPROTA),D1
    MOVE.W  (A0),D2
    MOVE.W  2(A0),D3           
    CMP.L   D0,D2        ; Compara XMALO con XPROTA
    
    BGE.S   .checkGreaterX       ; Si XMALO <= XPROTA, revisa si es mayor
    ADD.W    D4,D2          ; Resta 1 a XMALO si XMALO > XPROTA
    BRA.S   .checkY              ; Salta a verificar la variable Y
    
    LEA     MALOSPED,A1          ; Cargar la dirección de MALOSPED en A1
    MOVE.W  (A1),D4              ; Cargar el valor de MALOSPED en D4

.checkGreaterX: 
    CMP.L   D0,D2       ; Compara XMALO con XPROTA
    BGT.S   .increaseXmalo      ; Si XMALO > XPROTA, incrementa XMALO

.checkY:
    CMP.L   D1,D3        ; Compara YMALO con YPROTA
    BGE.S   .checkGreaterY       ; Si YMALO <= YPROTA, revisa si es mayor
    ADD.L   D4,D3          ; Resta 1 a YMALO si YMALO > YPROTA
    BRA.S   .done               ; Salta al final

.checkGreaterY:
    CMP.L   D1,D3        ; Compara YMALO con YPROTA
    BGT.S   .increaseYmalo      ; Si YMALO > YPROTA, incrementa YMALO
    BRA.S   .done               ; Salta al final

.increaseXmalo:
    SUB.W   D4,D2           ; Incrementa XMALO si XMALO > XPROTA
    BRA.S   .checkY              ; Salta a verificar la variable Y

.increaseYmalo:
    SUB.W  D4,D3         ; Incrementa YMALO si YMALO > YPROTA

.done:
    MOVE.W  D2,(A0)
    MOVE.W  D3,2(A0)

    MOVEM.L  (A7)+,D0-D3/A1
    RTS


MALOPLOT:

    MOVEM.L D0-D5,-(A7)
    
    MOVE.W  #80,D0   
    MOVE.L  #$000000FF,D1
    TRAP    #15
    
    MOVE.W  #81,D0   
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    
    CLR.L     D1
    MOVE.W  #87,D0
    MOVE.W  (A0),D1
    MOVE.W  2(A0),D2
    MOVE.W  #CUERPO,D3
    SUB.W   #4,D3
    MOVE.W  #CUERPO,D4
    SUB.W   #4,D4
    ADD.W   D1,D3          ; Calcular posición x final del cuadrado
    ADD.W   D2,D4          ; Calcular posición y final del cuadrado
    TRAP    #15            ; Llamada al sistema para dibujar el cuadrado
    
    MOVE.W  #1,D5
    MOVE.W  #81,D0   
    MOVE.L  #$000000FF,D1
    TRAP    #15
    MOVE.W  #87,D0 
.LOOP:      
    MOVE.W  (A0),D1  ; Posición x inicial del círculo (centrado)
    MOVE.W  2(A0),D2  ; Posición y inicial del círculo (centrado)
    SUB.W   #5,D1          ; Calcular posición x final del círculo
    SUB.W   #17,D2 
    MOVE.W  #31,D3
    MOVE.W  #31,D4
    ADD.W   D1,D3          ; Calul0ar posición x final del círculo
    ADD.W   D2,D4          ; Calcular posición y final del círculo
    TRAP    #15
    MOVE.W  #81,D0   
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    MOVE.W  #88,D0       
    DBRA    D5,.LOOP    

    
    MOVE.W  #80,D0   
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    
    MOVE.W  #88,D0 
    MOVE.W  (A0),D1  ; Posición x inicial del círculo (centrado)
    MOVE.W  2(A0),D2  ; Posición y inicial del círculo (centrado) 
    ADD.W   #17,D1         ; Calcular posición x final del círculo
    SUB.W   #6,D2 
    MOVE.W  #6,D3
    MOVE.W  #6,D4
    ADD.W   D1,D3          ; Calcular posición x final del círculo
    ADD.W   D2,D4          ; Calcular posición y final del círculo
    TRAP    #15            ; Llamada al sistema para dibujar el círculo
    
    MOVE.W  (A0),D1  ; Posición x inicial del círculo (centrado)
    MOVE.W  2(A0),D2  ; Posición y inicial del círculo (centrado) 
    ADD.W   #1,D1          ; Calcular posición x final del círculo
    SUB.W   #8,D2 
    MOVE.W  #10,D3
    MOVE.W  #10,D4
    ADD.W   D1,D3          ; Calcular posición x final del círculo
    ADD.W   D2,D4          ; Calcular posición y final del círculo
    TRAP    #15            ; Llamada al sistema para dibujar el círcuX 

    MOVEM.L (A7)+,D0-D5
    
    RTS
    
    
MALOMUERTE
    
    JSR AGLKILL



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
