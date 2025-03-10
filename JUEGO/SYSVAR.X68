; --- KEYBOARD RELATED VARIABLES ----------------------------------------------
KBDVAL   DS.B    1
KBDEDGE DS.B    1
; --- MOUSE -------------------------------------------------------------------
MOUPOSY     DS.W    1                       ; MOUSE Y COORDINATE
MOUPOSX     DS.W    1                       ; MOUSE X COORDINATE
MOUBUT      DS.B    1                       ; MOUSE BUTTONS STATE
MOUEDGE     DS.B    1                       ; MOUSE BUTTONS EDGE
            DS.W    0            
            
; --- TIMED INTERRUPT RELATED VARIABLES ----------------------------------------

SCRINTCT    DS.B    1                       ; INTERRUPT COUNTER
SCRCYCCT    DS.B    1
            DS.W    0




*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
