; ==============================================================================
; INTRO SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
ISCINIT
; INTRO SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
    MOVEM.L D0-D4/A0-A1,-(A7)
    
    MOVE.W  #80, D0
    MOVE.L  #00000001,D1
    TRAP    #15
    ADDQ    #1,D0
    TRAP    #15
    
    ADDQ    #6,D0
    CLR     D1
    MOVE.W  #0, D1
    MOVE.W  #0,D2
    MOVE.W  #SCRHEIGH,D3
    MOVE.W  #SCRWIDTH,D4
    TRAP    #15
    
    
    LEA     IMAGEN, A0
    MOVE.W  #SCRHEIGH-1, D4   ; Inicializamos el índice Y (fila);
.ROW_LOOP:
    MOVE.W  #SCRWIDTH-1, D3  ; Inicializamos el índice X (columna)
.COL_LOOP:
    ; Cargamos el color de la variable en D1
    MOVE.W  #80, D0
    
    MOVE.L  (A0)+, D1
    CMP     #00000001,D1
    BEQ     .SALTO
    TRAP    #15

    ; Dibujar el píxel
    ADDQ    #2, D0         ; Código para dibujar el píxel
    MOVE.W  D3, D1           ; Coordenada X
    MOVE.W  D4, D2           ; Coordenada Y
    TRAP    #15              ; Dibujar el píxel en pantalla
.SALTO
    DBRA    D3, .COL_LOOP     ; Decrementar contador de columnas y repetir si no es cero
    DBRA    D4, .ROW_LOOP     ; Decrementar contador de filas y repetir si no es cero
    
    MOVE.W  #80,D0
    MOVE.L  #$00FFFFFF,D1
    TRAP    #15
    ADDQ.W  #1,D0
    MOVE.L  #$00808080,D1
    TRAP    #15
        
    MOVE.W  #270,D1           ; X inicio
    MOVE.W  #140,D2           ; Y inicio
    MOVE.W  #370,D3           ; Ancho
    MOVE.W  #190,D4           ; Alto
    ADDQ.B  #6,D0
    TRAP    #15
    
    MOVE.W  #270,D1           ; X inicio
    MOVE.W  #220,D2           ; Y inicio
    MOVE.W  #370,D3           ; Ancho
    MOVE.W  #270,D4           ; Alto
    TRAP    #15

    ; Mostrar mensaje
    MOVE.W   #300, D1            ; Coordenada X del texto
    MOVE.W   #161, D2            ; Coordenada Y del texto
    LEA      JUGARTXT,A1         ; Cargar dirección del texto
    MOVE.B   #95, D0             ; Tarea para mostrar texto gráfico
    TRAP     #15               ; Muestra el mensaje "HAS PERDIDO"
        
    ; Mostrar mensaje
    MOVE.W   #300, D1            ; Coordenada X del texto
    MOVE.W   #241, D2            ; Coordenada Y del texto
    LEA      OPCIONESTXT, A1          ; Cargar dirección del texto
    TRAP     #15
 
    MOVE.B  #94, D0      ; Código para intercambiar los buffers
    TRAP    #15 

    MOVEM.L (A7)+,D0-D4/A0-A1
  RTS



; ------------------------------------------------------------------------------
ISCUPD
; INTRO SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

        MOVEM.L D0-D4,-(A7)
        MOVE.L  (MOUPOSY),D1     ; Mover las coordenadas del ratón a D1
        MOVE.B  (MOUEDGE),D0      ; Mover el estado del botón a D0
        TST.B   D0           ; Comprobar si se hizo clic (Bit 0 = clic izquierdo)
        BEQ     .END             ; Salir si no hay clic

        ; Desglosar las coordenadas X, Y del ratón
        MOVE.W  D1,D3            ; Mover coordenada X a D3
        SWAP    D1               ; Intercambiar palabras para obtener la coordenada Y
        MOVE.W  D1,D4            ; Mover coordenada Y a D4
        
        ; Verificar si el clic está dentro del cuadrado
        CMP.W   #271,D3          ; Comparar X con el lado izquierdo del cuadrado
        BLO     .END             ; Si X < 279, no está dentro
        CMP.W   #369,D3          ; Comparar X con el lado derecho del cuadrado (220+200)
        BHI     .END             ; Si X > 369, no está dentro

        CMP.W   #221,D4          ; Comparar Y con la parte superior del cuadrado
        BLO     .BOTON2             ; Si Y < 221, no está dentro
        CMP.W   #269,D4          ; Comparar Y con la parte inferior del cuadrado (190+100)
        BHI     .BOTON2             ; Si Y > 269, no está dentro
        
        MOVE.W  #3,(STANEXT)     ; Realiza la acción deseada
        JSR     SCRPLOT
        BRA     .END

.BOTON2               
        CMP.W   #141,D4          ; Comparar Y con la parte superior del cuadrado
        BLO     .END             ; Si Y < 149, no está dentro
        CMP.W   #189,D4          ; Comparar Y con la parte inferior del cuadrado (190+100)
        BHI     .END             ; Si Y > 179, no está dentro

                                  ; Si se llega aquí, el clic está dentro del cuadrado
        MOVE.W  #1,(STANEXT)     ; Realiza la acción deseada
        BRA     .END
.END:
        MOVEM.L  (A7)+,D0-D4
        RTS                     ; Retorna de la subrutina

; ------------------------------------------------------------------------------
ISCPLOT
; INTRO SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
        RTS


















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
