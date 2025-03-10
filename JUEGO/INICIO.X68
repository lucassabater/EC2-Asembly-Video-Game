CUADRADOPLOT:
    MOVEM.L D0-D5,-(A7)
    
    MOVE.W  #80,D0   
    MOVE.L  #$00808080,D1
    TRAP    #15
    
    MOVE.W  #81,D0   
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    
    CLR.L   D1
    MOVE.W  #87,D0
    MOVE.W  #SCRWIDTH/2,D1
    MOVE.W  #SCRHEIGH/2,D2
    MOVE.W  #CUERPO*3,D3
    MOVE.W  #CUERPO*3,D4
    ADD.W   D1,D3          ; Calcular posición x final del cuadrado
    ADD.W   D2,D4          ; Calcular posición y final del cuadrado
    TRAP    #15  
    
    MOVEM.L (A7)+,D0-D5
    
    RTS
    
    
    

    
    
; -----------------------------------------------------------------------------
UTLPRINT
; PRINT SCREEN CENTERED TEXT
; INPUT    : A0 POINTER TO ZERO-TERMINATED STRING
;            D0.B SCREEN ROW TO PRINT TEXT
; OUTPUT   : D0.B NEXT ROW
; MODIFIES : NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A1,-(A7)
            CLR.B   D1
            MOVE.L  A0,A1
.LOOP       TST.B   (A0)+
            BEQ     .ENDLOOP
            ADDQ.B  #1,D1
            BRA     .LOOP
.ENDLOOP    LSR.B   #1,D1
            SUB.B   #(SCRWIDTH/8)/2,D1
            NEG.B   D1
            ASL.W   #8,D1
            OR.W    D0,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1/A0-A1
            ADDQ.B  #1,D0
            RTS

*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
