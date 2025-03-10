; ==============================================================================
; INTRO SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
HELPINIT
; INTRO SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
   RTS


; ------------------------------------------------------------------------------
HELPUPD
; INTRO SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

        MOVEM.L D0-D4,-(A7)
        MOVE.L  (MOUPOSY),D1     ; Mover las coordenadas del ratón a D1
        MOVE.B  (MOUEDGE),D0      ; Mover el estado del botón a D0
        TST.B   D0               ; Comprobar si se hizo clic (Bit 0 = clic izquierdo)
        BEQ     .END             ; Salir si no hay clic

        ; Desglosar las coordenadas X, Y del ratón
        MOVE.W  D1,D3            ; Mover coordenada X a D3
        SWAP    D1               ; Intercambiar palabras para obtener la coordenada Y
        MOVE.W  D1,D4            ; Mover coordenada Y a D4

        ; Verificar si el clic está dentro del cuadrado
        CMP.W   #539,D3          ; Comparar X con el lado izquierdo del cuadrado
        BLO     .END             ; Si X < 266, no está dentro
        CMP.W   #609,D3          ; Comparar X con el lado derecho del cuadrado (220+200)
        BHI     .END             ; Si X > 379, no está dentro

        CMP.W   #401,D4          ; Comparar Y con la parte superior del cuadrado
        BLO     .END             ; Si Y < 150, no está dentro
        CMP.W   #449,D4          ; Comparar Y con la parte inferior del cuadrado (190+100)
        BHI     .END             ; Si Y > 186, no está dentro

                                  ; Si se llega aquí, el clic está dentro del cuadrado
        MOVE.W  #0,(STANEXT)     ; Realiza la acción deseada
.END:
        MOVEM.L  (A7)+,D0-D4
        RTS                     ; Retorna de la subrutina

; ------------------------------------------------------------------------------
HELPPLOT
; INTRO SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
        MOVEM.L D0-D4/A0-A1,-(A7)
    
    
    MOVE.W  #80,D0
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    ADDQ.W  #1,D0
    MOVE.L  #$00808080,D1
    TRAP    #15
        
    MOVE.W  #50,D1            ; X inicio
    MOVE.W  #100,D2           ; Y inicio
    MOVE.W  #100,D3           ; Ancho
    MOVE.W  #150,D4           ; Alto
    ADDQ.B  #6,D0
    TRAP    #15
    
    MOVE.W  #105,D1           ; X inicio
    MOVE.W  #100,D2           ; Y inicio
    MOVE.W  #155,D3           ; Ancho
    MOVE.W  #150,D4           ; Alto
    TRAP    #15
    
    MOVE.W  #105,D1           ; X inicio
    MOVE.W  #50,D2           ; Y inicio
    MOVE.W  #155,D3           ; Ancho
    MOVE.W  #100,D4           ; Alto
    TRAP    #15
    
    MOVE.W  #160,D1           ; X inicio
    MOVE.W  #100,D2           ; Y inicio
    MOVE.W  #210,D3           ; Ancho
    MOVE.W  #150,D4           ; Alto
    TRAP    #15
    
    MOVE.W  #500,D1           ; X inicio
    MOVE.W  #400,D2           ; Y inicio
    MOVE.W  #610,D3           ; Ancho
    MOVE.W  #450,D4           ; Alto
    TRAP    #15
    
    MOVE.B  #81,D0
    MOVE.L  #$00ff0000,D1
    TRAP    #15
    MOVE.B  #88,D0
    
    MOVE.W  #105,D1           ; X inicio
    MOVE.W  #200,D2           ; Y inicio
    MOVE.W  #155,D3           ; Ancho
    MOVE.W  #250,D4           ; Alto
    TRAP    #15
    
    MOVE.B  #81,D0
    MOVE.L  #$0000FF00,D1
    TRAP    #15
    MOVE.B  #88,D0
    
    MOVE.W  #105,D1           ; X inicio
    MOVE.W  #260,D2           ; Y inicio
    MOVE.W  #155,D3           ; Ancho
    MOVE.W  #310,D4           ; Alto
    TRAP    #15
    
    MOVE.B  #81,D0
    MOVE.L  #$000000FF,D1
    TRAP    #15
    MOVE.B  #88,D0
 
    MOVE.W  #105,D1           ; X inicio
    MOVE.W  #320,D2           ; Y inicio
    MOVE.W  #155,D3           ; Ancho
    MOVE.W  #370,D4           ; Alto
    TRAP    #15
    
    MOVE.B  #81,D0
    MOVE.L  #$00000000,D1
    TRAP    #15
    
    ; Mostrar mensaje
    MOVE.W   #250, D1            
    MOVE.W   #100, D2            
    LEA      ATUDA1TXT,A1         
    MOVE.B   #95, D0             
    TRAP     #15                 
        
    ; Mostrar mensaje
    MOVE.W   #250, D1            
    MOVE.W   #150, D2            
    LEA      ATUDA2TXT, A1          
    TRAP     #15
    
    ; Mostrar mensaje
    MOVE.W   #200, D1            
    MOVE.W   #200, D2            
    LEA      ATUDA3TXT, A1          
    TRAP     #15
    
    ; Mostrar mensaje
    MOVE.W   #200, D1            
    MOVE.W   #250, D2            
    LEA      ATUDA4TXT, A1          
    TRAP     #15

    ; Mostrar mensaje
    MOVE.W   #200, D1            
    MOVE.W   #300, D2            
    LEA      ATUDA5TXT, A1          
    TRAP     #15 
    
    ; Mostrar mensaje
    MOVE.W   #200, D1            
    MOVE.W   #350, D2            
    LEA      ATUDA6TXT, A1          
    TRAP     #15
    
    MOVE.B  #81,D0
    MOVE.L  #$00808080,D1
    TRAP    #15
    
    MOVE.W   #535, D1            
    MOVE.W   #421, D2            
    LEA      ATRASTXT, A1 
    MOVE.B   #95, D0          
    TRAP     #15 
            
    JSR SCRPLOT

    MOVEM.L (A7)+,D0-D4/A0-A1
  RTS        


















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
